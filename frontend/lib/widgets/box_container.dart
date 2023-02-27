import 'package:bin_got/utilities/style_utils.dart';
import 'package:bin_got/utilities/type_def_utils.dart';
import 'package:bin_got/widgets/text.dart';
import 'package:flutter/material.dart';

//* 그룹 메인 내용 출력
class ShowContentBox extends StatelessWidget {
  final String contentTitle, content;
  const ShowContentBox(
      {super.key, required this.contentTitle, required this.content});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(content: contentTitle, fontSize: FontSize.textSize),
          const SizedBox(height: 20),
          Container(
            width: 300,
            height: 100,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: greyColor)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              child: CustomText(content: content, fontSize: FontSize.textSize),
            ),
          )
        ],
      ),
    );
  }
}

//* 갤러리형 빙고 목록
class BingoGallery extends StatelessWidget {
  final WidgetList bingoList;
  const BingoGallery({super.key, required this.bingoList});

  @override
  Widget build(BuildContext context) {
    int bingoRows = bingoList.length ~/ 2 + bingoList.length % 2;
    return Column(
      children: [
        for (int i = 0; i < bingoRows; i += 1)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [for (int j = 0; j < 2; j += 1) bingoList[2 * i + j]],
          )
      ],
    );
  }
}
