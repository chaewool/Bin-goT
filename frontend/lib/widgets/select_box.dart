import 'package:bin_got/utilities/image_icon_utils.dart';
import 'package:bin_got/utilities/style_utils.dart';
import 'package:bin_got/utilities/type_def_utils.dart';
import 'package:bin_got/widgets/box_container.dart';
import 'package:bin_got/widgets/icon.dart';
import 'package:bin_got/widgets/text.dart';
import 'package:flutter/material.dart';

// const List<String> period = <String>[
//   '기간을 선택해주세요',
//   '하루 ~ 한 달',
//   '한 달 ~ 세 달',
//   '세 달 ~ 여섯 달',
//   '여섯 달 ~ 아홉 달',
//   '아홉 달 ~ 1년'
// ];
const StringList sort = <String>['모집 중', '전체'];

const StringList publicFilter = <String>['공개', '비공개', '전체'];

class SelectBox extends StatelessWidget {
  final double width, height;
  final ReturnVoid onTap;
  final String value;

  const SelectBox({
    super.key,
    required this.width,
    required this.height,
    required this.onTap,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return CustomBoxContainer(
      onTap: onTap,
      width: width,
      height: height,
      color: whiteColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(
              content: value,
              fontSize: FontSize.smallSize,
            ),
            const CustomIcon(icon: downIcon)
          ],
        ),
      ),
    );
  }
}
