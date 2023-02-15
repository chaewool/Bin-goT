import 'package:bin_got/widgets/date_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputText extends StatelessWidget {
  final String explain;
  final bool needMore;
  const InputText({super.key, required this.explain, this.needMore = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: TextField(
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          hintText: explain,
        ),
        style: const TextStyle(fontSize: 20),
        maxLines: needMore ? 7 : 1,
      ),
    );
  }
}

class InputNumber extends StatelessWidget {
  final String explain;
  const InputNumber({super.key, required this.explain});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: TextField(
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          hintText: explain,
        ),
        style: const TextStyle(fontSize: 20),
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
        child: TextField(
          enabled: false,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            hintText: explain,
          ),
          style: const TextStyle(fontSize: 20),
          keyboardType: TextInputType.datetime,
        ),
        onTap: () => Navigator.push(context,
            MaterialPageRoute(builder: (context) => const DatePicker())));
  }
}
