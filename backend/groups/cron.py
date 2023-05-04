from datetime import date

from commons import RedisRanker, delete_image
from accounts.models import Achieve, Badge
from groups.models import Group, Participate
from boards.models import Board


def every_day():
    groups = Group.objects.all()
    today = date.today()
    
    for group in groups:
        # 시작일인데 빙고판 없는 사람들 강퇴
        if today == group.start:
            users = group.users.all()
            for user in users:
                if not Board.objects.filter(group=group, user=user).exists():
                    Participate.objects.filter(group=group, user=user).delete()
                    
                    # 알림 보내는 작업 추가
            
            if len(Participate.objects.filter(group=group)) < 1:
                url = 'groups' + '/' + str(group.id)
                delete_image(url)
                group.delete()
            
        # 종료일에 순위 알림
        elif today == group.end:
            ranker = RedisRanker(str(group.id))
            
            users = group.users.all()
            for user in users:
                rank = ranker.getRank(str(user.id))
                
                if rank == 1:
                    user.cnt_rank1 += 1
                    user.save()
                                
                    if user.cnt_rank1 == 1:
                        badge = Badge.objects.get(id=14)
                        Achieve.objects.create(user=user, badge=badge)
                    elif user.cnt_rank1 == 5:
                        badge = Badge.objects.get(id=15)
                        Achieve.objects.create(user=user, badge=badge)
                    
                # 알림 보내는 작업 추가