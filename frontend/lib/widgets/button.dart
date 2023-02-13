import 'package:bin_got/utilities/type_def.dart';
import 'package:flutter/material.dart';

// class Button extends StatelessWidget {
//   final String text;
//   final Color bgColor, textColor;
//   final int size;
//   const Button({
//     super.key,
//     required this.text,
//     required this.bgColor,
//     required this.textColor,
//     required this.size,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }

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
