from django.contrib.auth import get_user_model
from rest_framework import serializers

from .models import Badge
from groups.models import Group, Board


class ProfileSerializer(serializers.ModelSerializer):
    class Meta:
        model = get_user_model()
        fields = ('username', 'badge', 'cnt_boards_complete', 'cnt_rank1', 'cnt_badge')

        
class NotificationSerializer(serializers.ModelSerializer):
    class Meta:
        model = get_user_model()
        fields = ('noti_rank', 'noti_due', 'noti_chat', 'noti_check')


class BadgeSerializer(serializers.ModelSerializer):
    class Meta:
        model = Badge
        fields = '__all__'


class GroupSerializer(serializers.ModelSerializer):
    status = serializers.SerializerMethodField('get_status')
    
    def get_status(self, obj):
        if obj.status == 2:
            return '완료'
        elif obj.status == 1:
            return '진행 중'
        else:
            return '시작 전'
    
    class Meta:
        model = Group
        fields = ('id', 'groupname', 'is_public', 'start', 'end', 'headcount', 'status', 'count')


class BoardSerializer(serializers.ModelSerializer):
    group_id = serializers.SerializerMethodField('get_groupid')
    groupname = serializers.SerializerMethodField('get_groupname')
    start = serializers.SerializerMethodField('get_start')
    end = serializers.SerializerMethodField('get_end')
    status = serializers.SerializerMethodField('get_status')
    size = serializers.SerializerMethodField('get_size')

    def get_groupid(self, obj):
        return obj.group.id

    def get_groupname(self, obj):
        return obj.group.groupname

    def get_start(self, obj):
        return obj.group.start
    
    def get_end(self, obj):
        return obj.group.end

    def get_status(self, obj):
        if obj.group.status == 2:
            return '완료'
        elif obj.group.status == 1:
            return '진행 중'
        else:
            return '시작 전'
    
    def get_size(self, obj):
        return obj.group.size
    
    class Meta:
        model = Board
        fields = ('id', 'group_id', 'groupname', 'start', 'end', 'status', 'size')