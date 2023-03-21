from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from datetime import date
import json

from commons import upload_image, delete_image
from .models import Board
from groups.models import Group, Participate
from .serializers import BoardCreateSerializer, BoardItemCreateSerializer, BoardDetailSerializer


class BoardCreateView(APIView):
    def post(self, request):
        user = request.user
        thumbnail = request.FILES.get('thumbnail')
        data = json.loads(request.data.get('data'))
        group = Group.objects.get(id=data['group_id'])
        
        if not Participate.objects.filter(user=user, group=group).exists():
            return Response(data={'message': '참여하지 않은 그룹입니다.'}, status=status.HTTP_400_BAD_REQUEST)
        
        if date.today() > group.start:
            return Response(data={'message': '시작일이 경과하여 생성할 수 없습니다.'}, status=status.HTTP_400_BAD_REQUEST)
        
        if Board.objects.filter(user=user, group=group).exists():
            return Response(data={'message': '이미 해당 그룹에서 빙고를 생성했습니다.'}, status=status.HTTP_400_BAD_REQUEST)
    
        items = data['items']
        if len(items) < group.size ** 2:
            return Response(data={'message': '항목의 개수가 부족합니다.'}, status=status.HTTP_400_BAD_REQUEST)
        
        board_serializer = BoardCreateSerializer(data=data)
        boarditem_serializer = BoardItemCreateSerializer(data=items, many=True)
        
        if board_serializer.is_valid(raise_exception=True) and boarditem_serializer.is_valid(raise_exception=True):
            board = board_serializer.save(user=user, group=group)
            
            url = 'boards' + '/' + str(board.id)
            upload_image(url, thumbnail)
            
            boarditem_serializer.save(board=board)
        
            return Response(data={'board_id': board.id}, status=status.HTTP_200_OK)
    

class BoardDetailView(APIView):
    def get(self, request, board_id):
        board = Board.objects.get(id=board_id)
        serializer = BoardDetailSerializer(board)
        
        achieve = 0
        
        for item in serializer.data['items']:
            if item['finished']:
                achieve += 1
        
        data = {**serializer.data, 'acheive':achieve / board.group.size}
        
        return Response(data=data, status=status.HTTP_200_OK)


class BoardUpdateView(APIView):
    def put(self, request, board_id):
        user = request.user
        board = Board.objects.get(id=board_id)
        group = board.group
        thumbnail = request.FILES.get('thumbnail')
        data = json.loads(request.data.get('data'))
        
        if not Participate.objects.filter(user=user, group=group).exists():
            return Response(data={'message': '참여하지 않은 그룹입니다.'}, status=status.HTTP_400_BAD_REQUEST)
        
        if user != board.user:
            return Response(data={'message': '수정 권한이 없습니다.'}, status=status.HTTP_400_BAD_REQUEST)
    
        if date.today() > group.start:
            return Response(data={'message': '시작일이 경과하여 수정할 수 없습니다.'}, status=status.HTTP_400_BAD_REQUEST)
        
        items = data['items']
        if len(items) < board.group.size ** 2:
            return Response(data={'message': '항목의 개수가 부족합니다.'}, status=status.HTTP_400_BAD_REQUEST)
        
        board_serializer = BoardCreateSerializer(instance=board, data=data)
        
        if board_serializer.is_valid(raise_exception=True):
            boarditem_serializers = []
            for i in range(len(items)):
                bs = BoardItemCreateSerializer(instance=board.items.all()[i], data=items[i])
                if bs.is_valid(raise_exception=True):
                    boarditem_serializers.append(bs)
            
            board_serializer.save()
            for bs in boarditem_serializers:
                bs.save()
            
            url = 'boards' + '/' + str(board.id)
            upload_image(url, thumbnail)
            
            return Response(status=status.HTTP_200_OK)


class BoardDeleteView(APIView):
    def delete(self, request, board_id):
        user = request.user
        board = Board.objects.get(id=board_id)
        
        if not Participate.objects.filter(user=user, group=board.group).exists():
            return Response(data={'message': '참여하지 않은 그룹입니다.'}, status=status.HTTP_400_BAD_REQUEST)
        
        if user != board.user:
            return Response(data={'message': '삭제 권한이 없습니다.'}, status=status.HTTP_400_BAD_REQUEST)
        
        if date.today() > board.group.start:
            return Response(data={'message': '시작일이 경과하여 삭제할 수 없습니다.'}, status=status.HTTP_400_BAD_REQUEST)
        
        url = 'boards' + '/' + str(board.id)
        delete_image(url)
        board.delete()
        
        return Response(status=status.HTTP_200_OK)