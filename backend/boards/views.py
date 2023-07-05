from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from datetime import date
import json
import logging

from commons import upload_image
from .models import Board
from groups.models import Participate
from .serializers import BoardCreateSerializer, BoardItemCreateSerializer, BoardDetailSerializer


logger = logging.getLogger('accounts')
    

class BoardDetailView(APIView):
    def get(self, request, board_id):
        board = Board.objects.get(id=board_id)
        serializer = BoardDetailSerializer(board)
        group = board.group
        participate = Participate.objects.get(group=group, user=board.user)

        if not Participate.objects.filter(user=request.user, group=group).exists():
            return Response(data={'message': '참여하지 않은 그룹입니다.'}, status=status.HTTP_400_BAD_REQUEST)
        
        achieve = 0
        
        for item in serializer.data['items']:
            if item['finished']:
                achieve += 1
        
        data = {**serializer.data, 'username': participate.rand_name if group.is_public else participate.user.username, 'achieve': round(achieve / (board.group.size ** 2), 2), 'size': group.size}
        
        return Response(data=data, status=status.HTTP_200_OK)


class BoardUpdateView(APIView):
    def put(self, request, board_id):
        user = request.user
        board = Board.objects.get(id=board_id)
        group = board.group
        thumbnail = request.FILES.get('thumbnail')
        data = json.loads(request.data.get('data'))
        
        logger.info(f'썸네일 데이터: {thumbnail}')
        logger.info(f'json 데이터: {data}')
        
        if not Participate.objects.filter(user=user, group=group).exists():
            return Response(data={'message': '참여하지 않은 그룹입니다.'}, status=status.HTTP_400_BAD_REQUEST)
        
        if user != board.user:
            return Response(data={'message': '수정 권한이 없습니다.'}, status=status.HTTP_400_BAD_REQUEST)
    
        if date.today() >= group.start:
            return Response(data={'message': '시작일이 경과하여 수정할 수 없습니다.'}, status=status.HTTP_400_BAD_REQUEST)
        
        items = data['items']
        if len(items) < board.group.size ** 2:
            return Response(data={'message': '항목의 개수가 부족합니다.'}, status=status.HTTP_400_BAD_REQUEST)
        
        board_serializer = BoardCreateSerializer(instance=board, data=data)
        
        if board_serializer.is_valid(raise_exception=True):
            logger.info('보드 유효성 검사 통과')
        
            boarditem_serializers = []
            for i in range(len(items)):
                bs = BoardItemCreateSerializer(instance=board.items.all()[i], data=items[i])
                if bs.is_valid(raise_exception=True):
                    boarditem_serializers.append(bs)
                    
            logger.info('보드 아이템 유효성 검사 통과')
            
            board_serializer.save()
            for bs in boarditem_serializers:
                bs.save()
            
            logger.info('보드 아이템 갱신')
            
            url = 'boards' + '/' + str(board.id)
            upload_image(url, thumbnail)
            
            logger.info('보드 썸네일 갱신')
            
            return Response(status=status.HTTP_200_OK)