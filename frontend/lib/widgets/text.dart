import 'package:bin_got/utilities/style_utils.dart';
import 'package:flutter/material.dart';

//* text 기본 틀
class CustomText extends StatelessWidget {
  final String content;
  final FontSize fontSize;
  final bool center;
  final String font;
  final Color color;
  const CustomText({
    super.key,
    required this.content,
    this.fontSize = FontSize.textSize,
    this.center = false,
    this.font = 'RIDIBatang',
    this.color = blackColor,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      content,
      style: TextStyle(
        fontSize: convertedFontSize(fontSize),
        color: color,
        fontFamily: font,
      ),
      textAlign: center ? TextAlign.center : null,
    );
  }
}
