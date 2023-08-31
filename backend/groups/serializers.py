from rest_framework import serializers

from .models import Group, Board, BoardItem


class GroupCreateSerializer(serializers.ModelSerializer):
    password = serializers.CharField(required=False, allow_blank=True)
    description = serializers.CharField(required=False, allow_blank=True)
    rule = serializers.CharField(required=False, allow_blank=True)
    
    class Meta:
        model = Group
        exclude = ('leader', 'period', 'has_img')


class GroupDetailSerializer(serializers.ModelSerializer):
    class Meta:
        model = Group
        exclude = ('id', 'leader', 'period', 'is_public', 'users')


class GroupUpdateSerializer(serializers.ModelSerializer):
    groupname = serializers.CharField(required=False)
    description = serializers.CharField(required=False, allow_blank=True)
    rule = serializers.CharField(required=False, allow_blank=True)
    headcount = serializers.IntegerField(required=False)

    class Meta:
        model = Group
        fields = ('groupname', 'description', 'rule', 'headcount')


class BoardCreateSerializer(serializers.ModelSerializer):
    class Meta:
        model = Board
        exclude = ('group', 'user')


class BoardItemCreateSerializer(serializers.ModelSerializer):
    class Meta:
        model = BoardItem
        exclude = ('board', 'id', 'check_cnt', 'finished')


class BoardItemCreateSerializer(serializers.ModelSerializer):
    class Meta:
        model = BoardItem
        exclude = ('board', 'id', 'check_cnt', 'finished')


class BoardItemDetailSerializer(serializers.ModelSerializer):
    class Meta:
        model = BoardItem
        exclude = ('board', 'id')


class BoardDetailSerializer(serializers.ModelSerializer):
    items = BoardItemDetailSerializer(many=True, read_only=True)
    
    class Meta:
        model = Board
        exclude = ('id', )