import 'package:bin_got/utilities/style_utils.dart';
import 'package:bin_got/widgets/text.dart';
import 'package:flutter/material.dart';

class CustomCheckBox extends StatefulWidget {
  final String label;
  final void Function(bool?) onChange;
  final bool value;
  const CustomCheckBox(
      {super.key,
      required this.label,
      required this.onChange,
      required this.value});

  @override
  State<CustomCheckBox> createState() => _CustomCheckBox();
}

class _CustomCheckBox extends State<CustomCheckBox> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Checkbox(
            checkColor: Colors.white,
            value: widget.value,
            onChanged: widget.onChange,
          ),
          CustomText(
            content: widget.label,
            fontSize: FontSize.smallSize,
          ),
        ],
      ),
    );
  }
}
