import 'package:bin_got/utilities/global_func.dart';
import 'package:bin_got/utilities/style_utils.dart';
import 'package:bin_got/widgets/box_container.dart';
import 'package:bin_got/widgets/image.dart';
import 'package:bin_got/widgets/modal.dart';
import 'package:bin_got/widgets/text.dart';
import 'package:flutter/material.dart';

class BingoBoard extends StatelessWidget {
  final int bingoSize;
  final String font;
  final String? background;
  const BingoBoard(
      {super.key,
      required this.bingoSize,
      required this.font,
      this.background});

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      CustomBoxContainer(
        hasRoundEdge: false,
        color: blackColor,
        child: background != null
            ? ModifiedImage(
                image: background!,
                width: 400,
                height: 270,
              )
            : const SizedBox(),
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          for (int i = 0; i < bingoSize; i += 1)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                for (int j = 0; j < bingoSize; j += 1)
                  EachBingo(
                    index: bingoSize * i + j,
                    cnt: bingoSize * bingoSize,
                    font: font,
                  ),
              ],
            ),
        ],
      ),
    ]);
  }
}

class EachBingo extends StatelessWidget {
  final int index, cnt;
  final String font;
  const EachBingo({
    super.key,
    required this.index,
    required this.cnt,
    required this.font,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed:
          showModal(context: context, page: BingoModal(index: index, cnt: cnt)),
      child: CustomBoxContainer(
        color: greyColor,
        width: 100,
        height: 70,
        hasRoundEdge: false,
        child: Center(
          child: CustomText(
            content: '빙고칸',
            fontSize: FontSize.textSize,
            font: font,
          ),
        ),
      ),
    );
  }
}
