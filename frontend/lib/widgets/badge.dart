import 'package:bin_got/utilities/style_utils.dart';
import 'package:bin_got/utilities/type_def_utils.dart';
import 'package:flutter/material.dart';

class CustomBadge extends StatefulWidget {
  final ReturnVoid? onTap;
  final List<BoxShadow>? boxShadow;
  const CustomBadge({super.key, this.onTap, this.boxShadow});

  @override
  State<CustomBadge> createState() => _CustomBadgeState();
}

class _CustomBadgeState extends State<CustomBadge> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: greyColor,
            boxShadow: widget.boxShadow),
        width: 60,
        height: 60,
      ),
    );
  }
}
