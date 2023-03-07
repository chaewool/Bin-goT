import 'package:bin_got/utilities/type_def_utils.dart';
import 'package:flutter/material.dart';

//* 색
const backgroundColor = Color(0xFFF4FCF9);
const blackColor = Colors.black;
const whiteColor = Colors.white;
const greyColor = Colors.grey;
const redColor = Colors.red;
const greenColor = Colors.green;
const blueColor = Colors.blue;
const paleRedColor = Color(0xFFFcF4F4);

//* 글씨 크기
const double titleSize = 24;
const double largeSize = 21;
const double textSize = 19;
const double smallSize = 16;
const double sloganSize = 40;

enum FontSize { titleSize, largeSize, textSize, smallSize, sloganSize }

double convertedFontSize(FontSize size) {
  switch (size) {
    case FontSize.textSize:
      return textSize;
    case FontSize.titleSize:
      return titleSize;
    case FontSize.smallSize:
      return smallSize;
    case FontSize.largeSize:
      return largeSize;
    default:
      return sloganSize;
  }
}

//* 글씨체
StringList showedFont = [
  '리디 바탕',
  '교보',
  '코레일',
  '코레일',
  // '코레일',
  '한국기계연구원',
  '땅스부대찌개'
];
StringList matchFont = [
  'RIDIBatang',
  'Kyobo',
  'Korail',
  'KorailRoundGothic',
  // 'KorailCondensed',
  'Kimm',
  'Ttangs'
];

//* 그림자
const defaultShadow = BoxShadow(
    color: greyColor, blurRadius: 3, spreadRadius: 0.3, offset: Offset(1, 2));
const thickerShadow = BoxShadow(
    color: greyColor, blurRadius: 3, spreadRadius: 1, offset: Offset(3, 3));
var shadowWithOpacity = BoxShadow(
    color: Colors.black.withOpacity(0.15),
    spreadRadius: 0,
    blurRadius: 4,
    offset: const Offset(0, 3));
const selectedShadow = BoxShadow(
  color: blueColor,
  blurRadius: 3,
  spreadRadius: 3,
);
