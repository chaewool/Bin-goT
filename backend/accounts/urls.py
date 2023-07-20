from django.urls import path

from rest_framework_simplejwt.views import TokenVerifyView

from . import views

app_name = 'accounts'
urlpatterns = [
    path('kakao/', views.KakaoView.as_view(), name='kakao'),
    path('kakao/callback/', views.KaKaoCallBackView.as_view(), name='kakao_callback'),
    path('kakao/native/', views.KaKaoNativeView.as_view(), name='kakao_native'),
    path('kakao/unlink/', views.KaKaoUnlinkView.as_view(), name='kakao_unlink'),
    path('token/verify/', TokenVerifyView.as_view(), name='token_verify'),
    path('token/refresh/', views.TokenRefreshView.as_view(), name='token_refresh'),
    path('token/fcm/', views.TokenFCMView.as_view(), name='token_fcm'),
    
    path('username/check/', views.UsernameCheckView.as_view(), name='username_check'),
    path('username/update/', views.UsernameUpdateView.as_view(), name='username_update'),
    
    path('badge/list/', views.BadgeListView.as_view(), name='badge_list'),
    path('badge/update/', views.BadgeUpdateView.as_view(), name='badge_update'),
    
    path('notification/update/', views.NotificationUpdateView.as_view(), name='notification_update'),
    
    path('main/groups/', views.MainGroupsView.as_view(), name='main_groups'),
    path('main/boards/', views.MainBoardsView.as_view(), name='main_boards'),
    path('profile/', views.ProfileView.as_view(), name='profile'),
]