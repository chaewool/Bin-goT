from rest_framework.response import Response
from rest_framework import status
from datetime import date
import json

from boards.serializers import BoardCreateSerializer, BoardItemCreateSerializer
from boards.models import Board
from commons import RedisRanker, send_badge_notification, upload_image


def check_cnt_groups(user):
    if user.cnt_groups == 1:
        send_badge_notification(user, 2)
    elif user.cnt_groups == 3:
        send_badge_notification(user, 3)
    elif user.cnt_groups == 5:
        send_badge_notification(user, 4)


def check_cnt_boarditems_complete(user, group, board_item):
    board_item.finish = True
    board_item.save()
    
    ranker = RedisRanker(group.id)
    ranker.plusOne(user.id)
    
    user.cnt_boarditems_complete += 1
    user.save()
                
    if user.cnt_boarditems_complete == 1:
        send_badge_notification(user, 8)
    elif user.cnt_boarditems_complete == 10:
        send_badge_notification(user, 9)
    elif user.cnt_boarditems_complete == 100:
        send_badge_notification(user, 10)
    
    board = Board.objects.get(user=user, group=group)
    
    cnt = 0
    for item in board.items:
        if item.finished:
            cnt += 1
    
    if cnt == board.size ** 2:
        board.finished = True
        board.save()
        
        user.cnt_boards_complete += 1
        user.save()
              
        if user.cnt_boards_complete == 1:
            send_badge_notification(user, 11)
        elif user.cnt_boards_complete == 10:
            send_badge_notification(user, 12)
        elif user.cnt_boards_complete == 100:
            send_badge_notification(user, 13)


def check_cnt_boards(user):
    if user.cnt_boards == 1:
        send_badge_notification(user, 5)
    elif user.cnt_boards == 3:
        send_badge_notification(user, 6)
    elif user.cnt_boards == 5:
        send_badge_notification(user, 7)


def createBoard(request, group):
    user = request.user
    thumbnail = request.FILES.get('thumbnail')
    data = json.loads(request.data.get('board_data'))
    
    if date.today() >= group.start:
        return Response(data={'message': '시작일이 경과하여 가입할 수 없습니다.'}, status=status.HTTP_400_BAD_REQUEST)

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
        
        user.cnt_boards += 1
        user.save()
        
        check_cnt_boards(user)