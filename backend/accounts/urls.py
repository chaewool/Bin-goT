from django.urls import path
from . import views

app_name = 'accounts'
urlpatterns = [
    path('kakao/', views.KakaoView.as_view(), name='kakao'),
    path('kakao/callback/', views.KaKaoCallBackView.as_view(), name='kakaoCallback'),
]