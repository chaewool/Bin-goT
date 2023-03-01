import 'package:bin_got/pages/bingo_detail_page.dart';
import 'package:bin_got/utilities/global_func.dart';
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
          CustomBoxContainer(
            width: 300,
            height: 100,
            borderColor: greyColor,
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
    int bingoRows = bingoList.length ~/ 2;
    return Column(
      children: [
        for (int i = 0; i < bingoRows; i += 1)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              for (int j = 0; j < 2; j += 1)
                GestureDetector(
                  onTap: toOtherPage(
                    context: context,
                    page: const BingoDetail(),
                  ),
                  child: bingoList[2 * i + j],
                )
            ],
          ),
        bingoList.length % 2 == 1
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: toOtherPage(
                      context: context,
                      page: const BingoDetail(),
                    ),
                    child: bingoList.last,
                  )
                ],
              )
            : const SizedBox(),
      ],
    );
  }
}

//* Box Container 기본 틀
class CustomBoxContainer extends StatelessWidget {
  final bool hasRoundEdge;
  final Color? borderColor;
  final Color color;
  final BoxShadowList? boxShadow;
  final double? width, height;
  final Widget? child;
  final DecorationImage? image;
  const CustomBoxContainer({
    super.key,
    this.hasRoundEdge = true,
    this.borderColor,
    this.color = whiteColor,
    this.boxShadow,
    this.width,
    this.height,
    this.image,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: hasRoundEdge ? BorderRadius.circular(10) : null,
        color: color,
        boxShadow: boxShadow,
        border: borderColor != null ? Border.all(color: borderColor!) : null,
        image: image,
      ),
      child: child,
    );
  }
}
