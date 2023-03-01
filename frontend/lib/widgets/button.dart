import 'package:bin_got/utilities/global_func.dart';
import 'package:bin_got/utilities/image_icon_utils.dart';
import 'package:bin_got/utilities/style_utils.dart';
import 'package:bin_got/utilities/type_def_utils.dart';
import 'package:bin_got/widgets/icon.dart';
import 'package:bin_got/widgets/text.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final ReturnVoid onPressed;
  final String content;
  final FontSize fontSize;
  const CustomButton(
      {super.key,
      required this.onPressed,
      required this.content,
      this.fontSize = FontSize.textSize});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      child: CustomText(
        content: content,
        fontSize: fontSize,
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
            onPressed: toBack(context: context), icon: CustomIcon(icon: icon))
        : OutlinedButton(
            onPressed: toBack(context: context), child: Text(buttonText));
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

class IconButtonInRow extends StatelessWidget {
  final IconData icon;
  final ReturnVoid onPressed;
  final Color color;
  final double size;
  const IconButtonInRow({
    super.key,
    required this.icon,
    required this.onPressed,
    this.color = blackColor,
    this.size = 30,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: CustomIconButton(
        icon: icon,
        onPressed: onPressed,
        color: color,
        size: size,
      ),
    );
  }
}

class CustomTextButton extends StatelessWidget {
  final String content;
  final FontSize fontSize;
  final ReturnVoid onTap;
  const CustomTextButton(
      {super.key,
      required this.content,
      required this.fontSize,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CustomText(
        content: content,
        fontSize: fontSize,
      ),
    );
  }
}
