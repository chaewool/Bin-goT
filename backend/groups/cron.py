from datetime import date

from commons import RedisRanker, send_to_fcm, send_badge_notification
from groups.models import Group


# 종료일에 순위 알림
def every_day():
    groups = Group.objects.all()
    today = date.today()
    
    for group in groups:
        if today == group.end:
            ranker = RedisRanker(str(group.id))
            
            users = group.users.all()
            for user in users:
                rank = ranker.getRank(str(user.id))

                title = f'{group.groupname} 그룹의 빙고가 종료되었습니다.'
                content = f'당신의 등수는 {rank}등입니다.'
                path = '등수 확인 후 이동할 경로'

                send_to_fcm(user.id, '', title, content, path)
                
                if rank == 1:
                    title = '새로운 뱃지 획득!'
                    content = '알림을 눌러 획득한 뱃지를 확인해보세요.'
                    path = '뱃지 획득 후 이동할 경로'

                    user.cnt_rank1 += 1
                    user.save()
                                
                    if user.cnt_rank1 == 1:
                        send_badge_notification(user, 14)
                    elif user.cnt_rank1 == 5:
                        send_badge_notification(user, 15)


# 매주 월요일에 현재 순위 알림

# 남은 기간 알림