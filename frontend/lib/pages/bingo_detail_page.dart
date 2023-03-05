import 'package:bin_got/pages/bingo_form_page.dart';
import 'package:bin_got/utilities/global_func.dart';
import 'package:bin_got/utilities/image_icon_utils.dart';
import 'package:bin_got/utilities/style_utils.dart';
import 'package:bin_got/widgets/app_bar.dart';
import 'package:bin_got/widgets/bingo_board.dart';
import 'package:bin_got/widgets/button.dart';
import 'package:bin_got/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:bin_got/widgets/bottom_bar.dart';

class BingoDetail extends StatelessWidget {
  final String title, nickname, achieve, font;
  const BingoDetail({
    super.key,
    this.title = '빙고판이다',
    this.nickname = '노래 추천 좀',
    this.achieve = '100',
    this.font = 'RIDIBatang',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BingoDetailAppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomText(content: title, fontSize: FontSize.titleSize),
          const SizedBox(height: 20),
          CustomText(content: nickname, fontSize: FontSize.smallSize),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButtonInRow(
                onPressed:
                    toOtherPage(context: context, page: const BingoForm()),
                icon: editIcon,
              ),
              IconButtonInRow(
                onPressed: () {},
                icon: deleteIcon,
              ),
              const SizedBox(width: 20)
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: BingoBoard(
              isDetail: true,
              bingoSize: 3,
              font: font,
            ),
          ),
          CustomText(content: '달성률 : $achieve%', fontSize: FontSize.largeSize)
        ],
      ),
      bottomNavigationBar: const BottomBar(isMember: true),
    );
  }
}
