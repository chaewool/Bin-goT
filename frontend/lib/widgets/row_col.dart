import 'package:bin_got/utilities/type_def_utils.dart';
import 'package:flutter/material.dart';

//? row, col 응용

//* padding + col
class ColWithPadding extends StatelessWidget {
  final double vertical, horizontal;
  final WidgetList children;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisSize mainAxisSize;
  const ColWithPadding({
    super.key,
    this.vertical = 0,
    this.horizontal = 0,
    required this.children,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.max,
    this.crossAxisAlignment = CrossAxisAlignment.center,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: vertical, horizontal: horizontal),
      child: Column(
        mainAxisSize: mainAxisSize,
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
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
  final CrossAxisAlignment crossAxisAlignment;
  final bool min;
  const RowWithPadding({
    super.key,
    this.vertical = 0,
    this.horizontal = 0,
    required this.children,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.min = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: vertical, horizontal: horizontal),
      child: Row(
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        textBaseline: TextBaseline.ideographic,
        mainAxisSize: min ? MainAxisSize.min : MainAxisSize.max,
        children: children,
      ),
    );
  }
}
