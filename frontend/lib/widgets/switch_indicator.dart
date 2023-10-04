import 'package:bin_got/utilities/style_utils.dart';
import 'package:flutter/material.dart';

//* 스피너, 스위치, 선

//* indicator
class CustomCirCularIndicator extends StatelessWidget {
  const CustomCirCularIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        color: darkGreyColor,
      ),
    );
  }
}

//* switch
class CustomSwitch extends StatelessWidget {
  final bool value;
  final void Function(bool) onChanged;
  const CustomSwitch({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: value,
      onChanged: onChanged,
      activeColor: palePinkColor,
    );
  }
}

//* divider
class CustomDivider extends StatelessWidget {
  final double vertical, thickness;
  const CustomDivider({
    super.key,
    this.vertical = 10,
    this.thickness = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: vertical),
      child: Divider(
        thickness: thickness,
        color: greyColor.withOpacity(0.5),
      ),
    );
  }
}
