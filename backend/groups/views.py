from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from django.contrib.auth import get_user_model
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
        
        if period > 365 or headcount < 1 or headcount > 30 or size < 2 or size > 5 or (not is_public and password == ''):
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
        
        data = {**SUCCESS, 'group_id': group.id}
            
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
        data = json.loads(request.data.get('data'))

        if not data['groupname']:
            data['groupname'] = group.groupname
        
        if not data['headcount']:
            data['headcount'] = group.headcount

        if data['headcount'] < 1 or data['headcount'] > 30:
            return Response(data=FAIL, status=status.HTTP_400_BAD_REQUEST)
        
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
                
                return Response(data=SUCCESS, status=status.HTTP_200_OK)
        return Response(data=FAIL, status=status.HTTP_400_BAD_REQUEST)


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
                return Response(data=SUCCESS, status=status.HTTP_200_OK)
            
            Participate.objects.create(user=user, group=group, is_banned=True)
            return Response(data=FAIL, status=status.HTTP_200_OK)
        
        data = {**FAIL, 'message': '이미 가입한 그룹입니다.'}
        return Response(data=data, status=status.HTTP_400_BAD_REQUEST)


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

            return Response(data=SUCCESS, status=status.HTTP_200_OK)
        
        data = {**FAIL, 'message': '그룹장이 아닙니다.'}
        return Response(data=data, status=status.HTTP_400_BAD_REQUEST)
        


class GroupDeleteView(APIView):
    def delete(self, request, group_id):
        
        return Response(data=SUCCESS, status=status.HTTP_200_OK)