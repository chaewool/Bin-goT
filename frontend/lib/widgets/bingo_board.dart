import 'package:bin_got/utilities/global_func.dart';
import 'package:bin_got/utilities/style_utils.dart';
import 'package:bin_got/widgets/box_container.dart';
import 'package:bin_got/widgets/modal.dart';
import 'package:bin_got/widgets/text.dart';
import 'package:flutter/material.dart';

class BingoBoard extends StatelessWidget {
  final int bingoSize;
  const BingoBoard({super.key, required this.bingoSize});

  @override
  Widget build(BuildContext context) {
    return CustomBoxContainer(
      hasRoundEdge: false,
      color: blackColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          for (int i = 0; i < bingoSize; i += 1)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                for (int j = 0; j < bingoSize; j += 1)
                  EachBingo(
                      index: bingoSize * i + j, cnt: bingoSize * bingoSize),
              ],
            ),
        ],
      ),
    );
  }
}

class EachBingo extends StatelessWidget {
  final int index, cnt;
  const EachBingo({
    super.key,
    required this.index,
    required this.cnt,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed:
          showModal(context: context, page: BingoModal(index: index, cnt: cnt)),
      child: const CustomBoxContainer(
        color: greyColor,
        hasRoundEdge: false,
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 26,
            horizontal: 26,
          ),
          child: CustomText(
            content: '빙고칸',
            fontSize: FontSize.textSize,
          ),
        ),
      ),
    );
  }
}
