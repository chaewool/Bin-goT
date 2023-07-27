from rest_framework import serializers

from .models import Group


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
        exclude = ('id', 'leader', 'password', 'period', 'is_public', 'users', 'count', 'password')


class GroupUpdateSerializer(serializers.ModelSerializer):
    password = serializers.CharField(required=False, allow_blank=True)
    description = serializers.CharField(required=False, allow_blank=True)
    rule = serializers.CharField(required=False, allow_blank=True)
    headcount = serializers.IntegerField(required=False)

    class Meta:
        model = Group
        fields = ('groupname', 'description', 'rule', 'headcount')