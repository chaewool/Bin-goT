from rest_framework import serializers
from rest_framework.exceptions import ValidationError

from .models import Group, Board, BoardItem


class GroupCreateSerializer(serializers.ModelSerializer):
    password = serializers.CharField(required=False, allow_blank=True, allow_null=True)
    description = serializers.CharField(required=False, allow_blank=True, allow_null=True)
    rule = serializers.CharField(required=False, allow_blank=True, allow_null=True)
    
    class Meta:
        model = Group
        exclude = ('leader', 'period', 'has_img')


class GroupDetailSerializer(serializers.ModelSerializer):
    class Meta:
        model = Group
        exclude = ('id', 'leader', 'period', 'is_public', 'users')


class GroupUpdateSerializer(serializers.ModelSerializer):
    groupname = serializers.CharField(required=False)
    description = serializers.CharField(required=False, allow_blank=True, allow_null=True)
    rule = serializers.CharField(required=False, allow_blank=True, allow_null=True)
    headcount = serializers.IntegerField(required=False)

    class Meta:
        model = Group
        fields = ('groupname', 'description', 'rule', 'headcount')


class BoardCreateSerializer(serializers.ModelSerializer):
    class Meta:
        model = Board
        exclude = ('group', 'user')


class BoardItemCreateSerializer(serializers.ModelSerializer):
    content = serializers.CharField(required=False, allow_blank=True, allow_null=True)

    class Meta:
        model = BoardItem
        fields = ('item_id', 'title', 'content', 'check', 'check_goal')

    def validate_check_goal(self, value):
        if self.instance.check and value < 2:
            raise ValidationError("목표 횟수는 2 이상으로 지정해야 합니다.")
        return value


class BoardItemDetailSerializer(serializers.ModelSerializer):
    class Meta:
        model = BoardItem
        exclude = ('board', 'id')


class BoardDetailSerializer(serializers.ModelSerializer):
    items = BoardItemDetailSerializer(many=True, read_only=True)
    
    class Meta:
        model = Board
        exclude = ('id', )