import 'dart:math';

import 'package:bin_got/utilities/global_func.dart';
import 'package:bin_got/utilities/image_icon_utils.dart';
import 'package:bin_got/utilities/style_utils.dart';
import 'package:bin_got/utilities/type_def_utils.dart';
import 'package:bin_got/widgets/box_container.dart';
import 'package:bin_got/widgets/icon.dart';
import 'package:bin_got/widgets/modal.dart';
import 'package:bin_got/widgets/text.dart';
import 'package:flutter/material.dart';

//* 빙고판
class BingoBoard extends StatefulWidget {
  final DynamicMap data;
  // final bool isDetail, hasRoundEdge, hasBorder;
  // final int bingoSize, gap, checkIcon;
  // final int font;
  // final String? background;
  // final Color eachColor;
  const BingoBoard({
    super.key,
    required this.data,
    // this.background,
    // required this.bingoSize,
    // required this.font,
    // required this.gap,
    // required this.isDetail,
    // required this.eachColor,
    // required this.checkIcon,
    // required this.hasRoundEdge,
    // required this.hasBorder,
  });

  @override
  State<BingoBoard> createState() => _BingoBoardState();
}

class _BingoBoardState extends State<BingoBoard> {
  late final int size, font, gap, checkIcon;
  late final bool hasBorder, isBlack, hasRoundEdge;
  late final int? background;
  @override
  void initState() {
    super.initState();
    gap = widget.data['around_kan'];
    size = widget.data['bingoSize'];
    font = widget.data['font'];
    hasBorder = widget.data['has_border'];
    isBlack = widget.data['is_black'];
    hasRoundEdge = widget.data['has_round_edge'];
    checkIcon = widget.data['complete_icon'];
    background = widget.data['background'];
  }

  @override
  Widget build(BuildContext context) {
    double applyGap() {
      switch (gap) {
        case 0:
          return 0;
        case 1:
          return 8;
        default:
          return 12;
      }
    }

    void longPressed() {}

    return Stack(
      children: [
        Flexible(
          flex: 3,
          fit: FlexFit.tight,
          child: background != null
              ? CustomBoxContainer(
                  hasRoundEdge: false,
                  image: DecorationImage(
                    image: AssetImage(backgroundList[background!]),
                    fit: BoxFit.fill,
                  ),
                )
              : const SizedBox(),
        ),
        Column(
          children: [
            for (int i = 0; i < size; i += 1)
              Flexible(
                child: Row(
                  children: [
                    for (int j = 0; j < size; j += 1)
                      Flexible(
                        child: Padding(
                          padding: EdgeInsets.all(applyGap()),
                          child: EachBingo(
                            hasRoundEdge: hasRoundEdge,
                            eachColor: isBlack ? blackColor : whiteColor,
                            hasBorder: hasBorder,
                            isDetail: false,
                            font: matchFont[font],
                            index: size * i + j,
                            cnt: size * size,
                            checkIcon: checkIcon,
                          ),
                        ),
                      )
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }
}

//* 빙고칸
class EachBingo extends StatelessWidget {
  final bool isDetail, hasRoundEdge, hasBorder;
  final int index, cnt, checkIcon;
  final String font, title;
  final Color eachColor;
  const EachBingo({
    super.key,
    this.title = '빙고칸이다dkdk',
    required this.index,
    required this.cnt,
    required this.font,
    required this.isDetail,
    required this.eachColor,
    required this.hasRoundEdge,
    required this.hasBorder,
    required this.checkIcon,
  });

  @override
  Widget build(BuildContext context) {
    Color convertedColor() => eachColor == blackColor ? whiteColor : blackColor;
    String modifiedTitle() {
      final length = title.length;
      if (length < 4) {
        return title;
      } else {
        final end = min(6, length);
        var result = '${title.substring(0, 3)}\n${title.substring(3, end)}';
        if (length >= 6) {
          result += '...';
        }
        return result;
      }
    }

    return CustomBoxContainer(
      onLongPress: () {},
      onTap: showModal(
        context,
        page: BingoModal(
          index: index,
          cnt: cnt,
          isDetail: isDetail,
        ),
      ),
      child: CustomBoxContainer(
        color: eachColor,
        hasRoundEdge: hasRoundEdge,
        borderColor: hasBorder ? convertedColor() : null,
        child: Stack(
          children: [
            Center(
              child: CustomText(
                color: convertedColor(),
                content: modifiedTitle(),
                font: font,
              ),
            ),
            Center(
              child: CustomIcon(
                icon: iconList[checkIcon],
                size: 80,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
