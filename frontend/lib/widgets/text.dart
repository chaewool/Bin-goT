import 'package:bin_got/utilities/style_utils.dart';
import 'package:flutter/material.dart';
import 'package:wrapped_korean_text/wrapped_korean_text.dart';

//? 텍스트

//* text 기본 틀
class CustomText extends StatelessWidget {
  final String content;
  final FontSize fontSize;
  final bool center, cutText, bold;
  final String font;
  final Color color;
  final double? height;
  final int? maxLines;
  const CustomText({
    super.key,
    required this.content,
    this.fontSize = FontSize.textSize,
    this.center = false,
    this.font = 'RIDIBatang',
    this.color = blackColor,
    this.height,
    this.maxLines,
    this.cutText = false,
    this.bold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      content,
      style: TextStyle(
        fontSize: convertedFontSize(fontSize),
        color: color,
        fontFamily: font,
        height: height,
        fontWeight: bold ? FontWeight.bold : null,
      ),
      textAlign: center ? TextAlign.center : null,
      maxLines: maxLines,
      overflow: cutText ? TextOverflow.ellipsis : null,
    );
  }
}

//* long text
class CustomLongText extends StatelessWidget {
  final String content;
  final bool hasContent;
  final Color? color;
  const CustomLongText({
    super.key,
    required this.content,
    required this.hasContent,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return WrappedKoreanText(
      content,
      style: TextStyle(
        color: hasContent ? color ?? blackColor : greyColor.withOpacity(0.7),
        height: 1.4,
      ),
    );
  }
}
