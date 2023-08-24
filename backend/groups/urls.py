from django.urls import path

from . import views

app_name = 'groups'
urlpatterns = [
    path('create/', views.GroupCreateView.as_view(), name='group_create'),
    path('<int:group_id>/', views.GroupDetailView.as_view(), name='group_detail'),
    path('<int:group_id>/update/', views.GroupUpdateView.as_view(), name='group_update'),
    path('<int:group_id>/delete/', views.GroupDeleteView.as_view(), name='group_delete'),

    path('<int:group_id>/join/', views.GroupJoinView.as_view(), name='group_join'),
    path('<int:group_id>/grant/', views.GroupGrantView.as_view(), name='group_grant'),
    path('<int:group_id>/resign/', views.GroupResignView.as_view(), name='group_resign'),
    
    path('<int:group_id>/rank/', views.GroupRankView.as_view(), name='group_rank'),

    path('<int:group_id>/boards/<int:board_id>/', views.BoardDetailView.as_view(), name='board_detail'),
    path('<int:group_id>/boards/<int:board_id>/update/', views.BoardUpdateView.as_view(), name='board_update'),
    
    path('<int:group_id>/chat/create/', views.GroupChatCreateView.as_view(), name='group_chat_create'),
    path('<int:group_id>/chat/list/', views.GroupChatListView.as_view(), name='group_chat_list'),

    path('<int:group_id>/review/create/', views.GroupReviewCreateView.as_view(), name='group_review_create'),
    path('<int:group_id>/review/check/', views.GroupReviewCheckView.as_view(), name='group_review_check'),
    
    path('<int:group_id>/admin/', views.GroupAdminView.as_view(), name='group_admin'),
    
    path('search/', views.GroupSearchView.as_view(), name='group_search'),
]
