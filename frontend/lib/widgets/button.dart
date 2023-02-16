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
