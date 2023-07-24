import 'package:bin_got/utilities/type_def_utils.dart';
import 'package:flutter/material.dart';

//* padding + col
class ColWithPadding extends StatelessWidget {
  final double vertical, horizontal;
  final WidgetList children;
  final MainAxisAlignment mainAxisAlignment;
  final MainAxisSize mainAxisSize;
  const ColWithPadding({
    super.key,
    this.vertical = 0,
    this.horizontal = 0,
    required this.children,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.max,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: vertical, horizontal: horizontal),
      child: Column(
        mainAxisSize: mainAxisSize,
        mainAxisAlignment: mainAxisAlignment,
        children: children,
      ),
    );
  }
}

//* padding + row
class RowWithPadding extends StatelessWidget {
  final double vertical, horizontal;
  final WidgetList children;
  final MainAxisAlignment mainAxisAlignment;
  const RowWithPadding(
      {super.key,
      this.vertical = 0,
      this.horizontal = 0,
      required this.children,
      this.mainAxisAlignment = MainAxisAlignment.start});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: vertical, horizontal: horizontal),
      child: Row(
        mainAxisAlignment: mainAxisAlignment,
        children: children,
      ),
    );
  }
}
