import 'package:bin_got/utilities/global_func.dart';
import 'package:bin_got/widgets/modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomInput extends StatelessWidget {
  final String? explain;
  final bool needMore, onlyNum, enabled;
  final double? width, height;

  const CustomInput({
    super.key,
    this.explain,
    this.needMore = false,
    this.onlyNum = false,
    this.enabled = true,
    this.width,
    this.height,
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
            border: const OutlineInputBorder(),
            hintText: explain,
          ),
          style: const TextStyle(fontSize: 20),
          maxLines: needMore ? 7 : 1,
          keyboardType: onlyNum ? TextInputType.number : null,
          inputFormatters:
              onlyNum ? [FilteringTextInputFormatter.digitsOnly] : null,
          enabled: enabled,
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
