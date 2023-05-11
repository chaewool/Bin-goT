import 'dart:math';

import 'package:bin_got/utilities/global_func.dart';
import 'package:bin_got/utilities/style_utils.dart';
import 'package:bin_got/widgets/container.dart';
import 'package:bin_got/widgets/icon.dart';
import 'package:bin_got/widgets/modal.dart';
import 'package:bin_got/widgets/text.dart';
import 'package:flutter/material.dart';

//* 빙고판
class BingoBoard extends StatefulWidget {
  final bool isDetail;
  const BingoBoard({
    super.key,
    required this.isDetail,
  });

  @override
  State<BingoBoard> createState() => _BingoBoardState();
}

class _BingoBoardState extends State<BingoBoard> {
  late final int? size;
  @override
  void initState() {
    super.initState();
    setState(() {
      size = getBingoSize(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    double applyGap() {
      switch (getGap(context)) {
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
          child: getBackground(context) != null
              ? const CustomBoxContainer(
                  hasRoundEdge: false,
                  image: DecorationImage(
                    image: AssetImage('assets/images/aaron-burden.jpg'),
                    fit: BoxFit.fill,
                  ),
                )
              : const SizedBox(),
        ),
        Column(
          children: [
            for (int i = 0; i < size!; i += 1)
              Flexible(
                child: Row(
                  children: [
                    for (int j = 0; j < size!; j += 1)
                      Flexible(
                        child: Padding(
                          padding: EdgeInsets.all(applyGap()),
                          child: EachBingo(
                            size: size!,
                            isDetail: widget.isDetail,
                            index: size! * i + j,
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
  final bool isDetail;
  final int index;
  final int size;

  const EachBingo({
    super.key,
    required this.size,
    required this.index,
    required this.isDetail,
  });

  @override
  Widget build(BuildContext context) {
    Color convertedColor() => getHasBlackBox(context) ? whiteColor : blackColor;
    String modifiedTitle() {
      final bingoTitle = getTitle(context);
      if (bingoTitle == null) return '빙고칸 제목';
      final int length = bingoTitle.length;
      if (length < 4) {
        return bingoTitle;
      }
      final end = min(6, length);
      var result =
          '${bingoTitle.substring(0, 3)}\n${bingoTitle.substring(3, end)}';
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
        ),
      ),
      child: CustomBoxContainer(
        color: getHasBlackBox(context) ? blackColor : whiteColor,
        hasRoundEdge: getHasRoundEdge(context),
        borderColor: getHasBorder(context) == true ? convertedColor() : null,
        child: Stack(
          children: [
            Center(
              child: CustomText(
                color: convertedColor(),
                content: modifiedTitle(),
                font: getStringFont(context),
                center: true,
              ),
            ),
            Center(
              child: CustomIcon(
                icon: getCheckIconData(context),
                size: 80,
                color: convertedColor(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
