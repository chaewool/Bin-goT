import 'package:bin_got/utilities/style_utils.dart';
import 'package:flutter/material.dart';

//? 아이콘

class CustomIcon extends StatelessWidget {
  final Color color;
  final double size;
  final IconData icon;
  const CustomIcon({
    super.key,
    this.color = blackColor,
    this.size = 30,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      color: color,
      size: size,
    );
  }
}
