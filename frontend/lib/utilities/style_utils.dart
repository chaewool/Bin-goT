import 'package:flutter/material.dart';

//* 색
const backgroundColor = Color(0xFFF4FCF9);
const blackColor = Colors.black;

//* 글씨체
const double titleSize = 24;
const double largeSize = 21;
const double textSize = 19;

enum FontSize { titleSize, largeSize, textSize }

double convertedFontSize(FontSize size) {
  switch (size) {
    case FontSize.textSize:
      return textSize;
    case FontSize.titleSize:
      return titleSize;
    default:
      return largeSize;
  }
}
