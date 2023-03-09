import 'package:bin_got/utilities/global_func.dart';
import 'package:bin_got/utilities/style_utils.dart';
import 'package:bin_got/widgets/box_container.dart';
import 'package:bin_got/widgets/modal.dart';
import 'package:bin_got/widgets/text.dart';
import 'package:flutter/material.dart';

//* 빙고판
class BingoBoard extends StatelessWidget {
  final bool isDetail, hasRoundEdge, hasBorder;
  final int bingoSize, gap;
  final String font;
  final String? background;
  final Color eachColor;
  const BingoBoard({
    super.key,
    this.background,
    required this.bingoSize,
    required this.font,
    required this.gap,
    required this.isDetail,
    required this.eachColor,
    this.hasRoundEdge = false,
    this.hasBorder = false,
  });

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

    return Stack(
      children: [
        Flexible(
          flex: 3,
          fit: FlexFit.tight,
          child: background != null
              ? CustomBoxContainer(
                  hasRoundEdge: false,
                  image: DecorationImage(
                    image: AssetImage(
                      background!,
                    ),
                    fit: BoxFit.fill,
                  ),
                )
              : const SizedBox(),
        ),
        Column(
          children: [
            for (int i = 0; i < bingoSize; i += 1)
              Flexible(
                flex: 1,
                child: Row(
                  children: [
                    for (int j = 0; j < bingoSize; j += 1)
                      Flexible(
                        flex: 1,
                        child: Padding(
                          padding: EdgeInsets.all(applyGap()),
                          child: EachBingo(
                            hasRoundEdge: hasRoundEdge,
                            eachColor: eachColor,
                            isDetail: isDetail,
                            index: bingoSize * i + j,
                            cnt: bingoSize * bingoSize,
                            hasBorder: hasBorder,
                            font: font,
                          ),
                        ),
                      ),
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
  final int index, cnt;
  final String font;
  final Color eachColor;
  const EachBingo({
    super.key,
    required this.index,
    required this.cnt,
    required this.font,
    required this.isDetail,
    required this.eachColor,
    required this.hasRoundEdge,
    required this.hasBorder,
  });

  @override
  Widget build(BuildContext context) {
    Color convertedColor() => eachColor == blackColor ? whiteColor : blackColor;
    return CustomBoxContainer(
      onTap: showModal(
        context: context,
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
        child: Center(
          child: CustomText(
            color: convertedColor(),
            content: '빙고칸',
            font: font,
          ),
        ),
      ),
    );
  }
}
