from django.urls import path

from rest_framework_simplejwt.views import TokenRefreshView, TokenVerifyView

from . import views

app_name = 'accounts'
urlpatterns = [
    path('kakao/', views.KakaoView.as_view(), name='kakao'),
    path('kakao/callback/', views.KaKaoCallBackView.as_view(), name='kakao_callback'),
    path('token/', views.TokenObtainView.as_view(), name='token_obtain'),
    path('token/refresh/', TokenRefreshView.as_view(), name='token_refresh'),
    path('token/verify/', TokenVerifyView.as_view(), name='token_verify'),
]