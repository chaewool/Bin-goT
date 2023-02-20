import 'package:bin_got/pages/group_main_page.dart';
import 'package:bin_got/pages/main_page.dart';
import 'package:bin_got/utilities/type_def_utils.dart';
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
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const GroupMain()));
        },
        child: Text(buttonText));
  }
}

class ExitButton extends StatelessWidget {
  final String buttonText;
  const ExitButton({super.key, this.buttonText = '닫기'});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text(buttonText));
  }
}
