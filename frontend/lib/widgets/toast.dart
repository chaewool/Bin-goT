import 'package:bin_got/utilities/global_func.dart';
import 'package:bin_got/utilities/style_utils.dart';
import 'package:bin_got/widgets/container.dart';
import 'package:bin_got/widgets/text.dart';
import 'package:flutter/material.dart';

//? toast

//* toast
class CustomToast extends StatelessWidget {
  final String content;
  const CustomToast({
    super.key,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    double width = 300;
    double height = 80;
    return Positioned(
      top: getHeight(context) - 200,
      left: (getWidth(context) - width) / 2,
      child: CustomBoxContainer(
        height: height,
        width: width,
        color: const Color.fromRGBO(0, 0, 0, 0.8),
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
