from django.contrib.auth import get_user_model
from rest_framework import serializers
from datetime import date

from .models import Badge
from groups.models import Group
from boards.models import Board

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
        elif date.today() >= obj.start:
            return '진행 중'
        else:
            return '시작 전'
    
    class Meta:
        model = Group
        fields = ('id', 'groupname', 'is_public', 'start', 'end', 'headcount', 'status')


class BoardSerializer(serializers.ModelSerializer):
    groupname = serializers.SerializerMethodField('get_groupname')
    start = serializers.SerializerMethodField('get_start')
    end = serializers.SerializerMethodField('get_end')
    status = serializers.SerializerMethodField('get_status')
    size = serializers.SerializerMethodField('get_size')

    def get_groupname(self, obj):
        return obj.group.groupname

    def get_start(self, obj):
        return obj.group.start
    
    def get_end(self, obj):
        return obj.group.end

    def get_status(self, obj):
        if date.today() > obj.group.end:
            return '완료'
        elif date.today() >= obj.group.start:
            return '진행 중'
        else:
            return '시작 전'
    
    def get_size(self, obj):
        return obj.group.size
    
    class Meta:
        model = Board
        fields = ('id', 'groupname', 'start', 'end', 'status', 'size')