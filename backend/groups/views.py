from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from django.contrib.auth import get_user_model
from datetime import datetime, date
import json
import logging

from commons import upload_image, delete_image, RedisRanker, RedisChat, get_boolean, send_to_fcm
from .serializers import GroupCreateSerializer, GroupDetailSerializer, GroupUpdateSerializer
from .models import Group, Participate
from .utils import check_cnt_groups, check_cnt_boarditems_complete, createBoard
from boards.models import Board, BoardItem
from accounts.serializers import GroupSerializer


logger = logging.getLogger('accounts')


class GroupCreateView(APIView):
    def post(self, request):
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
            period = 5
        elif 181 <= period:
            period = 4
        elif 91 <= period:
            period = 3
        elif 31 <= period:
            period = 2
        else:
            period = 1
        
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
            Participate.objects.create(user=user, group=group, is_banned=0, rand_name=rand_name)
        else:
            Participate.objects.create(user=user, group=group, is_banned=0, rand_name=user.username)
        
        user.cnt_groups += 1
        user.save()
        
        check_cnt_groups(user)

        result = createBoard(request, group)
        
        if result:
            url = 'groups' + '/' + str(group.id)
            delete_image(url)
            group.delete()

            return Response(data={'message': result}, status=status.HTTP_400_BAD_REQUEST)
        
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

        count = 0

        for p in Participate.objects.filter(group=group):
            if p.is_banned == 0:
                count += 1
        
        data = {**serializer.data, 'is_participant': is_participant, 'rand_name': rand_name, 'board_id': board_id, 'rank': rank, 'count': count}
        
        return Response(data=data, status=status.HTTP_200_OK)


class GroupUpdateView(APIView):
    def put(self, request, group_id):
        user = request.user
        group = Group.objects.get(id=group_id)
        data = json.loads(request.data.get('data'))
        update_img = get_boolean(request.data.get('update_img'))

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
            if not group.need_auth:
                num = [x.rand_name for x in Participate.objects.filter(group=group)]
                rand_name = f'익명의 참여자 {len(num) + 1:0>2}'
                for i in range(len(num)):
                    if str(num[i][-2:]) != f'{i + 1:0>2}':
                        rand_name = f'익명의 참여자 {i + 1:0>2}'
                        break
                participate = Participate.objects.create(user=user, group=group, is_banned=0, rand_name=rand_name)
                
                user.cnt_groups += 1
                user.save()
                
                check_cnt_groups(user)
            else:
                participate = Participate.objects.create(user=user, group=group, is_banned=1, rand_name=user.username)
            
            result = createBoard(request, group)
    
            if result:
                participate.delete()

                return Response(data={'message': result}, status=status.HTTP_400_BAD_REQUEST)
            
            if group.need_auth:
                send_to_fcm(group.leader, '', '새로운 가입 요청!', '알림을 눌러 가입 요청을 확인해보세요.')
                
            return Response(data={}, status=status.HTTP_200_OK)
        
        else:
            if Participate.objects.get(user=user, group=group).is_banned == 2:
                return Response(data={'message': '이미 승인 거부되었거나 강제 탈퇴된 그룹입니다.'}, status=status.HTTP_400_BAD_REQUEST)
        return Response(data={'message': '이미 가입한 그룹입니다.'}, status=status.HTTP_400_BAD_REQUEST)


class GroupGrantView(APIView):
    def post(self, request, group_id):
        user = request.user
        group = Group.objects.get(id=group_id)
        target_id = request.data.get('target_id')
        grant = get_boolean(request.data.get('grant'))

        if group.leader == user:
            applicant = get_user_model().objects.get(id=target_id)
            participate = Participate.objects.get(user=applicant, group=group)
            
            if user == applicant:
                return Response(data={'message': '잘못된 접근입니다.'}, status=status.HTTP_400_BAD_REQUEST)
            
            if participate.is_banned == 2:
                return Response(data={'message': '이미 승인 거부되었거나 강제 탈퇴된 회원입니다.'}, status=status.HTTP_400_BAD_REQUEST)

            if participate.is_banned == 0 and grant:
                return Response(data={'message': '이미 승인된 회원입니다.'}, status=status.HTTP_400_BAD_REQUEST)
            
            if grant:
                participate.is_banned = 0
                participate.save()
                
                applicant.cnt_groups += 1
                applicant.save()
                
                check_cnt_groups(applicant)
                send_to_fcm(applicant, '', '가입 승인!', f'{group.groupname} 그룹에 가입되셨습니다.', '그룹 가입 후 이동할 경로')
            else:
                participate.is_banned = 2
                participate.save()

            return Response(data={}, status=status.HTTP_200_OK)
        
        return Response(data={'message': '승인 권한이 없습니다.'}, status=status.HTTP_400_BAD_REQUEST)


class GroupDeleteView(APIView):
    def delete(self, request, group_id):
        user = request.user
        group = Group.objects.get(id=group_id)
        
        if user != group.leader:
            return Response(data={'message': '삭제 권한이 없습니다.'}, status=status.HTTP_400_BAD_REQUEST)
        
        if date.today() >= group.start:
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
        
        if date.today() >= group.start:
            return Response(data={'message': '시작일이 경과하여 탈퇴할 수 없습니다.'}, status=status.HTTP_400_BAD_REQUEST)
        
        if user == group.leader:
            return Response(data={'message': '그룹장은 탈퇴할 수 없습니다.'}, status=status.HTTP_400_BAD_REQUEST)
        
        participate.delete()
        
        board = Board.objects.filter(group=group, user=user)
        board.delete()
        
        if len(Participate.objects.filter(group=group)) < 1:
            url = 'groups' + '/' + str(group.id)
            delete_image(url)
            group.delete()
        
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
        participate = Participate.objects.filter(user=user, group=group)
        
        if not participate.exists():
            return Response(data={'message': '참여하지 않은 그룹입니다.'}, status=status.HTTP_400_BAD_REQUEST)
        
        chat = {
            'user_id': user.id,
            'badge_id': user.badge,
            'username': participate[0].rand_name,
            'content': content,
            'created_at': datetime.now().strftime('%Y-%m-%d %H:%M:%S.%f'),
            'reviewed': False,
            'item_id': -1
        }

        if img:
            chat['has_img'] = True

            url = 'chats' + '/' + str(chat.id)
            
            upload_image(url, img)
        else:
            chat['has_img'] = False
        
        RedisChat(group_id).addChat(chat)
        send_to_fcm(user, group, group.groupname, content, '채팅 확인 후 이동할 경로')
            
        return Response(data={}, status=status.HTTP_200_OK)


class GroupChatListView(APIView):
    def get(self, request, group_id):
        user = request.user
        group = Group.objects.get(id=group_id)
        page = int(request.GET.get('page'))
        
        if not Participate.objects.filter(user=user, group=group).exists():
            return Response(data={'message': '참여하지 않은 그룹입니다.'}, status=status.HTTP_400_BAD_REQUEST)
        
        data = RedisChat(group_id).getChatList(page)
        
        return Response(data=data, status=status.HTTP_200_OK)


class GroupReviewCreateView(APIView):
    def post(self, request, group_id):
        user = request.user
        group = Group.objects.get(id=group_id)
        content = request.data.get('content')
        item_id = request.data.get('item_id')
        img = request.FILES.get('img')
        participate = Participate.objects.filter(user=user, group=group)
        
        if not participate.exists():
            return Response(data={'message': '참여하지 않은 그룹입니다.'}, status=status.HTTP_400_BAD_REQUEST)
        
        chat = {
            'user_id': user.id,
            'badge_id': user.badge,
            'username': participate[0].rand_name,
            'content': content,
            'created_at': datetime.now().strftime('%Y-%m-%d %H:%M:%S.%f'),
            'reviewed': False,
            'item_id': item_id
        }

        if img:
            chat['has_img'] = True

            url = 'chats' + '/' + str(chat.id)
            
            upload_image(url, img)
        else:
            chat['has_img'] = False
        
        RedisChat(group_id).addChat(chat)
        send_to_fcm(user, group, group.groupname, content, '채팅 확인 후 이동할 경로')
            
        return Response(data={}, status=status.HTTP_200_OK)


class GroupReviewCheckView(APIView):
    def put(self, request, group_id):
        user = request.user
        group = Group.objects.get(id=group_id)
        review_id = int(request.data.get('review_id'))
        chat = RedisChat(group_id)
        review = chat.getChatItem(review_id)
        review_user = get_user_model().objects.get(id=review['user_id'])
        
        if not Participate.objects.filter(user=user, group=group).exists():
            return Response(data={'message': '참여하지 않은 그룹입니다.'}, status=status.HTTP_400_BAD_REQUEST)
        
        if review_user == user:
            return Response(data={'message': '자신의 인증 요청은 인증할 수 없습니다.'}, status=status.HTTP_400_BAD_REQUEST)
        
        if review.reviewed:
            return Response(data={'message': '이미 인증된 요청입니다.'}, status=status.HTTP_400_BAD_REQUEST)
        
        board = Board.objects.filter(user=review_user, group=group)[0]
        board_item = BoardItem.objects.filter(board=board)
        
        if board_item.finished:
            return Response(data={'message': '이미 완료된 항목입니다.'}, status=status.HTTP_400_BAD_REQUEST)
        
        # 횟수 측정 여부 확인
        if board_item.check:
            board_item.check_cnt += 1
            
            if board_item.check_cnt == board_item.check_goal:
                check_cnt_boarditems_complete(review_user, group, board_item)
                
        else:    
            check_cnt_boarditems_complete(review_user, group, board_item)
        
        review.reviewed = True
        chat.setChatItem(review_id, review)

        send_to_fcm(user, '', '인증 완료!', '요청하신 인증이 완료되었습니다.', '인증 확인 후 이동할 경로')
        
        return Response(status=status.HTTP_200_OK)


class GroupAdminView(APIView):
    def get(self, request, group_id):
        user = request.user
        group = Group.objects.get(id=group_id)
        
        if not Participate.objects.filter(user=user, group=group).exists() or user != group.leader:
            return Response(data={'message': '권한이 없습니다.'}, status=status.HTTP_400_BAD_REQUEST)
        
        applicants = []
        members = []
        
        for participate in Participate.objects.filter(group=group):
            board = Board.objects.filter(user=user, group=group)
            
            if board:
                board_id = board[0].id
            else:
                board_id = -1
            
            if participate.is_banned == 1:
                applicants.append({
                    'id': participate.user.id,
                    'username': participate.rand_name if group.is_public else participate.user.username,
                    'board_id': board_id
                    })
            elif participate.is_banned == 0:
                members.append({
                    'id': participate.user.id,
                    'username': participate.rand_name if group.is_public else participate.user.username,
                    'board_id': board_id
                    })
        
        data = {'applicants': applicants, 'members': members, 'need_auth': group.need_auth}
        
        return Response(data=data, status=status.HTTP_200_OK)


class GroupSearchView(APIView):
    def get(self, request):
        user = request.user
        period = int(request.GET.get('period'))
        keyword = request.GET.get('keyword')
        order = request.GET.get('order')
        public = request.GET.get('public')
        page = int(request.GET.get('page'))

        last_page = page

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

        groups = groups.order_by(order)
        groups = GroupSerializer(groups, many=True).data

        for group in groups:
            count = 0

            for p in Participate.objects.filter(group=group['id']):
                if p.is_banned == 0:
                    count += 1
            
            group['count'] = count

        groups = [d for d in groups if d['count'] < d['headcount'] and not Participate.objects.filter(group=d['id'], user=user).exists()]
           
        last_page = len(groups) // 10
        
        if len(groups) % 10:
            last_page += 1

        groups = groups[10 * (page - 1):10 * page]
        
        return Response(data={'groups': groups, 'last_page': last_page}, status=status.HTTP_200_OK)