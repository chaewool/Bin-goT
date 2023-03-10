import 'package:bin_got/utilities/global_func.dart';
import 'package:bin_got/utilities/style_utils.dart';
import 'package:bin_got/widgets/modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomInput extends StatelessWidget {
  final String? explain;
  final bool needMore, onlyNum, enabled;
  final double? width, height;
  final bool filled;
  final Color filledColor;
  final FontSize fontSize;
  final int? maxLength;

  const CustomInput({
    super.key,
    this.explain,
    this.needMore = false,
    this.onlyNum = false,
    this.enabled = true,
    this.width,
    this.height,
    this.filled = false,
    this.filledColor = whiteColor,
    this.fontSize = FontSize.smallSize,
    this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: SizedBox(
        width: width,
        height: height,
        child: TextField(
          decoration: InputDecoration(
            filled: filled,
            fillColor: filledColor,
            border: const OutlineInputBorder(),
            hintText: explain,
          ),
          maxLength: maxLength,
          style: TextStyle(fontSize: convertedFontSize(fontSize)),
          maxLines: needMore ? 7 : 1,
          keyboardType: onlyNum ? TextInputType.number : null,
          inputFormatters:
              onlyNum ? [FilteringTextInputFormatter.digitsOnly] : null,
          enabled: enabled,
          textAlign: TextAlign.start,
          textAlignVertical: TextAlignVertical.center,
        ),
      ),
    );
  }
}

class InputDate extends StatelessWidget {
  final String explain;
  const InputDate({super.key, required this.explain});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: showModal(context: context, page: const DateModal()),
      child: CustomInput(
        explain: explain,
        enabled: false,
      ),
    );
  }
}
