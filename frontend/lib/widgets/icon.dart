import 'package:bin_got/utilities/style_utils.dart';
import 'package:bin_got/utilities/type_def_utils.dart';
import 'package:bin_got/widgets/button.dart';
import 'package:flutter/material.dart';

class CustomIcon extends StatelessWidget {
  final Color color;
  final double size;
  final IconData icon;
  const CustomIcon(
      {super.key, this.color = blackColor, this.size = 30, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Icon(icon, color: color, size: size);
  }
}

class IconInRow extends StatelessWidget {
  final IconData icon;
  final ReturnVoid onPressed;
  final Color color;
  const IconInRow(
      {super.key,
      required this.icon,
      required this.onPressed,
      this.color = blackColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: CustomIconButton(icon: icon, onPressed: onPressed, color: color),
    );
  }
}
