from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from django.contrib.auth import get_user_model
from datetime import datetime, date
import json

from commons import upload_image, delete_image
from .serializers import GroupCreateSerializer, GroupDetailSerializer, GroupUpdateSerializer, GroupSearchSerializer
from .models import Group, Participate, Chat, Review
from boards.models import Board

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
        
        return Response(data={'group_id': group.id}, status=status.HTTP_200_OK)


class GroupDetailView(APIView):
    def post(self, request, group_id):
        user = request.user
        group = Group.objects.get(id=group_id)
        password = request.POST.get('password')
        
        rand_name = user.username
        participate = Participate.objects.filter(user=user, group=group)
        board_id = 0
        
        if Board.objects.filter(user=user, group=group).exists():
            board_id = Board.objects.get(user=user, group=group).id
        
        # 그룹 가입 여부 확인
        if participate.exists():
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
        data = {**serializer.data, 'is_participant': is_participant, 'rand_name': rand_name, 'board_id': board_id}
        
        return Response(data=data, status=status.HTTP_200_OK)


class GroupUpdateView(APIView):
    def put(self, request, group_id):
        user = request.user
        group = Group.objects.get(id=group_id)
        data = json.loads(request.data.get('data'))

        if not data['groupname']:
            data['groupname'] = group.groupname
        
        if not data['headcount']:
            data['headcount'] = group.headcount

        if data['headcount'] < 1 or data['headcount'] > 30:
            return Response(data={'message': '인원 수는 1명 이상 30명 이하로 지정해야 합니다.'}, status=status.HTTP_400_BAD_REQUEST)
        
        if user == group.leader:
            serializer = GroupUpdateSerializer(instance=group, data=data)

            if serializer.is_valid(raise_exception=True):
                img = request.FILES.get('img')    
                url = 'groups' + '/' + str(group.id)
                
                if img != None:
                    upload_image(url, img)
                    serializer.save(has_img=True)
                else:
                    serializer.save()
                
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
            else:
                Participate.objects.create(user=user, group=group, is_banned=True)
            return Response(status=status.HTTP_200_OK)
        
        return Response(data={'message': '이미 가입한 그룹입니다.'}, status=status.HTTP_400_BAD_REQUEST)


class GroupGrantView(APIView):
    def post(self, request, group_id):
        user = request.user
        group = Group.objects.get(id=group_id)
        applicant_id = request.POST.get('applicant_id')
        grant = request.POST.get('grant')

        if group.leader == user:
            applicant = get_user_model().objects.get(id=applicant_id)
            participate = Participate.objects.filter(user=applicant, group=group)

            if participate.is_banned and not grant:
                pass
            elif participate.is_banned and grant:
                participate.is_banned = False
                participate.save()
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


class GroupChatCreateView(APIView):
    def post(self, request, group_id):
        user = request.user
        group = Group.objects.get(id=group_id)
        content = request.POST.get('content')
        img = request.FILES.get('img')
        
        if not Participate.objects.filter(user=user, group=group).exists():
            return Response(data={'message': '참여하지 않은 그룹입니다.'}, status=status.HTTP_400_BAD_REQUEST)
        
        chat = Chat(user=user, group=group, content=content)

        if img:
            chat.has_img = True
            chat.save()

            url = 'chats' + '/' + str(chat.id)
            
            upload_image(url, img)
            
        return Response(data={'chat_id': chat.id}, status=status.HTTP_200_OK)


class GroupSearchView(APIView):
    def get(self, request):
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
        data = [d for d in data if d['count'] < d['headcount']]
        
        return Response(data=data, status=status.HTTP_200_OK)


class GroupRecommendView(APIView):
    def get(self, request):
        groups = Group.objects.filter(is_public=True)
        
        data = GroupSearchSerializer(groups, many=True).data
        data = [d for d in data if d['count'] < d['headcount']]
        
        return Response(data=data, status=status.HTTP_200_OK)