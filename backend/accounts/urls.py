from django.urls import path

from rest_framework_simplejwt.views import TokenRefreshView, TokenVerifyView

from . import views

app_name = 'accounts'
urlpatterns = [
    path('kakao/', views.KakaoView.as_view(), name='kakao'),
    path('kakao/callback/', views.KaKaoCallBackView.as_view(), name='kakao_callback'),
    path('kakao/unlink/', views.KaKaoUnlinkView.as_view(), name='kakao_unlink'),
    path('token/', views.TokenObtainView.as_view(), name='token_obtain'),
    path('token/refresh/', TokenRefreshView.as_view(), name='token_refresh'),
    path('token/verify/', TokenVerifyView.as_view(), name='token_verify'),
    
    path('username/check/', views.UsernameCheckView.as_view(), name='username_check'),
    path('username/update/', views.UsernameUpdateView.as_view(), name='username_update'),
    
    path('badge/list/', views.BadgeListView.as_view(), name='badge_list'),
    path('badge/update/', views.BadgeUpdateView.as_view(), name='badge_update'),
    
    path('notification/update/', views.NotificationUpdateView.as_view(), name='notification_update'),
    
    path('profile/groups/', views.ProfileGroupsView.as_view(), name='profile_groups'),
    path('profile/boards/', views.ProfileBoardsView.as_view(), name='profile_boards'),
]