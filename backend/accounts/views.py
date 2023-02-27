from django.shortcuts import redirect
from django.views import View
from django.http import JsonResponse
import requests
import logging

from rest_framework_simplejwt.views import TokenObtainPairView

from .models import User
from bingot_settings import KAKAO_REST_API_KEY
from .serializers import ServiceTokenObtainPairSerializer

logger = logging.getLogger('accounts')

class KakaoView(View):
    def get(self, request):
        # 인가 코드 받기 요청
        app_key = KAKAO_REST_API_KEY
        redirect_uri = 'https://bingot.xyz/api/accounts/kakao/callback'
        kakao_auth_api = 'https://kauth.kakao.com/oauth/authorize?response_type=code'

        # 인증 및 동의 요청(카카오 로그인 페이지로 이동)
        return redirect(
            f'{kakao_auth_api}&client_id={app_key}&redirect_uri={redirect_uri}'
        )

class KaKaoCallBackView(View):
    def get(self, request):
        # 인가 코드로 토큰 발급 요청
        auth_code = request.GET.get('code')
        kakao_token_api = 'https://kauth.kakao.com/oauth/token'
        data = {
            'grant_type': 'authorization_code',
            'client_id': KAKAO_REST_API_KEY,
            'redirection_uri': 'https://bingot.xyz/api/accounts/kakao/callback',
            'code': auth_code
        }

        # 토큰 발급
        token_response = requests.post(kakao_token_api, data=data)
        access_token = token_response.json().get('access_token')
        
        # 카카오 로그인 완료, 토큰으로 사용자 정보 가져오기 요청
        kakao_token_api = 'https://kapi.kakao.com/v2/user/me'
        headers = {"Authorization": f'Bearer ${access_token}'}

        # 요청 검증 및 처리
        user_info_response = requests.get(kakao_token_api, headers=headers).json()
        kakao_id = user_info_response['id']

        # 제공받은 사용자 정보로 서비스 회원 여부 확인
        # 회원이 아니라면 회원 가입 처리
        if User.objects.filter(kakao_id=kakao_id).exists():
            user = User.objects.get(kakao_id=kakao_id)
        else:
            username = user_info_response['properties']['nickname']
            user = User.objects.create(kakao_id=kakao_id, username=username)
            
        # 서비스 토큰 발급
        return redirect('token_obtain_pair', user=user)


class ServiceTokenObtainPairView(TokenObtainPairView):
    serializer_class = ServiceTokenObtainPairSerializer