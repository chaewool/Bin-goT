from apscheduler.schedulers.background import BackgroundScheduler
from apscheduler.triggers.cron import CronTrigger
from django_apscheduler.jobstores import register_events
from django.conf import settings
from datetime import date, timedelta
import logging

from commons import RedisRanker, send_to_fcm, send_badge_notification
from groups.models import Group


logger = logging.getLogger('accounts')


def every_day():
    logger.info("매일 9시 작업 수행")

    groups = Group.objects.all()
    today = date.today()
    
    for group in groups:
        # 시작일 7일 전, 시작 예정 알림
        if today == group.start - timedelta(days=7):
            title = f'{group.groupname} 그룹의 시작까지 7일 남았습니다.'
            content = f'빙고에 참여할 준비 됐나요?'
            path = f'groups/{group.id}/myboard'
            users = [user for user in group.users.all() if user.noti_due]
            
            send_to_fcm('', group, title, content, path, users)
        
        # 시작일, 시작 알림
        elif today == group.start:
            title = f'{group.groupname} 그룹이 시작했습니다!'
            content = f'빙고를 함께 채워볼까요?'
            path = f'groups/{group.id}/myboard'
            
            send_to_fcm('', group, title, content, path)
        
        # 종료일 7일 전, 남은 기간 알림
        elif today == group.end - timedelta(days=7):
            title = f'{group.groupname} 그룹의 종료까지 7일 남았습니다.'
            content = f'열심히 참여해서 빈 곳을 채워보세요!'
            path = f'groups/{group.id}/myboard'
            users = [user for user in group.users.all() if user.noti_due]
            
            send_to_fcm('', group, title, content, path, users)
        
        # 종료일, 순위 알림
        elif today == group.end:
            ranker = RedisRanker(str(group.id))
            
            title = f'{group.groupname} 그룹의 빙고가 종료되었습니다.'
            path = f'groups/{group.id}/rank'

            users = group.users.all()
            for user in users:
                rank = ranker.getRank(str(user.id))
                if rank == -1:
                    content = '채워진 칸이 없어 순위가 집계되지 않았습니다.'
                else:
                    content = f'당신의 등수는 {rank}등입니다.'
                send_to_fcm(user, '', title, content, path)
                
                if rank == 1:
                    user.cnt_rank1 += 1
                    user.save()
                                
                    if user.cnt_rank1 == 1:
                        send_badge_notification(user, 14)
                    elif user.cnt_rank1 == 5:
                        send_badge_notification(user, 15)


# 매주 월요일, 현재 순위 알림
def every_monday():
    logger.info("매주 월요일 9시 작업 수행")
    
    groups = Group.objects.all()
    
    for group in groups:
        ranker = RedisRanker(str(group.id))
        
        title = f'{group.groupname} 그룹의 현재 순위를 확인해보세요.'
        path = f'groups/{group.id}/rank'

        users = group.users.all()
        for user in users:
            if user.noti_rank:
                rank = ranker.getRank(str(user.id))
                if rank == -1:
                    content = '채워진 칸이 없어 순위가 집계되지 않았습니다.'
                else:
                    content = f'당신의 등수는 {rank}등입니다.'
                send_to_fcm(user, '', title, content, path)


def start():
    scheduler = BackgroundScheduler(timezone=settings.TIME_ZONE)
    register_events(scheduler)

    scheduler.add_job(
        every_day,
        trigger=CronTrigger(day="*", hour="09", minute="00"),
        id="every_day",
        max_instances=1,
        replace_existing=True,
    )
    
    scheduler.add_job(
        every_monday,
        trigger=CronTrigger(day_of_week="mon", hour="09", minute="00"),
        id="every_monday",
        max_instances=1,
        replace_existing=True,
    )

    try:
        logger.info("Starting scheduler...")
        scheduler.start()
    except KeyboardInterrupt:
        logger.info("Stopping scheduler...")
        scheduler.shutdown()
        logger.info("Scheduler shut down successfully!")