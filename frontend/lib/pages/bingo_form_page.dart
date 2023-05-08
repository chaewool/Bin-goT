import 'dart:ui';

import 'package:bin_got/pages/bingo_detail_page.dart';
import 'package:bin_got/providers/bingo_provider.dart';
import 'package:bin_got/providers/group_provider.dart';
import 'package:bin_got/utilities/global_func.dart';
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
    'background': null,
    'is_black': false,
    'has_border': false,
    'has_round_edge': false,
    'around_kan': 0,
    'complete_icon': 0,
    'font': 0,
    'items': [],
  };
  @override
  void initState() {
    super.initState();
    bingoData['group_id'] = getGroupId(context);
  }

  void changeBackground(int i) {
    if (bingoData['background'] == i) {
      bingoData['background'] = null;
    } else {
      bingoData['background'] = i;
    }
  }

  ReturnVoid setOption(String key, dynamic value) {
    return () => bingoData[key] = value;
  }

  void changeData(int tabIndex, int i) {
    switch (tabIndex) {
      case 0:
        changeBackground(i);
        break;
      case 1:
        final keyList = ['has_round_edge', 'has_border', 'is_black'];
        switch (i) {
          case 3:
            bingoData['around_kan'] += bingoData['around_kan'] < 2 ? 1 : -2;
            break;
          default:
            bingoData[keyList[i]] = !bingoData[keyList[i]];
            break;
        }
        break;
      case 2:
        setOption('font', i);
        break;
      default:
        setOption('complete_icon', i);
        break;
    }
  }

  void createOrEditBingo() async {
    await BingoProvider()
        .createOwnBingo(FormData.fromMap({'data': bingoData, 'thumbnail': ''}));
    if (!mounted) return;
    toOtherPage(context,
        page: BingoDetail(
          bingoId: widget.bingoId!,
        ))();
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
              setValue: (value) => bingoData['title'] = value,
            ),
          ),
          Flexible(
            flex: 6,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              child: RepaintBoundary(
                key: globalKey,
                child: BingoBoard(
                  data: bingoData,
                ),
              ),
            ),
          ),
          Flexible(
            flex: 4,
            child: BingoTabBar(
              data: bingoData,
              changeData: changeData,
            ),
          ),
          Flexible(
            flex: 1,
            child: Center(
              child: CustomButton(
                onPressed: createOrEditBingo,
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
