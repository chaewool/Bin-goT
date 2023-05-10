import 'dart:math';

import 'package:bin_got/providers/root_provider.dart';
import 'package:bin_got/utilities/global_func.dart';
import 'package:bin_got/utilities/image_icon_utils.dart';
import 'package:bin_got/utilities/style_utils.dart';
import 'package:bin_got/utilities/type_def_utils.dart';
import 'package:bin_got/widgets/box_container.dart';
import 'package:bin_got/widgets/icon.dart';
import 'package:bin_got/widgets/modal.dart';
import 'package:bin_got/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//* 빙고판
class BingoBoard extends StatefulWidget {
  final DynamicMap data;
  final int size;
  final bool isDetail;
  final Function(int tabIdx, int i)? changeData;
  // final bool isDetail, hasRoundEdge, hasBorder;
  // final int bingoSize, gap, checkIcon;
  // final int font;
  // final String? background;
  // final Color eachColor;
  const BingoBoard({
    super.key,
    required this.data,
    required this.size,
    required this.isDetail,
    this.changeData,
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
  late final int font, gap, checkIcon;
  late final bool hasBorder, isBlack, hasRoundEdge;
  late final int? background;
  @override
  void initState() {
    super.initState();
    gap = widget.data['around_kan'];
    // size = widget.data['bingoSize'];
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
            for (int i = 0; i < widget.size; i += 1)
              Flexible(
                child: Row(
                  children: [
                    for (int j = 0; j < widget.size; j += 1)
                      Flexible(
                        child: Padding(
                          padding: EdgeInsets.all(applyGap()),
                          child: EachBingo(
                            data: widget.data,
                            isDetail: widget.isDetail,
                            index: widget.size * i + j,
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
  final Map<String, dynamic> data;
  final bool isDetail;
  final int index;

  const EachBingo({
    super.key,
    required this.data,
    required this.index,
    required this.isDetail,
  });

  @override
  Widget build(BuildContext context) {
    final isBlack = data['is_black'];
    final title = data['title'] ?? '간단한 목표';
    final authorId = data['author_id'];
    final groupId = data['group_id'];
    final hasRoundEdge = data['has_round_edge'];
    final hasBorder = data['has_border'];
    final completeIcon = data['complete_icon'];
    final font = data['font'];
    final items = data['items'];
    final size = context.read<GlobalGroupProvider>().bingoSize!;

    Color convertedColor() => isBlack ? whiteColor : blackColor;
    String modifiedTitle() {
      final int length = title.length;
      if (length < 4) {
        return title;
      }
      final end = min(6, length);
      var result = '${title.substring(0, 3)}\n${title.substring(3, end)}';
      if (length >= 6) {
        result += '...';
      }
      return result;
    }

    return CustomBoxContainer(
      onLongPress: () {},
      onTap: showModal(
        context,
        page: BingoModal(
          index: index,
          cnt: size * size,
          isDetail: isDetail,
          items: items,
        ),
      ),
      child: CustomBoxContainer(
        color: isBlack ? blackColor : whiteColor,
        hasRoundEdge: hasRoundEdge,
        borderColor: hasBorder == true ? convertedColor() : null,
        child: Stack(
          children: [
            Center(
              child: CustomText(
                color: convertedColor(),
                content: modifiedTitle(),
                font: matchFont[font],
              ),
            ),
            Center(
              child: CustomIcon(
                icon: iconList[completeIcon],
                size: 80,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
