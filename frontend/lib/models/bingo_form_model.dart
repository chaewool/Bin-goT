// 빙고 생성, 수정
import 'dart:io';

class BingoFormModel {
  final String message;
  final int? bingoId;
  final bool success;

  BingoFormModel.fromJson(Map<dynamic, dynamic> json)
      : message = json['message'],
        bingoId = json['bingoId'],
        success = json['success'];
}

// 빙고 생성, 수정 시 보낼 정보
class BingoRequestModel {
  final int background, lineStyle, font, userId, groupId;
  final String colorText, colorLine;
  final bool isMine;
  final List items;
  final File thumbnail;
  // stickers;

  // 아래 부분 items의 원소
  // int itemId, content, checkGoal;
  // bool check,;

  BingoRequestModel.fromJson(Map<dynamic, dynamic> json)
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
