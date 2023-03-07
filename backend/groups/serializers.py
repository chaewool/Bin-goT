from rest_framework import serializers

from .models import Group


class GroupCreateSerializer(serializers.ModelSerializer):
    class Meta:
        model = Group
        exclude = ('leader', 'period', 'has_img')


class GroupDetailSerializer(serializers.ModelSerializer):
    class Meta:
        model = Group
        fields = '__all__'