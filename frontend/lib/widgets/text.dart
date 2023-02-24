import 'package:bin_got/utilities/style_utils.dart';
import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String content;
  final FontSize fontSize;
  final bool center;
  const CustomText(
      {super.key,
      required this.content,
      required this.fontSize,
      this.center = false});

  @override
  Widget build(BuildContext context) {
    return Text(
      content,
      style:
          TextStyle(fontSize: convertedFontSize(fontSize), color: blackColor),
      textAlign: center ? TextAlign.center : null,
    );
  }
}
