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
