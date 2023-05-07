import 'dart:ui';

import 'package:bin_got/pages/bingo_detail_page.dart';
import 'package:bin_got/providers/bingo_provider.dart';
import 'package:bin_got/providers/group_provider.dart';
import 'package:bin_got/utilities/global_func.dart';
import 'package:bin_got/utilities/image_icon_utils.dart';
import 'package:bin_got/utilities/style_utils.dart';
import 'package:bin_got/utilities/type_def_utils.dart';
import 'package:bin_got/widgets/app_bar.dart';
import 'package:bin_got/widgets/bingo_board.dart';
import 'package:bin_got/widgets/button.dart';
import 'package:bin_got/widgets/input.dart';
import 'package:bin_got/widgets/row_col.dart';
import 'package:bin_got/widgets/tab_bar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class BingoForm extends StatefulWidget {
  final int bingoSize;
  final int? bingoId;
  final bool needAuth;
  const BingoForm({
    super.key,
    this.bingoId,
    required this.bingoSize,
    required this.needAuth,
  });

  @override
  State<BingoForm> createState() => _BingoFormState();
}

class _BingoFormState extends State<BingoForm> {
  GlobalKey globalKey = GlobalKey();
  var thumbnail;
  final DynamicMap bingoData = {
    'group_id': 0,
    'title': '',
    'background': 1,
    'is_black': false,
    'has_border': true,
    'has_round_edge': true,
    'around_kan': 0,
    'complete_icon': 0,
    'font': 1,
    'items': [],
  };
  @override
  void initState() {
    super.initState();
    bingoData['group_id'] = getGroupId(context);
  }

  int font = 0;
  int? backgroundIdx;
  List<dynamic> selected = [
    null,
    [false, false, false, 0],
    0,
    0,
  ];

  void changeOption(int i) {
    selected[1][i] = !selected[1][i];
  }

  void changeFont(int newFont) {
    font = newFont;
  }

  void changeBackground(int newIdx) {
    backgroundIdx = backgroundIdx != newIdx ? newIdx : null;
  }

  void changeCheck(int newIdx) {
    selected[3] = newIdx;
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
          changeFont(i);
          break;
        default:
          changeCheck(i);
          break;
      }
    });
  }

  void createOrEditBingo() async {
    await BingoProvider()
        .createOwnBingo(FormData.fromMap({'data': bingoData, 'thumbnail': ''}));
  }

  void bingoToThumb() async {
    print('시작');
    var renderObject = globalKey.currentContext?.findRenderObject();
    if (renderObject is RenderRepaintBoundary) {
      var boundary = renderObject;
      final image = await boundary.toImage();
      final byteData = await image.toByteData(format: ImageByteFormat.png);
      setState(() {
        thumbnail = byteData?.buffer.asUint8List();
        print(thumbnail);
      });
    }
  }

  void joinGroup() async {
    try {
      await GroupProvider().joinGroup(getGroupId(context)!);
      if (!context.mounted) return;
      if (widget.needAuth == true) {
        toBack(context)();
      }
      showAlert(
        context,
        title: '가입 신청',
        content: widget.needAuth == true
            ? '가입 신청되었습니다.\n그룹장의 승인 후 가입됩니다.'
            : '성공적으로 가입되었습니다.',
        hasCancel: false,
      )();
      if (widget.needAuth == false) {
        //* 새로고침
      }
    } catch (error) {
      showAlert(
        context,
        title: '가입 오류',
        content: '오류가 발생해 가입이 되지 않았습니다.',
        hasCancel: false,
      )();
    }
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
          Flexible(
            flex: 2,
            child: CustomInput(
              explain: '빙고 이름',
              setValue: (p0) {},
            ),
          ),
          Flexible(
            flex: 6,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              child: RepaintBoundary(
                key: globalKey,
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
                  checkIcon: selected[3],
                ),
              ),
            ),
          ),
          Flexible(
            flex: 4,
            child: BingoTabBar(
              selected: selected,
              changeSelected: changeSelected,
            ),
          ),
          Flexible(
            flex: 1,
            child: Center(
              child: CustomButton(
                onPressed: toOtherPage(context,
                    page: BingoDetail(
                      bingoId: widget.bingoId!,
                    )),
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
