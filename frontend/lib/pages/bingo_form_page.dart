import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

import 'package:bin_got/pages/bingo_detail_page.dart';
import 'package:bin_got/pages/group_main_page.dart';
import 'package:bin_got/providers/bingo_provider.dart';
import 'package:bin_got/providers/group_provider.dart';
import 'package:bin_got/providers/root_provider.dart';
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
import 'package:provider/provider.dart';
import 'package:http_parser/http_parser.dart';

class BingoForm extends StatefulWidget {
  final int bingoSize;
  final int? bingoId;
  final bool needAuth, beforeJoin;
  const BingoForm({
    super.key,
    this.bingoId,
    required this.bingoSize,
    required this.needAuth,
    this.beforeJoin = false,
  });

  @override
  State<BingoForm> createState() => _BingoFormState();
}

class _BingoFormState extends State<BingoForm> {
  GlobalKey globalKey = GlobalKey();
  Uint8List? thumbnail;
  bool changed = true;
  late final size;

  @override
  void initState() {
    super.initState();
    size = getBingoSize(context);
    setOption(context, 'group_id', getGroupId(context)!);
    if (getItems(context).isEmpty) {
      context.read<GlobalBingoProvider>().initItems(size * size);
    }
  }

  void createOrEditBingo() async {
    if (changed) {
      bingoToThumb().then((_) {
        final data = context.read<GlobalBingoProvider>().data;
        if (data['title'] == null) {
          return showAlert(
            context,
            title: '필수 항목 누락',
            content: '빙고명을 입력해주세요',
          )();
        }
        int cnt = 0;
        for (var element in (data['items'] as List)) {
          final title = element['title'].trim();
          final content = element['content'].trim();
          if (title != null &&
              title != '' &&
              content != null &&
              content != '') {
            cnt += 1;
          }
        }

        if (cnt != size * size) {
          return showAlert(
            context,
            title: '필수 항목 누락',
            content: '빙고칸 내부를 채워주세요',
          )();
        }
        final bingoData = FormData.fromMap({
          'data': jsonEncode(data),
          'thumbnail': MultipartFile.fromBytes(
            thumbnail!,
            filename: 'thumbnail.png',
            contentType: MediaType('image', 'png'),
          ),
        });

        if (widget.bingoId == null) {
          BingoProvider().createOwnBingo(bingoData).then((bingoId) async {
            if (widget.beforeJoin) {
              joinGroup();
            }
            if (!mounted) return;
            toOtherPage(
              context,
              page: BingoDetail(bingoId: bingoId),
            )();
          });
        } else {
          print(widget.bingoId);
          BingoProvider().editOwnBingo(widget.bingoId!, bingoData).then((_) {
            toOtherPage(
              context,
              page: BingoDetail(bingoId: widget.bingoId!),
            )();
          });
        }
      });
    } else {
      return showAlert(
        context,
        title: '필수 항목 누락',
        content: '변경사항이 없습니다.',
      )();
    }
  }

  FutureBool bingoToThumb() async {
    var renderObject = globalKey.currentContext?.findRenderObject();
    if (renderObject is RenderRepaintBoundary) {
      var boundary = renderObject;
      final image = await boundary.toImage();
      final byteData = await image.toByteData(format: ImageByteFormat.png);
      setState(() {
        thumbnail = byteData?.buffer.asUint8List();
      });
    }
    return true;
  }

  void joinGroup() async {
    try {
      GroupProvider().joinGroup(getGroupId(context)!).then((_) {
        if (widget.needAuth == true) {
          toBack(context);
          showAlert(
            context,
            title: '가입 신청',
            content: '가입 신청되었습니다.\n그룹장의 승인 후 가입됩니다.',
            hasCancel: false,
          )();
        } else {
          toOtherPage(
            context,
            page: GroupMain(
              groupId: getGroupId(context)!,
              isPublic: true,
            ),
          );
          showAlert(
            context,
            title: '가입 완료',
            content: '성공적으로 가입되었습니다.',
            hasCancel: false,
          )();
        }
      });
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
              setValue: (value) => setOption(context, 'title', value),
              initialValue: getTitle(context),
            ),
          ),
          Flexible(
            flex: 6,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              child: RepaintBoundary(
                key: globalKey,
                child: const BingoBoard(
                  isDetail: false,
                ),
              ),
            ),
          ),
          const Flexible(
            flex: 4,
            child: BingoTabBar(),
          ),
          Flexible(
            flex: 1,
            child: Center(
              child: CustomButton(
                onPressed: createOrEditBingo,
                content: widget.beforeJoin ? '가입 신청' : '완료',
                fontSize: FontSize.textSize,
              ),
            ),
          )
        ],
      ),
    );
  }
}
