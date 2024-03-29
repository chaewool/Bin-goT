import 'dart:io';

import 'package:bin_got/utilities/type_def_utils.dart';

//? 빙고 생성, 수정
// 빙고 생성, 수정 시  정보
class BingoFormModel {
  final int background, lineStyle, font, userId, groupId;
  final String colorText, colorLine;
  final List items;
  final File thumbnail;

  BingoFormModel.fromJson(Map<dynamic, dynamic> json)
      : background = json['background'],
        colorText = json['color_text'],
        colorLine = json['color_line'],
        lineStyle = json['line_style'],
        font = json['font'],
        items = json['items'],
        thumbnail = json['thumbnail'],
        userId = json['userId'],
        groupId = json['groupId'];
}

class BingoItemModel {
  final int itemId, targetCnt, presentCnt;
  final String title, content;
  final bool completed, needCheck;
  BingoItemModel.fromJson(Map<dynamic, dynamic> json)
      : itemId = json['item_id'],
        title = json['title'],
        content = json['content'],
        completed = json['finished'],
        needCheck = json['check'],
        presentCnt = json['check_cnt'],
        targetCnt = json['check_goal'];
}

class BingoDetailModel {
  final int groupId, background, gap, completeIcon, font, authorId;
  final String title;
  final bool hasBlackBox, hasBoarder, hasRoundEdge;
  final double achieve;
  final BingoItemList items;

  BingoDetailModel.fromJson(Map<dynamic, dynamic> json)
      : groupId = json['group'],
        authorId = json['user'],
        achieve = json['achieve'],
        title = json['title'],
        hasBlackBox = json['is_black'],
        background = json['background'],
        hasRoundEdge = json['has_round_edge'],
        hasBoarder = json['has_boarder'],
        gap = json['around_kan'],
        completeIcon = json['complete_icon'],
        font = json['font'],
        items = json['items'];
}
