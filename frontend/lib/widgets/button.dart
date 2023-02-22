import 'package:bin_got/pages/group_main_page.dart';
import 'package:bin_got/pages/main_page.dart';
import 'package:bin_got/utilities/image_icon_utils.dart';
import 'package:bin_got/utilities/style_utils.dart';
import 'package:bin_got/utilities/type_def_utils.dart';
import 'package:bin_got/widgets/icon.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final ReturnVoid methodFunc;
  final String buttonText;
  const CustomButton(
      {super.key, required this.methodFunc, required this.buttonText});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: methodFunc,
      child: Text(buttonText),
      // style: ButtonStyle(textStyle: MaterialStateProperty.),
    );
  }
}

class ToMainButton extends StatelessWidget {
  final String buttonText;
  const ToMainButton({super.key, required this.buttonText});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => const Main()));
        },
        child: Text(buttonText));
  }
}

class ToGroupMainButton extends StatelessWidget {
  final String buttonText;
  const ToGroupMainButton({super.key, required this.buttonText});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => GroupMain()));
        },
        child: Text(buttonText));
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
    void toBack() {
      Navigator.pop(context);
    }

    return isIconType
        ? IconButton(onPressed: toBack, icon: CustomIcon(icon: icon))
        : OutlinedButton(onPressed: toBack, child: Text(buttonText));
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
      icon: CustomIcon(icon: icon),
      color: color,
      iconSize: size,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
    );
  }
}
