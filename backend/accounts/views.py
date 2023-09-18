from django.shortcuts import redirect
from django.contrib.auth import get_user_model
from rest_framework.views import APIView
from rest_framework.permissions import AllowAny
from rest_framework.response import Response
from rest_framework import status
from rest_framework_simplejwt.serializers import TokenObtainPairSerializer
import requests
import logging
from datetime import date
import jwt

from bingot.settings import SIMPLE_JWT
from bingot_settings import KAKAO_REST_API_KEY
from .serializers import ProfileSerializer, NotificationSerializer, BadgeSerializer, GroupSerializer, BoardSerializer
from .models import Achieve, Badge
from groups.models import Group, Board
from commons import get_boolean, RedisToken


User = get_user_model()
logger = logging.getLogger('accounts')


class KakaoView(APIView):
    permission_classes = [AllowAny]
    
    def get(self, request):
        # 인가 코드 받기 요청
        app_key = KAKAO_REST_API_KEY
        redirect_uri = 'https://bingot.xyz/api/accounts/kakao/callback'
        kakao_auth_api = 'https://kauth.kakao.com/oauth/authorize?response_type=code'

        # 인증 및 동의 요청(카카오 로그인 페이지로 이동)
        return redirect(
            f'{kakao_auth_api}&client_id={app_key}&redirect_uri={redirect_uri}'
        )


def from_kaKao_id_get_user_info(kakao_id):
    # 제공받은 사용자 정보로 서비스 회원 여부 확인
    # 회원이 아니라면 회원 가입 처리
    # 확인이 끝나면 사용자 정보 반환
    data = {}
    
    if User.objects.filter(kakao_id=kakao_id).exists():
        data['is_login'] = True
        user = User.objects.get(kakao_id=kakao_id)
    else:
        data['is_login'] = False
        username = f'사용자 {kakao_id}'
        user = User.objects.create(kakao_id=kakao_id, username=username)
        badge = Badge.objects.get(id=1)
        Achieve.objects.create(user=user, badge=badge)

    token = TokenObtainPairSerializer.get_token(user)
    
    data['refresh_token'] = str(token)
    data['access_token'] = str(token.access_token)
    data['id'] = user.pk
    
    return data


# Redirect(REST API) 방식
class KaKaoCallBackView(APIView):
    permission_classes = [AllowAny]
    
    def get(self, request):
        # 인가 코드로 카카오 토큰 발급 요청
        auth_code = request.GET.get('code')
        kakao_token_api = 'https://kauth.kakao.com/oauth/token'
        data = {
            'grant_type': 'authorization_code',
            'client_id': KAKAO_REST_API_KEY,
            'redirection_uri': 'https://bingot.xyz/api/accounts/kakao/callback',
            'code': auth_code
        }

        # 카카오 토큰 발급
        token_response = requests.post(kakao_token_api, data=data)
        access_token = token_response.json().get('access_token')
        
        # 카카오 토큰으로 사용자 정보 가져오기 요청
        kakao_token_api = 'https://kapi.kakao.com/v2/user/me'
        headers = {"Authorization": f'Bearer ${access_token}'}

        # 요청 검증 및 처리
        user_info_response = requests.get(kakao_token_api, headers=headers).json()
        kakao_id = user_info_response['id']
        
        data = from_kaKao_id_get_user_info(kakao_id)
            
        return Response(data=data, status=status.HTTP_200_OK)


# 기본(네이티브 앱) 방식
class KaKaoNativeView(APIView):
    permission_classes = [AllowAny]
    
    def post(self, request):
        kakao_id = request.data.get('kakao_id')
        
        data = from_kaKao_id_get_user_info(kakao_id)
            
        return Response(data=data, status=status.HTTP_200_OK)
    

class KaKaoUnlinkView(APIView):
    def delete(self, request):
        user = request.user
        user.delete()
        return Response(status=status.HTTP_200_OK)


class TokenRefreshView(APIView):
    permission_classes = [AllowAny]

    def post(self, request):
        token = request.data.get('token')

        user_id = jwt.decode(
            token,
            SIMPLE_JWT['SIGNING_KEY'],
            algorithms=[SIMPLE_JWT['ALGORITHM']],
        )['user_id']
        user = get_user_model().objects.get(pk=user_id)

        tokens = TokenObtainPairSerializer.get_token(user)
        
        data = {}
        data['refresh_token'] = str(tokens)
        data['access_token'] = str(tokens.access_token)

        return Response(data=data, status=status.HTTP_200_OK)
    

class TokenFCMView(APIView):
    def post(self, request):
        user = request.user
        fcm_token = request.data.get('fcm_token')

        token = RedisToken()
        token.setToken(user.id, fcm_token)
        return Response(data={}, status=status.HTTP_200_OK)


class UsernameCheckView(APIView):
    def post(self, request):
        username = request.data.get('username')
        
        if User.objects.filter(username=username).exists():
            return Response(data={'message': '존재하는 닉네임입니다.'}, status=status.HTTP_400_BAD_REQUEST)
        return Response(data={}, status=status.HTTP_200_OK)
    
    
class UsernameUpdateView(APIView):
    def post(self, request):
        user = request.user
        username = request.data.get('username')
        
        if User.objects.filter(username=username).exists():
            return Response(data={'message': '존재하는 닉네임입니다.'}, status=status.HTTP_400_BAD_REQUEST)
        
        user.username = username
        user.save()
        
        return Response(data={}, status=status.HTTP_200_OK)
    
    
class BadgeListView(APIView):
    def get(self, request):
        user = request.user
        data = BadgeSerializer(Badge.objects.all(), many=True).data

        for i in range(len(data)):
            if Achieve.objects.filter(user=user, badge=data[i].get('id')).exists():
                data[i]['has_badge'] = True
            else:
                data[i]['has_badge'] = False

        return Response(data=data, status=status.HTTP_200_OK)
        
    
class BadgeUpdateView(APIView):
    def put(self, request):
        user = request.user
        badge_id = request.data.get('badge_id')
        badge = Badge.objects.get(id=badge_id)
        
        if Achieve.objects.filter(user=user, badge=badge).exists():
            user.badge = badge_id
            user.save()
            
            return Response(data={}, status=status.HTTP_200_OK)
        return Response(data={'message': '보유하지 않은 배지입니다.'}, status=status.HTTP_400_BAD_REQUEST)

    
class NotificationDetailView(APIView):
    def get(self, request):
        user = request.user
        data = NotificationSerializer(user).data

        return Response(data=data, status=status.HTTP_200_OK)
 
    
class NotificationUpdateView(APIView):
    def put(self, request):
        user = request.user
        noti_rank = request.data.get('noti_rank')
        noti_chat = request.data.get('noti_chat')
        noti_due = request.data.get('noti_due')
        noti_check = request.data.get('noti_check')
        
        user.noti_rank = get_boolean(noti_rank)
        user.noti_chat = get_boolean(noti_chat)
        user.noti_due = get_boolean(noti_due)
        user.noti_check = get_boolean(noti_check)
        user.save()
            
        return Response(data={}, status=status.HTTP_200_OK)


class MainGroupsView(APIView):
    def get(self, request):
        user = request.user
        order = request.GET.get('order')
        filter = request.GET.get('filter')
        idx = int(request.GET.get('idx'))
        
        is_recommend = False
        last_idx = -1

        boards = Board.objects.filter(user=user, is_banned=0)

        # 가입한 그룹이 없음 => 그룹 추천
        if not boards:
            is_recommend = True

            recommends = Group.objects.filter(is_public=True, start__gt=date.today()).order_by('-start')
            groups = GroupSerializer(recommends, many=True).data
        else:            
            groups = GroupSerializer(user.groups, many=True).data

            temp = []
            for group in groups:
                if Board.objects.filter(group=group['id'], user=user, is_banned=0):
                    temp.append(group)
            groups = temp[:]

            if filter == '1':
                groups = [group for group in groups if group['status'] == '진행 중']
            elif filter == '2':
                groups = [group for group in groups if group['status'] == '완료']
            
            if order == '0':
                groups.sort(key=lambda x: (x['end'], x['start']), reverse=True)
            else:
                groups.sort(key=lambda x: (x['end'], x['start']))
            
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
        
        if is_recommend:
            groups = [group for group in groups if group['count'] < group['headcount']][:10]
        
        return Response(data={'groups': groups, 'is_recommend': is_recommend, 'last_idx': last_idx}, status=status.HTTP_200_OK)


class MainBoardsView(APIView):
    def get(self, request):
        user = request.user
        order = request.GET.get('order')
        filter = request.GET.get('filter')
        idx = int(request.GET.get('idx'))

        boards = BoardSerializer(user.boards.all(), many=True).data

        temp = []
        for board in boards:
            if Board.objects.filter(group=board['group_id'], user=user, is_banned=0):
                temp.append(board)
        boards = temp[:]

        if filter == '1':
            boards = [board for board in boards if board['status'] == '진행 중']
        elif filter == '2':
            boards = [board for board in boards if board['status'] == '완료']
        
        if order == '0':
            boards.sort(key=lambda x: (x['end'], x['start']), reverse=True)
        else:
            boards.sort(key=lambda x: (x['end'], x['start']))

        last_idx = -1
        if boards:
            last_idx = boards[-1]['id']
            
        if idx == 0:
            boards = boards[:10]
        else:
            cut = 0
            for i in range(len(boards)):
                if boards[i]['id'] == idx:
                    cut = i + 1
                    break
            boards = boards[cut:cut + 10]
        
        if not boards:
            last_idx = -1
        
        return Response(data={'boards': boards, 'last_idx': last_idx}, status=status.HTTP_200_OK)


class ProfileView(APIView):
    def get(self, request):
        user = request.user
        data = ProfileSerializer(user).data

        return Response(data=data, status=status.HTTP_200_OK)
