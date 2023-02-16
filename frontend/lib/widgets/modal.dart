import 'package:bin_got/widgets/date_picker.dart';
import 'package:flutter/material.dart';

class BingoModal extends StatelessWidget {
  const BingoModal({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class DateModal extends StatelessWidget {
  const DateModal({super.key});

  @override
  Widget build(BuildContext context) {
    return const Dialog(child: DatePicker());
  }
}
