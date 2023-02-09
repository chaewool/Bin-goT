class BingoDetailModel {
  final String background;
  final int colorText, colorLine, lineStyle, font, achieve;
  final bool isMine;
  final List items;
  // stickers;

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
