from django.shortcuts import redirect
from django.contrib.auth import get_user_model
from rest_framework.views import APIView
from rest_framework.permissions import AllowAny
from rest_framework.response import Response
from rest_framework import status
from rest_framework_simplejwt.serializers import TokenObtainPairSerializer
import requests
import logging

from bingot_settings import KAKAO_REST_API_KEY
from commons import SUCCESS, FAIL
from .serializers import UserSerializer
from .models import Achieve, Badge

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
        
        # 카카오 로그인 완료, 카카오 토큰으로 사용자 정보 가져오기 요청
        kakao_token_api = 'https://kapi.kakao.com/v2/user/me'
        headers = {"Authorization": f'Bearer ${access_token}'}

        # 요청 검증 및 처리
        user_info_response = requests.get(kakao_token_api, headers=headers).json()
        kakao_id = user_info_response['id']

        # 제공받은 사용자 정보로 서비스 회원 여부 확인
        # 회원이 아니라면 회원 가입 처리
        # 확인이 끝나면 사용자 정보 반환
        if User.objects.filter(kakao_id=kakao_id).exists():
            user = User.objects.get(kakao_id=kakao_id)
        else:
            username = user_info_response['properties']['nickname']
            user = User.objects.create(kakao_id=kakao_id, username=username)
            badge = Badge.objects.get(id=1)
            Achieve.objects.create(user=user, badge=badge)
        
        serializer = UserSerializer(user)
            
        return Response(data=serializer.data, status=status.HTTP_200_OK)


class KaKaoUnlinkView(APIView):
    def delete(self, request):
        user = request.user
        user = User.objects.get(id=user.id)
        user.delete()
        return Response(data=SUCCESS, status=status.HTTP_200_OK)


class TokenObtainView(APIView):
    permission_classes = [AllowAny]
    
    def post(self, request):
        # 사용자 정보로 서비스 토큰 발급
        user = User.objects.get(id=request.POST.get('id'))
        token = TokenObtainPairSerializer.get_token(user)
        
        return Response(data={
            'refresh_token': str(token),
            'access_token': str(token.access_token),
        }, status=status.HTTP_200_OK)


class UsernameCheckView(APIView):
    def post(self, request):
        username = request.POST.get('username')
        
        if User.objects.filter(username=username).exists():
            return Response(data=FAIL, status=status.HTTP_400_BAD_REQUEST)
        return Response(data=SUCCESS, status=status.HTTP_200_OK)
    
    
class UsernameUpdateView(APIView):
    def post(self, request):
        user = request.user
        username = request.POST.get('username')
        
        if User.objects.filter(username=username).exists():
            return Response(data=FAIL, status=status.HTTP_400_BAD_REQUEST)
        
        user.username = username
        user.save()
        
        return Response(data=SUCCESS, status=status.HTTP_200_OK)
    
    
class BadgeListView(APIView):
    def get(self, request):
        user = request.user
        data = Achieve.objects.filter(user=user)
        return Response(data=data, status=status.HTTP_200_OK)
        
    
class BadgeUpdateView(APIView):
    def post(self, request):
        user = request.user
        badge_id = request.POST.get('badge_id')
        badge = Badge.objects.get(id=badge_id)
        
        if Achieve.objects.filter(user=user, badge=badge).exists():
            user.profile = badge_id
            user.save()
            
            return Response(SUCCESS, status=status.HTTP_200_OK)
        return Response(FAIL, status=status.HTTP_400_BAD_REQUEST)
        
    
class NotificationUpdateView(APIView):
    def post(self, request):
        user = request.user
        noti_rank = request.POST.get('noti_rank')
        noti_chat = request.POST.get('noti_chat')
        noti_due = request.POST.get('noti_due')
        
        user.noti_rank = noti_rank
        user.noti_chat = noti_chat
        user.noti_due = noti_due
        user.save()
            
        return Response(SUCCESS, status=status.HTTP_200_OK)
