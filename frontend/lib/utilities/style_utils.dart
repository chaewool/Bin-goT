import 'package:flutter/material.dart';

//* 색
const backgroundColor = Color(0xFFF4FCF9);
const blackColor = Colors.black;
const whiteColor = Colors.white;
const greyColor = Colors.grey;
const redColor = Colors.red;
const greenColor = Colors.green;
const blueColor = Colors.blue;

//* 글씨체
const double titleSize = 24;
const double largeSize = 21;
const double textSize = 19;
const double smallSize = 16;

enum FontSize { titleSize, largeSize, textSize, smallSize }

double convertedFontSize(FontSize size) {
  switch (size) {
    case FontSize.textSize:
      return textSize;
    case FontSize.titleSize:
      return titleSize;
    case FontSize.smallSize:
      return smallSize;
    default:
      return largeSize;
  }
}
