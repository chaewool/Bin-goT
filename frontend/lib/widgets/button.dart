import 'package:bin_got/utilities/global_func.dart';
import 'package:bin_got/utilities/image_icon_utils.dart';
import 'package:bin_got/utilities/style_utils.dart';
import 'package:bin_got/utilities/type_def_utils.dart';
import 'package:bin_got/widgets/icon.dart';
import 'package:bin_got/widgets/text.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final ReturnVoid methodFunc;
  final String buttonText;
  final FontSize? fontSize;
  const CustomButton(
      {super.key,
      required this.methodFunc,
      required this.buttonText,
      this.fontSize});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: methodFunc,
      child: CustomText(
        content: buttonText,
        fontSize: fontSize ?? FontSize.textSize,
      ),
    );
  }
}

class ExitButton extends StatelessWidget {
  final bool isIconType;
  final IconData icon;
  final String buttonText;
  const ExitButton(
      {super.key,
      required this.isIconType,
      this.icon = backIcon,
      this.buttonText = '닫기'});

  @override
  Widget build(BuildContext context) {
    return isIconType
        ? IconButton(
            onPressed: () => toBack(context: context),
            icon: CustomIcon(icon: icon))
        : OutlinedButton(
            onPressed: () => toBack(context: context), child: Text(buttonText));
  }
}

class CustomIconButton extends StatelessWidget {
  final IconData icon;
  final ReturnVoid onPressed;
  final Color color;
  final double size;
  const CustomIconButton(
      {super.key,
      required this.onPressed,
      required this.icon,
      this.size = 30,
      this.color = blackColor});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: CustomIcon(
        icon: icon,
        color: color,
        size: size,
      ),
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
    );
  }
}
