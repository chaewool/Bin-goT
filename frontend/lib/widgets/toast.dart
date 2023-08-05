import 'package:bin_got/utilities/style_utils.dart';
import 'package:bin_got/widgets/container.dart';
import 'package:bin_got/widgets/text.dart';
import 'package:flutter/material.dart';

class CustomToast extends StatelessWidget {
  final double height, width;
  final Color color;
  final String content;
  const CustomToast({
    super.key,
    this.height = 80,
    this.width = 300,
    this.color = const Color.fromRGBO(0, 0, 0, 0.8),
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomBoxContainer(
        height: height,
        width: width,
        color: color,
        child: Center(
          child: CustomText(
            content: content,
            height: 1.5,
            center: true,
            color: whiteColor,
          ),
        ),
      ),
    );
  }
}
