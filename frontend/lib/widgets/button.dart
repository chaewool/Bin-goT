import 'package:bin_got/utilities/global_func.dart';
import 'package:bin_got/utilities/image_icon_utils.dart';
import 'package:bin_got/utilities/style_utils.dart';
import 'package:bin_got/utilities/type_def_utils.dart';
import 'package:bin_got/widgets/icon.dart';
import 'package:bin_got/widgets/text.dart';
import 'package:flutter/material.dart';

//* 기본 버튼
class CustomButton extends StatelessWidget {
  final ReturnVoid onPressed;
  final String content;
  final FontSize fontSize;
  final bool enabled;
  const CustomButton({
    super.key,
    required this.onPressed,
    required this.content,
    this.fontSize = FontSize.smallSize,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      child: CustomText(
        content: content,
        fontSize: fontSize,
        color: enabled ? blackColor : greyColor,
      ),
    );
  }
}

//* 닫기, 취소, 나가기 버튼
class ExitButton extends StatelessWidget {
  final bool isIconType;
  final IconData icon;
  final String buttonText;
  final ReturnVoid? onPressed;
  const ExitButton({
    super.key,
    required this.isIconType,
    this.onPressed,
    this.icon = backIcon,
    this.buttonText = '닫기',
  });

  @override
  Widget build(BuildContext context) {
    return isIconType
        ? IconButton(
            onPressed: onPressed ?? () => toBack(context),
            icon: CustomIcon(icon: icon),
          )
        : OutlinedButton(
            onPressed: onPressed ?? () => toBack(context),
            child: CustomText(
              content: buttonText,
              fontSize: FontSize.smallSize,
            ),
          );
  }
}

//* 아이콘 버튼
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
      iconSize: size,
    );
  }
}

//* 아이콘 버튼에 padding 추가
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

//* 텍스트 버튼
class CustomTextButton extends StatelessWidget {
  final String content;
  final FontSize fontSize;
  final ReturnVoid onTap;
  const CustomTextButton({
    super.key,
    required this.content,
    required this.onTap,
    this.fontSize = FontSize.textSize,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: CustomText(
          content: content,
          fontSize: fontSize,
        ),
      ),
    );
  }
}
