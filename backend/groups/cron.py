from datetime import date, timedelta
import logging

from commons import RedisRanker, send_to_fcm, send_badge_notification
from groups.models import Group


logger = logging.getLogger('accounts')


def test():
    class Temp():
        def __init__(self) -> None:
            self.id = 1

    send_to_fcm(Temp(), '', '테스트 제목', '테스트 내용', '경로')

    logger.info('1분마다 로그 찍힘')


def every_day():
    groups = Group.objects.all()
    today = date.today()
    
    for group in groups:
        # 시작일 7일 전, 시작 예정 알림
        if today == group.start - timedelta(days=7):
            title = f'{group.groupname} 그룹의 시작까지 7일 남았습니다.'
            content = f'빙고에 참여할 준비 됐나요?'
            path = '시작 예정 확인 후 이동할 경로'
            users = [user for user in group.users.all() if user.noti_due]
            
            send_to_fcm('', group, title, content, path, users)
        
        # 시작일, 시작 알림
        elif today == group.start:
            title = f'{group.groupname} 그룹이 시작했습니다!'
            content = f'빙고를 함께 채워볼까요?'
            path = '시작 확인 후 이동할 경로'
            
            send_to_fcm('', group, title, content, path)
        
        # 종료일 7일 전, 남은 기간 알림
        elif today == group.end - timedelta(days=7):
            title = f'{group.groupname} 그룹의 종료까지 7일 남았습니다.'
            content = f'열심히 참여해서 빈 곳을 채워보세요!'
            path = '종료 예정 확인 후 이동할 경로'
            users = [user for user in group.users.all() if user.noti_due]
            
            send_to_fcm('', group, title, content, path, users)
        
        # 종료일, 순위 알림
        elif today == group.end:
            ranker = RedisRanker(str(group.id))
            
            title = f'{group.groupname} 그룹의 빙고가 종료되었습니다.'
            path = '등수 확인 후 이동할 경로'

            users = group.users.all()
            for user in users:
                rank = ranker.getRank(str(user.id))
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
    groups = Group.objects.all()
    
    for group in groups:
        ranker = RedisRanker(str(group.id))
        
        title = f'{group.groupname} 그룹의 현재 순위를 확인해보세요.'
        path = '등수 확인 후 이동할 경로'

        users = group.users.all()
        for user in users:
            if user.noti_rank:
                rank = ranker.getRank(str(user.id))
                content = f'당신의 등수는 {rank}등입니다.'
                send_to_fcm(user, '', title, content, path)