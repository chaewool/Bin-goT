from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from datetime import datetime
import json

from commons import SUCCESS, FAIL, upload_image, delete_image
from .serializers import GroupCreateSerializer, GroupDetailSerializer, GroupUpdateSerializer
from .models import Group, Participate

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
        
        if period > 365 or headcount < 1 or headcount > 30 or size < 2 or size > 5 or (is_public and password == ''):
            return Response(data=FAIL, status=status.HTTP_400_BAD_REQUEST)
        
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
                serializer.save(leader=user, period=period, has_img=True)
                
                url = 'groups' + '/' + str(serializer.data.get('id'))
                
                upload_image(url, img)
            else:
                serializer.save(leader=user, period=period, has_img=False)
        
        group_id = serializer.data.get('id')
        if is_public:
            num = len(Participate.objects.all())
            rand_name = f'익명의 참여자 {num + 1}'
            Participate.objects.create(user=user, group=Group.objects.get(id=group_id), is_banned=False, rand_name=rand_name)
        else:
            Participate.objects.create(user=user, group=Group.objects.get(id=group_id), is_banned=False)
        
        data = {**SUCCESS, 'group_id': group_id}
            
        return Response(data=data, status=status.HTTP_200_OK)


class GroupDetailView(APIView):
    def post(self, request, group_id):
        user = request.user
        group = Group.objects.get(id=group_id)
        password = request.POST.get('password')
        
        rand_name = user.username
        participate = Participate.objects.filter(user=user, group=group)
        
        # 그룹 가입 여부 확인
        if participate.exists():
            # 강제 탈퇴 여부 확인
            if participate.is_banned:
                data = {**FAIL, 'message': '탈퇴 처리된 그룹입니다.'}
                return Response(data=data, status=status.HTTP_400_BAD_REQUEST)
            
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
                data = {**FAIL, 'message': '잘못된 비밀번호입니다.'}
                return Response(data=data, status=status.HTTP_400_BAD_REQUEST)
            
            is_participant = 0

        serializer = GroupDetailSerializer(group)
        data = {**serializer.data, 'is_participant': is_participant, 'rand_name': rand_name}
        
        return Response(data=data, status=status.HTTP_200_OK)


class GroupUpdateView(APIView):
    def put(self, request, group_id):
        user = request.user
        group = Group.objects.get(id=group_id)
        
        if user == group.leader:
            serializer = GroupUpdateSerializer(instance=group, data=request.data)
            
            if serializer.is_valid(raise_exception=True):
                url = 'groups' + '/' + str(group.id)
                
                if img != None:
                    img = request.FILES.get('img')    
                    upload_image(url, img)
                    serializer.save(has_img=True)
                else:
                    if group.has_img:
                        delete_image(url)
                    serializer.save(has_img=False)
                
                return Response(data=SUCCESS, status=status.HTTP_200_OK)
        return Response(data=FAIL, status=status.HTTP_400_BAD_REQUEST)


class GroupDeleteView(APIView):
    def delete(self, request, group_id):
        
        return Response(data=SUCCESS, status=status.HTTP_200_OK)