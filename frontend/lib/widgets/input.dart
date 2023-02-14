import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputText extends StatelessWidget {
  final String explain;
  const InputText({super.key, required this.explain});

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
    return TextField(
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        hintText: explain,
      ),
      style: const TextStyle(fontSize: 20),
      keyboardType: TextInputType.datetime,
    );
  }
}
