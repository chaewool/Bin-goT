from django.urls import path

from . import views

app_name = 'boards'
urlpatterns = [
    path('<int:board_id>/', views.BoardDetailView.as_view(), name='board_detail'),
    path('<int:board_id>/update/', views.BoardUpdateView.as_view(), name='board_update'),
]
