from rest_framework import serializers

from .models import Board, BoardItem


class BoardCreateSerializer(serializers.ModelSerializer):
    class Meta:
        model = Board
        exclude = ('group', 'user')


class BoardItemCreateSerializer(serializers.ModelSerializer):
    class Meta:
        model = BoardItem
        exclude = ('board',)


class BoardDetailSerializer(serializers.ModelSerializer):
    class Meta:
        model = Board
        exclude = ('group',)

class BoardUpdateSerializer(serializers.ModelSerializer):
    boardname = serializers.CharField(required=False)
    description = serializers.CharField(required=False, allow_blank=True)
    rule = serializers.CharField(required=False, allow_blank=True)
    headcount = serializers.IntegerField(required=False)

    class Meta:
        model = Board
        fields = ('Boardname', 'description', 'rule', 'headcount')