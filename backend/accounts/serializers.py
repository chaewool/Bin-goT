from django.contrib.auth import get_user_model
from rest_framework import serializers
from datetime import date

from .models import Badge
from groups.models import Group

class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = get_user_model()
        fields = ('id', 'username', 'profile', 'noti_rank', 'noti_due', 'noti_chat', 'is_active', 'groups')


class BadgeSerializer(serializers.ModelSerializer):
    class Meta:
        model = Badge
        fields = '__all__'


class ProfileGroupSerializer(serializers.ModelSerializer):
    count = serializers.SerializerMethodField('get_count')
    status = serializers.SerializerMethodField('get_status')
    
    def get_count(self, obj):
        return obj.users.count()
    
    def get_status(self, obj):
        if date.today() > obj.end:
            return '완료'
        elif date.today() > obj.start:
            return '진행 중'
        else:
            return '시작 전'
    
    class Meta:
        model = Group
        fields = ('id', 'groupname', 'start', 'end', 'headcount', 'count', 'status')