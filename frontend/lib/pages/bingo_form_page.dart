import 'package:bin_got/pages/bingo_detail_page.dart';
import 'package:bin_got/utilities/global_func.dart';
import 'package:bin_got/utilities/image_icon_utils.dart';
import 'package:bin_got/utilities/style_utils.dart';
import 'package:bin_got/widgets/app_bar.dart';
import 'package:bin_got/widgets/bingo_board.dart';
import 'package:bin_got/widgets/button.dart';
import 'package:bin_got/widgets/input.dart';
import 'package:bin_got/widgets/row_col.dart';
import 'package:bin_got/widgets/tab_bar.dart';
import 'package:flutter/material.dart';

class BingoForm extends StatefulWidget {
  final int bingoSize;
  const BingoForm({super.key, this.bingoSize = 3});

  @override
  State<BingoForm> createState() => _BingoFormState();
}

class _BingoFormState extends State<BingoForm> {
  String font = 'RIDIBatang';
  int? backgroundIdx;
  List<dynamic> selected = [
    null,
    [false, false, false, 0],
    0
  ];

  void changeOption(int i) {
    selected[1][i] = !selected[1][i];
  }

  void changeFont(String newFont) {
    font = newFont;
  }

  void changeBackground(int newIdx) {
    backgroundIdx = backgroundIdx != newIdx ? newIdx : null;
  }

  void changeSelected(int tabIndex, int i) {
    setState(() {
      switch (tabIndex) {
        case 0:
          selected[tabIndex] = i;
          changeBackground(i);
          break;
        case 1:
          switch (i) {
            case 3:
              selected[tabIndex][i] += selected[tabIndex][i] < 2 ? 1 : -2;
              break;
            default:
              changeOption(i);
              break;
          }
          break;
        case 2:
          selected[tabIndex] = i;
          changeFont(matchFont[i]);
          break;
        default:
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const AppBarWithBack(),
      body: ColWithPadding(
        horizontal: 10,
        vertical: 5,
        children: [
          const Flexible(
            flex: 2,
            child: CustomInput(explain: '빙고 이름'),
          ),
          Flexible(
            flex: 6,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              child: BingoBoard(
                gap: selected[1][3],
                hasRoundEdge: selected[1][0],
                eachColor: selected[1][2] ? blackColor : whiteColor,
                hasBorder: selected[1][1],
                isDetail: false,
                bingoSize: widget.bingoSize,
                font: font,
                background: backgroundIdx != null
                    ? backgroundList[backgroundIdx!]
                    : null,
              ),
            ),
          ),
          Flexible(
              flex: 4,
              child: BingoTabBar(
                  selected: selected, changeSelected: changeSelected)),
          Flexible(
            flex: 1,
            child: Center(
              child: CustomButton(
                onPressed:
                    toOtherPage(context: context, page: const BingoDetail()),
                content: '완료',
                fontSize: FontSize.textSize,
              ),
            ),
          )
        ],
      ),
    );
  }
}
