// 빙고 생성, 수정
import 'dart:io';

class MyBingoModel {
  final String groupName, bingoName, start, end;
  final int groupId, bingoId, status;

  MyBingoModel.fromJson(Map<dynamic, dynamic> json)
      : groupName = json['group_name'],
        bingoName = json['bingo_name'],
        start = json['start'],
        end = json['end'],
        groupId = json['group_id'],
        bingoId = json['bingo_id'],
        status = json['status'];
}

// 빙고 생성, 수정 시  정보
class BingoFormModel {
  final int background, lineStyle, font, userId, groupId;
  final String colorText, colorLine;
  final bool isMine;
  final List items;
  final File thumbnail;
  // stickers;

  // 아래 부분 items의 원소
  // int itemId, content, checkGoal;
  // bool check,;

  BingoFormModel.fromJson(Map<dynamic, dynamic> json)
      : background = json['background'],
        colorText = json['color_text'],
        colorLine = json['color_line'],
        // stickers = json['stickers'],
        lineStyle = json['line_style'],
        font = json['font'],
        isMine = json['is_mine'],
        items = json['items'],
        thumbnail = json['thumbnail'],
        userId = json['userId'],
        groupId = json['groupId'];
}

class BingoDetailModel {
  final int background, lineStyle, font, achieve;
  final String colorText, colorLine;
  final bool isMine;
  final List items;
  // stickers;

  // 아래 부분 items의 원소
  // int itemId, content, checkGoal, checkCnt;
  // bool check, finished;

  BingoDetailModel.fromJson(Map<dynamic, dynamic> json)
      : background = json['background'],
        colorText = json['color_text'],
        colorLine = json['color_line'],
        // stickers = json['stickers'],
        lineStyle = json['line_style'],
        font = json['font'],
        achieve = json['achieve'],
        isMine = json['is_mine'],
        items = json['items'];
}
