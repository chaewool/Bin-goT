from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from django.contrib.auth import get_user_model
from datetime import datetime, date
import json
import logging

from commons import upload_image, delete_image, RedisRanker
from .serializers import GroupCreateSerializer, GroupDetailSerializer, GroupUpdateSerializer, GroupSearchSerializer, ChatListSerializer, ReviewListSerializer
from .models import Group, Participate, Chat, Review
from boards.models import Board, BoardItem
from accounts.models import Badge, Achieve


logger = logging.getLogger('accounts')


def check_cnt_groups(user):
    if user.cnt_groups == 1:
        badge = Badge.objects.get(id=2)
        Achieve.objects.create(user=user, badge=badge)
    elif user.cnt_groups == 3:
        badge = Badge.objects.get(id=3)
        Achieve.objects.create(user=user, badge=badge)
    elif user.cnt_groups == 5:
        badge = Badge.objects.get(id=4)
        Achieve.objects.create(user=user, badge=badge)
        
    # user에게 알림 보내는 코드 추가 필요


def check_cnt_boarditems_complete(group_id, review):
    user = review.user
    
    review.item.finish = True
    review.item.save()
    
    ranker = RedisRanker(group_id)
    ranker.plusOne(str(review.user.id))
    
    user.cnt_boarditems_complete += 1
    user.save()
                
    if user.cnt_boarditems_complete == 1:
        badge = Badge.objects.get(id=8)
        Achieve.objects.create(user=user, badge=badge)
    elif user.cnt_boarditems_complete == 10:
        badge = Badge.objects.get(id=9)
        Achieve.objects.create(user=user, badge=badge)
    elif user.cnt_boarditems_complete == 100:
        badge = Badge.objects.get(id=10)
        Achieve.objects.create(user=user, badge=badge) 
           
    # user에게 알림 보내는 코드 추가 필요
    
    board = Board.objects.get(user=user, group=review.group)
    
    cnt = 0
    for item in board.items:
        if item.finished:
            cnt += 1
    
    if cnt == board.size ** 2:
        board.finished = True
        board.save()
        
        user.cnt_boards_complete += 1
        user.save()
              
        if user.cnt_boards_complete == 1:
            badge = Badge.objects.get(id=11)
            Achieve.objects.create(user=user, badge=badge)
        elif user.cnt_boards_complete == 12:
            badge = Badge.objects.get(id=9)
            Achieve.objects.create(user=user, badge=badge)
        elif user.cnt_boards_complete == 100:
            badge = Badge.objects.get(id=13)
            Achieve.objects.create(user=user, badge=badge)
            
        # user에게 알림 보내는 코드 추가 필요


class GroupCreateView(APIView):
    def post(self, request):
        logger.info(f'전달 받은 이미지: {request.FILES.get("img").content_type}')
        
        user = request.user
        img = request.FILES.get('img')
        data = json.loads(request.data.get('data'))
        
        period = (datetime.strptime(data.get('end'), '%Y-%m-%d') - datetime.strptime(data.get('start'), '%Y-%m-%d')).days

        headcount = data.get('headcount')
        size = data.get('size')
        is_public = data.get('is_public')
        password = data.get('password')
        
        if period > 365:
            return Response(data={'message': '기간은 1년 이하로 지정해야 합니다.'}, status=status.HTTP_400_BAD_REQUEST)
        elif headcount < 1 or headcount > 30:
            return Response(data={'message': '인원 수는 1명 이상 30명 이하로 지정해야 합니다.'}, status=status.HTTP_400_BAD_REQUEST)
        elif size < 2 or size > 5:
            return Response(data={'message': '빙고 크기는 2 이상 5 이하로 지정해야 합니다.'}, status=status.HTTP_400_BAD_REQUEST)
        elif not is_public and password == '':
            return Response(data={'message': '비공개 그룹은 비밀번호를 설정해야 합니다.'}, status=status.HTTP_400_BAD_REQUEST)
        
        if 271 <= period <= 365:
            period = 4
        elif 181 <= period:
            period = 3
        elif 91 <= period:
            period = 2
        elif 31 <= period:
            period = 1
        else:
            period = 0
        
        serializer = GroupCreateSerializer(data=data)
        if serializer.is_valid(raise_exception=True):
            if img != None:
                group = serializer.save(leader=user, period=period, has_img=True)
                
                url = 'groups' + '/' + str(group.id)
                
                upload_image(url, img)
            else:
                group = serializer.save(leader=user, period=period, has_img=False)

        if is_public:
            num = [x.rand_name for x in Participate.objects.filter(group=group)]
            rand_name = f'익명의 참여자 {len(num) + 1:0>2}'
            for i in range(len(num)):
                if str(num[i][-2:]) != f'{i + 1:0>2}':
                    rand_name = f'익명의 참여자 {i + 1:0>2}'
                    break
            Participate.objects.create(user=user, group=group, is_banned=False, rand_name=rand_name)
        else:
            Participate.objects.create(user=user, group=group, is_banned=False)
        
        user.cnt_groups += 1
        user.save()
        
        check_cnt_groups(user)
        
        return Response(data={'group_id': group.id}, status=status.HTTP_200_OK)


class GroupDetailView(APIView):
    def get(self, request, group_id):
        user = request.user
        group = Group.objects.get(id=group_id)
        password = request.GET.get('password')
        
        rand_name = user.username
        participate = Participate.objects.filter(user=user, group=group)
        board_id = 0
        
        if Board.objects.filter(user=user, group=group).exists():
            board_id = Board.objects.get(user=user, group=group).id
        
        # 그룹 가입 여부 확인
        if participate:
            participate = participate[0]
            
            # 강제 탈퇴 여부 확인
            if participate.is_banned:
                return Response(data={'message': '탈퇴 처리된 그룹입니다.'}, status=status.HTTP_400_BAD_REQUEST)
            
            if group.leader == user:
                is_participant = 2
            else:
                is_participant = 1
            
            # 공개 그룹인 경우 익명 닉네임 표시
            if group.is_public:
                rand_name = participate.rand_name
                
        else:
            # 비밀번호 확인
            if not group.is_public and password != group.password:
                data = {'message': '비밀번호가 일치하지 않습니다.'}
                return Response(data=data, status=status.HTTP_400_BAD_REQUEST)
            
            is_participant = 0

        serializer = GroupDetailSerializer(group)
        ranker = RedisRanker(group_id)
        rank = []
        for ranker_id in ranker.getTops(3):
            r = get_user_model.objects.get(id=ranker_id)
            rank.append({
                'user_id': ranker_id, 
                'nickname': Participate.objects.get(group=group, user=r).rand_name, 
                'achieve': ranker.getScore(ranker_id) / (group.size ** 2), 
                'board_id': Board.objects.get(group=group, user=r).id
                })
        
        data = {**serializer.data, 'is_participant': is_participant, 'rand_name': rand_name, 'board_id': board_id, 'rank': rank}
        
        return Response(data=data, status=status.HTTP_200_OK)


class GroupUpdateView(APIView):
    def put(self, request, group_id):
        user = request.user
        group = Group.objects.get(id=group_id)
        data = json.loads(request.data.get('data'))
        update_img = request.data.get('update_img')

        if not data['groupname']:
            data['groupname'] = group.groupname
        
        if not data['headcount']:
            data['headcount'] = group.headcount

        if data['headcount'] < 1 or data['headcount'] > 30:
            return Response(data={'message': '인원 수는 1명 이상 30명 이하로 지정해야 합니다.'}, status=status.HTTP_400_BAD_REQUEST)
        
        if user == group.leader:
            serializer = GroupUpdateSerializer(instance=group, data=data)

            if serializer.is_valid(raise_exception=True):        
                url = 'groups' + '/' + str(group.id)
                
                if update_img:                
                    img = request.FILES.get('img')
                    
                    if img != None:
                        upload_image(url, img)
                        serializer.save(has_img=True)
                    else:
                        delete_image(url)
                        serializer.save(has_img=False)
                
                return Response(status=status.HTTP_200_OK)
        return Response(data={'message': '수정 권한이 없습니다.'}, status=status.HTTP_400_BAD_REQUEST)


class GroupJoinView(APIView):
    def post(self, request, group_id):
        user = request.user
        group = Group.objects.get(id=group_id)

        if not Participate.objects.filter(user=user, group=group).exists():
            if group.is_public:
                num = [x.rand_name for x in Participate.objects.filter(group=group)]
                rand_name = f'익명의 참여자 {len(num) + 1:0>2}'
                for i in range(len(num)):
                    if str(num[i][-2:]) != f'{i + 1:0>2}':
                        rand_name = f'익명의 참여자 {i + 1:0>2}'
                        break
                Participate.objects.create(user=user, group=group, is_banned=False, rand_name=rand_name)
                
                user.cnt_groups += 1
                user.save()
                
                check_cnt_groups(user)
            else:
                Participate.objects.create(user=user, group=group, is_banned=True)
                
                # leader에게 알림 보내는 코드 추가 필요
            return Response(status=status.HTTP_200_OK)
        
        return Response(data={'message': '이미 가입한 그룹입니다.'}, status=status.HTTP_400_BAD_REQUEST)


class GroupGrantView(APIView):
    def post(self, request, group_id):
        user = request.user
        group = Group.objects.get(id=group_id)
        applicant_id = request.data.get('applicant_id')
        grant = request.data.get('grant')

        if group.leader == user:
            applicant = get_user_model().objects.get(id=applicant_id)
            participate = Participate.objects.filter(user=applicant, group=group)

            if participate.is_banned and not grant:
                pass
            elif participate.is_banned and grant:
                participate.is_banned = False
                participate.save()
                
                applicant.cnt_groups += 1
                applicant.save()
                
                check_cnt_groups(applicant)
            elif not participate.is_banned and not grant:
                participate.is_banned = True
                participate.save()

            return Response(status=status.HTTP_200_OK)
        
        return Response(data={'message': '승인 권한이 없습니다.'}, status=status.HTTP_400_BAD_REQUEST)


class GroupDeleteView(APIView):
    def delete(self, request, group_id):
        user = request.user
        group = Group.objects.get(id=group_id)
        
        if user != group.leader:
            return Response(data={'message': '삭제 권한이 없습니다.'}, status=status.HTTP_400_BAD_REQUEST)
        
        if date.today() > group.start:
            return Response(data={'message': '시작일이 경과하여 삭제할 수 없습니다.'}, status=status.HTTP_400_BAD_REQUEST)
        
        if len(Participate.objects.filter(group=group)) > 1:
            return Response(data={'message': '참여자가 존재하여 삭제할 수 없습니다.'}, status=status.HTTP_400_BAD_REQUEST)
        
        url = 'groups' + '/' + str(group.id)
        delete_image(url)
        group.delete()
        
        return Response(status=status.HTTP_200_OK)


class GroupResignView(APIView):
    def delete(self, request, group_id):
        user = request.user
        group = Group.objects.get(id=group_id)
        participate = Participate.objects.filter(user=user, group=group)
        
        if not participate:
            return Response(data={'message': '참여하지 않은 그룹입니다.'}, status=status.HTTP_400_BAD_REQUEST)
        
        if date.today() > group.start:
            return Response(data={'message': '시작일이 경과하여 탈퇴할 수 없습니다.'}, status=status.HTTP_400_BAD_REQUEST)
        
        participate.delete()
        
        return Response(status=status.HTTP_200_OK)


class GroupRankView(APIView):
    def get(self, request, group_id):
        user = request.user
        group = Group.objects.get(id=group_id)
        
        if not Participate.objects.filter(user=user, group=group).exists():
            return Response(data={'message': '참여하지 않은 그룹입니다.'}, status=status.HTTP_400_BAD_REQUEST)
        
        ranker = RedisRanker(group_id)
        data = []
        
        for participate in Participate.objects.filter(group=group):
            u = participate.user
            data.append({
                'user_id': u.id, 
                'nickname': participate.rand_name, 
                'achieve': ranker.getScore(str(u.id)) / (group.size ** 2), 
                'board_id': Board.objects.get(group=group, user=u).id,
                'rank': ranker.getRank(str(u.id))
                })
        
        return Response(data=data, status=status.HTTP_200_OK)


class GroupChatCreateView(APIView):
    def post(self, request, group_id):
        user = request.user
        group = Group.objects.get(id=group_id)
        content = request.data.get('content')
        img = request.FILES.get('img')
        
        if not Participate.objects.filter(user=user, group=group).exists():
            return Response(data={'message': '참여하지 않은 그룹입니다.'}, status=status.HTTP_400_BAD_REQUEST)
        
        chat = Chat(user=user, group=group, content=content)

        if img:
            chat.has_img = True
            chat.save()

            url = 'chats' + '/' + str(chat.id)
            
            upload_image(url, img)
        else:
            chat.has_img = False
            chat.save()
            
        return Response(status=status.HTTP_200_OK)


class GroupChatListView(APIView):
    def get(self, request, group_id):
        user = request.user
        group = Group.objects.get(id=group_id)
        page = int(request.GET.get('page'))
        
        if not Participate.objects.filter(user=user, group=group).exists():
            return Response(data={'message': '참여하지 않은 그룹입니다.'}, status=status.HTTP_400_BAD_REQUEST)
        
        chat_serializer = ChatListSerializer(Chat.objects.filter(group=group), many=True)
        review_serializer = ReviewListSerializer(Review.objects.filter(group=group), many=True)
        
        data = sorted(chat_serializer.data + review_serializer.data, key=lambda x: x['created_at'], reverse=True)[(page - 1) * 50: page * 50]
        
        return Response(data=data, status=status.HTTP_200_OK)


class GroupReviewCreateView(APIView):
    def post(self, request, group_id):
        user = request.user
        group = Group.objects.get(id=group_id)
        board = Board.objects.get(id=request.data.get('board_id'))
        item = BoardItem.objects.get(id=request.data.get('item_id'))
        content = request.data.get('content')
        img = request.FILES.get('img')
        
        if not Participate.objects.filter(user=user, group=group).exists():
            return Response(data={'message': '참여하지 않은 그룹입니다.'}, status=status.HTTP_400_BAD_REQUEST)
        
        if user != board.user:
            return Response(data={'message': '인증 요청 권한이 없습니다.'}, status=status.HTTP_400_BAD_REQUEST)
        
        review = Review(user=user, group=group, item=item, content=content, reviewed=False)

        if img:
            review.has_img = True
            review.save()

            url = 'reviews' + '/' + str(review.id)
            
            upload_image(url, img)
        else:
            review.has_img = False
            review.save()
            
        return Response(status=status.HTTP_200_OK)


class GroupReviewCheckView(APIView):
    def put(self, request, group_id):
        user = request.user
        group = Group.objects.get(id=group_id)
        review = Review.objects.get(id=request.data.get('review_id'))
        
        if not Participate.objects.filter(user=user, group=group).exists():
            return Response(data={'message': '참여하지 않은 그룹입니다.'}, status=status.HTTP_400_BAD_REQUEST)
        
        if review.user == user:
            return Response(data={'message': '자신의 인증 요청은 인증할 수 없습니다.'}, status=status.HTTP_400_BAD_REQUEST)
        
        if review.reviewed:
            return Response(data={'message': '이미 인증된 요청입니다.'}, status=status.HTTP_400_BAD_REQUEST)
        
        if review.item.finished:
            return Response(data={'message': '이미 완료된 항목입니다.'}, status=status.HTTP_400_BAD_REQUEST)
        
        
        # 횟수 측정 여부 확인
        if review.item.check:
            review.item.check_cnt += 1
            
            if review.item.check_cnt == review.item.check_goal:
                check_cnt_boarditems_complete(group_id, review)
                
        else:    
            check_cnt_boarditems_complete(group_id, review)
        
        review.reviewed = True
        review.save()
        
        return Response(status=status.HTTP_200_OK)


class GroupSearchView(APIView):
    def get(self, request):
        user = request.user
        period = request.GET.get('period')
        keyword = request.GET.get('keyword')
        order = request.GET.get('order')
        public = request.GET.get('public')
        page = int(request.GET.get('page'))
        cnt = int(request.GET.get('cnt'))

        if order == '0':
            order = '-start'
        else:
            order = 'start'

        groups = Group.objects.filter(start__gte=date.today())

        if public == '1':
            groups = groups.filter(is_public=True)
        elif public == '2':
            groups = groups.filter(is_public=False)
        
        if period:
            groups = groups.filter(period=period)
        
        if keyword:
            groups = groups.filter(groupname__icontains=keyword)

        groups = groups.order_by(order)[(page - 1) * cnt: page * cnt]
        data = GroupSearchSerializer(groups, many=True).data
        data = [d for d in data if d['count'] < d['headcount'] and not Participate.objects.filter(group=d.id, user=user).exists()]
        
        return Response(data=data, status=status.HTTP_200_OK)