import 'package:bin_got/utilities/type_def_utils.dart';
import 'package:flutter/material.dart';

//* 색
const backgroundColor = Color(0xFFF4FCF9);
const blackColor = Colors.black;
const whiteColor = Colors.white;
const greyColor = Color(0xFF757070);
const redColor = Colors.red;
const greenColor = Colors.green;
const blueColor = Colors.blue;
// const paleRedColor = Color(0xFFFcF4F4);
const paleRedColor = Color(0xFFE59394);
const palePinkColor = Color(0xFFEFB9B3);
const darkGreyColor = Color(0xFF403B3E);
const beigeColor = Color(0xFFF4DBCC);
const paleOrangeColor = Color(0xFFDDA990);

//* 글씨 크기
const double sloganSize = 30;
const double titleSize = 21;
const double largeSize = 19;
const double textSize = 16;
const double smallSize = 14;
const double tinySize = 12;

enum FontSize {
  titleSize,
  largeSize,
  textSize,
  smallSize,
  sloganSize,
  tinySize,
}

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
    case FontSize.tinySize:
      return tinySize;
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

const StringList matchFont = [
  'RIDIBatang',
  'Kyobo',
  'Korail',
  'KorailRoundGothic',
  // 'KorailCondensed',
  'Kimm',
  'Ttangs'
];

//* 그림자
var defaultShadow = BoxShadow(
    color: Colors.black.withOpacity(0.15),
    blurRadius: 4,
    spreadRadius: 0,
    offset: const Offset(1, 2));
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
