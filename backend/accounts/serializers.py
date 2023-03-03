from django.contrib.auth import get_user_model
from rest_framework import serializers

class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = get_user_model()
        fields = ('id', 'username', 'profile', 'noti_rank', 'noti_due', 'noti_chat', 'is_active', 'groups')