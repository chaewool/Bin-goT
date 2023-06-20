from django.contrib.auth import get_user_model
from rest_framework import serializers
from datetime import date

from .models import Badge
from groups.models import Group

class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = get_user_model()
        fields = ('noti_rank', 'noti_due', 'noti_chat', 'noti_check', 'id')


class BadgeSerializer(serializers.ModelSerializer):
    class Meta:
        model = Badge
        fields = '__all__'


class GroupSerializer(serializers.ModelSerializer):
    status = serializers.SerializerMethodField('get_status')
    
    def get_status(self, obj):
        if date.today() > obj.end:
            return '완료'
        elif date.today() > obj.start:
            return '진행 중'
        else:
            return '시작 전'
    
    class Meta:
        model = Group
        fields = ('id', 'groupname', 'is_public', 'start', 'end', 'headcount', 'status')


class BoardSerializer(serializers.ModelSerializer):
    status = serializers.SerializerMethodField('get_status')

    def get_status(self, obj):
        if date.today() > obj.end:
            return '완료'
        elif date.today() > obj.start:
            return '진행 중'
        else:
            return '시작 전'
    
    class Meta:
        model = Group
        fields = ('id', 'groupname', 'start', 'end', 'status', 'size')