import 'package:bin_got/utilities/style_utils.dart';
import 'package:bin_got/utilities/type_def_utils.dart';
import 'package:flutter/material.dart';

class CustomBadge extends StatelessWidget {
  final ReturnVoid? onTap;
  final List<BoxShadow>? boxShadow;
  final double radius;
  const CustomBadge({super.key, this.onTap, this.boxShadow, this.radius = 30});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: greyColor,
          boxShadow: boxShadow,
        ),
        width: radius * 2,
        height: radius * 2,
      ),
    );
  }
}
