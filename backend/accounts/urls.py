from django.urls import path

from rest_framework_simplejwt.views import TokenRefreshView, TokenVerifyView

from . import views

app_name = 'accounts'
urlpatterns = [
    path('kakao/', views.KakaoView.as_view(), name='kakao'),
    path('kakao/callback/', views.KaKaoCallBackView.as_view(), name='kakao_callback'),
    path('token/', views.ServiceTokenObtainPairView.as_view(), name='token_obtain_pair'),
    path('token/refresh/', TokenRefreshView.as_view(), name='token_refresh'),
    path('token/verify/', TokenVerifyView.as_view(), name='token_verify'),
]