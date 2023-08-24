import 'package:bin_got/utilities/style_utils.dart';
import 'package:flutter/material.dart';

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

class CustomDivider extends StatelessWidget {
  const CustomDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Divider(
        thickness: 1,
        color: greyColor.withOpacity(0.5),
      ),
    );
  }
}
