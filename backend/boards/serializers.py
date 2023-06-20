from rest_framework import serializers

from .models import Board, BoardItem


class BoardCreateSerializer(serializers.ModelSerializer):
    class Meta:
        model = Board
        exclude = ('group', 'user')


class BoardItemCreateSerializer(serializers.ModelSerializer):
    class Meta:
        model = BoardItem
        exclude = ('board', 'id')


class BoardDetailSerializer(serializers.ModelSerializer):
    items = BoardItemCreateSerializer(many=True, read_only=True)
    
    class Meta:
        model = Board
        exclude = ('id', )