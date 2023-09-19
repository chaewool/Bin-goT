from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from django.contrib.auth import get_user_model
from datetime import datetime, date
import json
import logging

from commons import upload_image, delete_image, RedisRanker, RedisChat, get_boolean, send_to_fcm
from .serializers import GroupCreateSerializer, GroupDetailSerializer, GroupUpdateSerializer, BoardCreateSerializer, BoardDetailSerializer, BoardItemCreateSerializer
from .models import Group, Board, BoardItem
from .utils import check_cnt_groups, check_cnt_boarditems_complete, create_board
from accounts.serializers import GroupSerializer


logger = logging.getLogger('accounts')


class GroupCreateView(APIView):
    def post(self, request):
        user = request.user
        img = request.FILES.get('img')
        data = json.loads(request.data.get('data'))

        logger.info(f"받아온 데이터: {data}")
        
        period = (datetime.strptime(data.get('end'), '%Y-%m-%d') - datetime.strptime(data.get('start'), '%Y-%m-%d')).days

        headcount = data.get('headcount')
        size = data.get('size')
        is_public = data.get('is_public')
        password = data.get('password')
        
        if period > 365:
            return Response(data={'message': '기간은 1년 이하로 지정해야 합니다.'}, status=status.HTTP_400_BAD_REQUEST)
        elif headcount < 2 or headcount > 30:
            return Response(data={'message': '인원 수는 2명 이상 30명 이하로 지정해야 합니다.'}, status=status.HTTP_400_BAD_REQUEST)
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
            num = [x.rand_name for x in Board.objects.filter(group=group)]
            rand_name = f'익명의 참여자 {len(num) + 1:0>2}'
            for i in range(len(num)):
                if str(num[i][-2:]) != f'{i + 1:0>2}':
                    rand_name = f'익명의 참여자 {i + 1:0>2}'
                    break
        else:
            rand_name = user.username

        result = create_board(request, group, 0, rand_name)
        
        if result:
            url = 'groups' + '/' + str(group.id)
            delete_image(url)
            group.delete()

            return Response(data={'message': result}, status=status.HTTP_400_BAD_REQUEST)
        
        user.cnt_groups += 1
        user.save()
        
        check_cnt_groups(user)
        
        return Response(data={'group_id': group.id}, status=status.HTTP_200_OK)


class GroupDetailView(APIView):
    def get(self, request, group_id):
        user = request.user
        group = Group.objects.get(id=group_id)
        
        rand_name = user.username
        board = Board.objects.filter(user=user, group=group)
        board_id = 0

        # 그룹 가입 여부 확인
        if board.exists():
            board = Board.objects.get(user=user, group=group)
            board_id = board.id
            
            # 강제 탈퇴 여부 확인
            if board.is_banned == 2:
                return Response(data={'message': '탈퇴 처리된 그룹입니다.'}, status=status.HTTP_400_BAD_REQUEST)
            
            if group.leader == user:
                is_participant = 2
            else:
                is_participant = 1
            
            # 공개 그룹인 경우 익명 닉네임 표시
            if group.is_public:
                rand_name = board.rand_name
                
        else:            
            is_participant = 0

        serializer = GroupDetailSerializer(group)
        ranker = RedisRanker(group_id)
        rank = []
        for ranker_id in ranker.getTops(3):
            r = get_user_model().objects.get(id=ranker_id)
            rank.append({
                'user_id': int(ranker_id), 
                'nickname': Board.objects.get(group=group, user=r).rand_name, 
                'achieve': ranker.getScore(ranker_id) / (group.size ** 2), 
                'board_id': Board.objects.get(group=group, user=r).id
                })
        
        data = {**serializer.data, 'is_participant': is_participant, 'rand_name': rand_name, 'board_id': board_id, 'rank': rank}
        
        return Response(data=data, status=status.HTTP_200_OK)


class GroupCheckView(APIView):
    def post(self, request, group_id):
        password = request.data.get('password')
        group = Group.objects.get(id=group_id)
        
        if not group.is_public and password != group.password:
            data = {'message': '비밀번호가 일치하지 않습니다.'}
            return Response(data=data, status=status.HTTP_400_BAD_REQUEST)
        return Response(data={}, status=status.HTTP_200_OK)


class GroupUpdateView(APIView):
    def put(self, request, group_id):
        user = request.user
        group = Group.objects.get(id=group_id)
        data = json.loads(request.data.get('data'))
        update_img = request.data.get('update_img')
        update_img = get_boolean(update_img)
                
        if date.today() >= group.start:
            return Response(data={'message': '시작일이 경과하여 수정할 수 없습니다.'}, status=status.HTTP_400_BAD_REQUEST)

        if not data.get('groupname'):
            data['groupname'] = group.groupname
        
        if not data.get('headcount'):
            data['headcount'] = group.headcount

        if data['headcount'] < 2 or data['headcount'] > 30:
            return Response(data={'message': '인원 수는 2명 이상 30명 이하로 지정해야 합니다.'}, status=status.HTTP_400_BAD_REQUEST)
        
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
                else:
                    serializer.save()
                
                return Response(status=status.HTTP_200_OK)
        return Response(data={'message': '수정 권한이 없습니다.'}, status=status.HTTP_400_BAD_REQUEST)


class GroupJoinView(APIView):
    def post(self, request, group_id):
        user = request.user
        group = Group.objects.get(id=group_id)

        if date.today() >= group.start:
            return Response(data={'message': '시작일이 경과하여 가입할 수 없습니다.'}, status=status.HTTP_400_BAD_REQUEST)

        if not Board.objects.filter(user=user, group=group).exists():
            if group.is_public:
                num = [x.rand_name for x in Board.objects.filter(group=group)]
                rand_name = f'익명의 참여자 {len(num) + 1:0>2}'
                for i in range(len(num)):
                    if str(num[i][-2:]) != f'{i + 1:0>2}':
                        rand_name = f'익명의 참여자 {i + 1:0>2}'
                        break
            else:
                rand_name = user.username

            if not group.need_auth:
                result = create_board(request, group, 0, rand_name)

                if result:
                    return Response(data={'message': result}, status=status.HTTP_400_BAD_REQUEST)

                user.cnt_groups += 1
                user.save()

                group.count += 1
                group.save()
                
                check_cnt_groups(user)

                return Response(data={}, status=status.HTTP_200_OK)
            else:
                result = create_board(request, group, 1, rand_name)
    
                if result:
                    return Response(data={'message': result}, status=status.HTTP_400_BAD_REQUEST)
                
                send_to_fcm(group.leader, '', '새로운 가입 요청!', '알림을 눌러 가입 요청을 확인해보세요.', f'groups/{group.id}/admin')
                    
                return Response(data={}, status=status.HTTP_200_OK)
        elif Board.objects.get(user=user, group=group).is_banned == 2:
            return Response(data={'message': '이미 승인 거부되었거나 강제 탈퇴된 그룹입니다.'}, status=status.HTTP_400_BAD_REQUEST)
        else:
            return Response(data={'message': '이미 가입한 그룹입니다.'}, status=status.HTTP_400_BAD_REQUEST)


class GroupGrantView(APIView):
    def post(self, request, group_id):
        user = request.user
        group = Group.objects.get(id=group_id)
        target_id = request.data.get('target_id')
        grant = request.data.get('grant')
        grant = get_boolean(grant)
                
        if date.today() >= group.start:
            return Response(data={'message': '시작일이 경과하여 승인할 수 없습니다.'}, status=status.HTTP_400_BAD_REQUEST)

        if group.leader == user:
            applicant = get_user_model().objects.get(id=target_id)
            board = Board.objects.get(user=applicant, group=group)
            
            if user == applicant:
                return Response(data={'message': '잘못된 접근입니다.'}, status=status.HTTP_400_BAD_REQUEST)
            
            if board.is_banned == 2:
                return Response(data={'message': '이미 승인 거부되었거나 강제 탈퇴된 회원입니다.'}, status=status.HTTP_400_BAD_REQUEST)

            if board.is_banned == 0 and grant:
                return Response(data={'message': '이미 승인된 회원입니다.'}, status=status.HTTP_400_BAD_REQUEST)
            
            if grant:
                board.is_banned = 0
                board.save()
                
                applicant.cnt_groups += 1
                applicant.save()

                group.count += 1
                group.save()
                
                check_cnt_groups(applicant)
                send_to_fcm(applicant, '', '가입 승인!', f'{group.groupname} 그룹에 가입되셨습니다.', f'groups/{group.id}/main')
            else:
                board.is_banned = 2
                board.save()

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
        
        if group.count > 1:
            return Response(data={'message': '참여자가 존재하여 삭제할 수 없습니다.'}, status=status.HTTP_400_BAD_REQUEST)
        
        url = 'groups' + '/' + str(group.id)
        delete_image(url)
        group.delete()
        
        return Response(status=status.HTTP_200_OK)


class GroupResignView(APIView):
    def delete(self, request, group_id):
        user = request.user
        group = Group.objects.get(id=group_id)
        board = Board.objects.filter(user=user, group=group)
        
        if not board:
            return Response(data={'message': '참여하지 않은 그룹입니다.'}, status=status.HTTP_400_BAD_REQUEST)
        
        if date.today() >= group.start:
            return Response(data={'message': '시작일이 경과하여 탈퇴할 수 없습니다.'}, status=status.HTTP_400_BAD_REQUEST)
        
        if user == group.leader:
            return Response(data={'message': '그룹장은 탈퇴할 수 없습니다.'}, status=status.HTTP_400_BAD_REQUEST)
        
        group.count -= 1
        group.save()

        board.delete()
        
        if group.count < 1:
            url = 'groups' + '/' + str(group.id)
            delete_image(url)
            group.delete()
        
        return Response(status=status.HTTP_200_OK)


class GroupRankView(APIView):
    def get(self, request, group_id):
        user = request.user
        group = Group.objects.get(id=group_id)
        
        if not Board.objects.filter(user=user, group=group).exists():
            return Response(data={'message': '참여하지 않은 그룹입니다.'}, status=status.HTTP_400_BAD_REQUEST)
        
        ranker = RedisRanker(group_id)
        data = []
        
        for board in Board.objects.filter(group=group):
            u = board.user
            data.append({
                'user_id': u.id, 
                'nickname': board.rand_name, 
                'achieve': ranker.getScore(str(u.id)) / (group.size ** 2), 
                'board_id': board.id,
                'rank': ranker.getRank(str(u.id))
                })
        
        return Response(data=data, status=status.HTTP_200_OK)


class BoardDetailView(APIView):
    def get(self, request, group_id, board_id):
        board = Board.objects.get(id=board_id)
        serializer = BoardDetailSerializer(board)
        group = board.group

        if not Board.objects.filter(user=request.user, group=group).exists():
            return Response(data={'message': '참여하지 않은 그룹입니다.'}, status=status.HTTP_400_BAD_REQUEST)
        
        achieve = 0
        
        for item in serializer.data['items']:
            if item['finished']:
                achieve += 1
        
        data = {**serializer.data, 'username': board.rand_name if group.is_public else board.user.username, 'achieve': round(achieve / (board.group.size ** 2), 2), 'size': group.size}
        
        return Response(data=data, status=status.HTTP_200_OK)


class BoardUpdateView(APIView):
    def put(self, request, group_id, board_id):
        user = request.user
        board = Board.objects.get(id=board_id)
        group = board.group
        thumbnail = request.FILES.get('thumbnail')
        data = json.loads(request.data.get('data'))
        
        logger.info(f"받아온 데이터: {data}")
        
        if not Board.objects.filter(user=user, group=group).exists():
            return Response(data={'message': '참여하지 않은 그룹입니다.'}, status=status.HTTP_400_BAD_REQUEST)
        
        if user != board.user:
            return Response(data={'message': '수정 권한이 없습니다.'}, status=status.HTTP_400_BAD_REQUEST)
    
        if date.today() >= group.start:
            return Response(data={'message': '시작일이 경과하여 수정할 수 없습니다.'}, status=status.HTTP_400_BAD_REQUEST)
        
        items = data['items']
        if len(items) < board.group.size ** 2:
            return Response(data={'message': '항목의 개수가 부족합니다.'}, status=status.HTTP_400_BAD_REQUEST)
        items.sort(key=lambda x: x['item_id'])
        
        board_serializer = BoardCreateSerializer(instance=board, data=data)
        
        if board_serializer.is_valid(raise_exception=True):
            boarditem_serializers = []
            for i in range(len(items)):
                bs = BoardItemCreateSerializer(instance=board.items.all()[i], data=items[i])
                if bs.is_valid(raise_exception=True):
                    boarditem_serializers.append(bs)
            
            board_serializer.save()
            for bs in boarditem_serializers:
                bs.save()
            
            url = 'boards' + '/' + str(board.id)
            upload_image(url, thumbnail)
            
            return Response(status=status.HTTP_200_OK)


class GroupChatCreateView(APIView):
    def post(self, request, group_id):
        user = request.user
        group = Group.objects.get(id=group_id)
        content = request.data.get('content')
        img = request.FILES.get('img')
        board = Board.objects.filter(user=user, group=group)

        logger.info('받아온 이미지: {img}')
        
        if not board.exists():
            return Response(data={'message': '참여하지 않은 그룹입니다.'}, status=status.HTTP_400_BAD_REQUEST)
        
        board = Board.objects.get(user=user, group=group)
        
        chat = {
            'user_id': user.id,
            'badge_id': user.badge,
            'username': board.rand_name,
            'content': content,
            'created_at': datetime.now().strftime('%Y-%m-%d %H:%M:%S.%f'),
            'reviewed': False,
            'item_id': -1,
            'title': '',
            'id': RedisChat(group_id).getLength()
        }

        if img:
            logger.info('이미지 등록')

            chat['has_img'] = True

            url = 'chats' + '/' + str(group_id) + '/' + str(chat['id'])
            
            upload_image(url, img)
        else:
            logger.info('이미지 없음')
            chat['has_img'] = False
        
        RedisChat(group_id).addChat(chat)
        send_to_fcm(user, group, group.groupname, content, f'groups/{group.id}/chat', chat)
        logger.info('채팅 등록 완료')
            
        return Response(data=chat, status=status.HTTP_200_OK)


class GroupChatListView(APIView):
    def get(self, request, group_id):
        user = request.user
        group = Group.objects.get(id=group_id)
        idx = int(request.GET.get('idx'))
        
        if not Board.objects.filter(user=user, group=group).exists():
            return Response(data={'message': '참여하지 않은 그룹입니다.'}, status=status.HTTP_400_BAD_REQUEST)
        
        data = RedisChat(group_id).getChatList(idx)
        
        return Response(data=data, status=status.HTTP_200_OK)


class GroupReviewCreateView(APIView):
    def post(self, request, group_id):
        user = request.user
        group = Group.objects.get(id=group_id)
        content = request.data.get('content')
        item_id = int(request.data.get('item_id'))
        img = request.FILES.get('img')
        board = Board.objects.filter(user=user, group=group)

        if date.today() < group.start:
            return Response(data={'message': '시작일 이전에는 요청할 수 없습니다.'}, status=status.HTTP_400_BAD_REQUEST)
                
        if date.today() >= group.end:
            return Response(data={'message': '종료일이 경과하여 요청할 수 없습니다.'}, status=status.HTTP_400_BAD_REQUEST)
        
        if not board.exists():
            return Response(data={'message': '참여하지 않은 그룹입니다.'}, status=status.HTTP_400_BAD_REQUEST)
        
        board = Board.objects.get(user=user, group=group)

        chat = {
            'user_id': user.id,
            'badge_id': user.badge,
            'username': board.rand_name,
            'content': content,
            'created_at': datetime.now().strftime('%Y-%m-%d %H:%M:%S.%f'),
            'reviewed': False,
            'item_id': item_id,
            'title': BoardItem.objects.get(board=Board.objects.get(user=user, group=group), item_id=item_id).title,
            'id': RedisChat(group_id).getLength()
        }

        if img:
            chat['has_img'] = True

            url = 'chats' + '/' + str(group_id) + '/' + str(chat['id'])
            
            upload_image(url, img)
        else:
            chat['has_img'] = False
        
        RedisChat(group_id).addChat(chat)
        send_to_fcm(user, group, group.groupname, content, f'groups/{group.id}/chat', chat)
            
        return Response(data=chat, status=status.HTTP_200_OK)


class GroupReviewCheckView(APIView):
    def put(self, request, group_id):
        user = request.user
        group = Group.objects.get(id=group_id)
        review_id = int(request.data.get('review_id'))
        chat = RedisChat(group_id)
        review = chat.getChatItem(review_id)
        review_user = get_user_model().objects.get(id=review['user_id'])

        if date.today() < group.start:
            return Response(data={'message': '시작일 이전에는 인증할 수 없습니다.'}, status=status.HTTP_400_BAD_REQUEST)

        if date.today() >= group.end:
            return Response(data={'message': '종료일이 경과하여 인증할 수 없습니다.'}, status=status.HTTP_400_BAD_REQUEST)
        
        if not Board.objects.filter(user=user, group=group).exists():
            return Response(data={'message': '참여하지 않은 그룹입니다.'}, status=status.HTTP_400_BAD_REQUEST)
        
        if review_user == user:
            return Response(data={'message': '자신의 인증 요청은 인증할 수 없습니다.'}, status=status.HTTP_400_BAD_REQUEST)
        
        if review['reviewed']:
            return Response(data={'message': '이미 인증된 요청입니다.'}, status=status.HTTP_400_BAD_REQUEST)
        
        board = Board.objects.get(user=review_user, group=group)
        board_item = BoardItem.objects.get(board=board, item_id=int(review['item_id']))
        
        if board_item.finished:
            return Response(data={'message': '이미 완료된 항목입니다.'}, status=status.HTTP_400_BAD_REQUEST)
        
        # 횟수 측정 여부 확인
        if board_item.check:
            board_item.check_cnt += 1
            
            if board_item.check_cnt == board_item.check_goal:
                check_cnt_boarditems_complete(review_user, group, board_item)
                
        else:    
            check_cnt_boarditems_complete(review_user, group, board_item)
        
        review['reviewed'] = True
        chat.setChatItem(review_id, review)

        send_to_fcm(review_user, '', '인증 완료!', '요청하신 인증이 완료되었습니다.', f'groups/{group.id}/myboard/{board.id}')
        
        return Response(status=status.HTTP_200_OK)


class GroupAdminView(APIView):
    def get(self, request, group_id):
        user = request.user
        group = Group.objects.get(id=group_id)
        
        if not Board.objects.filter(user=user, group=group).exists() or user != group.leader:
            return Response(data={'message': '권한이 없습니다.'}, status=status.HTTP_400_BAD_REQUEST)
        
        applicants = []
        members = []
        
        for board in Board.objects.filter(group=group):
            if board.is_banned == 1:
                if date.today() < group.start:
                    applicants.append({
                        'id': board.user.id,
                        'username': board.rand_name if group.is_public else board.user.username,
                        'board_id': board.id,
                        'badge': board.user.badge
                        })
            elif board.is_banned == 0:
                members.append({
                    'id': board.user.id,
                    'username': board.rand_name if group.is_public else board.user.username,
                    'board_id': board.id,
                    'badge': board.user.badge
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
        idx = int(request.GET.get('idx'))

        last_idx = -1

        if order == '0':
            order = '-start'
        else:
            order = 'start'

        groups = Group.objects.filter(start__gt=date.today())

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

        groups = [d for d in groups if d['count'] < d['headcount'] and not Board.objects.filter(group=d['id'], user=user).exists()]
        
        if groups:
            last_idx = groups[-1]['id']

        if idx == 0:
            groups = groups[:10]
        else:
            cut = 0
            for i in range(len(groups)):
                if groups[i]['id'] == idx:
                    cut = i + 1
                    break
            groups = groups[cut:cut + 10]
        
        if not groups:
            last_idx = -1
        
        return Response(data={'groups': groups, 'last_idx': last_idx}, status=status.HTTP_200_OK)