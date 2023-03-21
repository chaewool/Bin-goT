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
    
    path('search/', views.GroupSearchView.as_view(), name='group_search'),
    path('recommend/', views.GroupRecommendView.as_view(), name='group_recommend'),
]
