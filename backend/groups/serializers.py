from rest_framework import serializers

from .models import Group, Chat, Review


class GroupCreateSerializer(serializers.ModelSerializer):
    password = serializers.CharField(required=False, allow_blank=True)
    description = serializers.CharField(required=False, allow_blank=True)
    rule = serializers.CharField(required=False, allow_blank=True)
    
    class Meta:
        model = Group
        exclude = ('leader', 'period', 'has_img')


class GroupDetailSerializer(serializers.ModelSerializer):
    count = serializers.SerializerMethodField('get_count')
    
    def get_count(self, obj):
        return obj.users.count()

    class Meta:
        model = Group
        exclude = ('id', 'leader', 'password', 'period', 'is_public', 'users')


class GroupUpdateSerializer(serializers.ModelSerializer):
    password = serializers.CharField(required=False, allow_blank=True)
    description = serializers.CharField(required=False, allow_blank=True)
    rule = serializers.CharField(required=False, allow_blank=True)
    headcount = serializers.IntegerField(required=False)

    class Meta:
        model = Group
        fields = ('groupname', 'description', 'rule', 'headcount')


class GroupSearchSerializer(serializers.ModelSerializer):
    count = serializers.SerializerMethodField('get_count')
    
    def get_count(self, obj):
        return obj.users.count()

    class Meta:
        model = Group
        fields = ('id', 'groupname', 'is_public', 'start', 'end', 'headcount', 'count')


class ChatListSerializer(serializers.ModelSerializer):
    class Meta:
        model = Chat
        fields = '__all__'


class ReviewListSerializer(serializers.ModelSerializer):
    class Meta:
        model = Review
        fields = '__all__'