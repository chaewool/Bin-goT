import 'dart:io';
import 'dart:ui';

import 'package:bin_got/pages/bingo_form_page.dart';
import 'package:bin_got/providers/bingo_provider.dart';
import 'package:bin_got/providers/root_provider.dart';
import 'package:bin_got/utilities/global_func.dart';
import 'package:bin_got/utilities/image_icon_utils.dart';
import 'package:bin_got/utilities/style_utils.dart';
import 'package:bin_got/utilities/type_def_utils.dart';
import 'package:bin_got/widgets/app_bar.dart';
import 'package:bin_got/widgets/bingo_board.dart';
import 'package:bin_got/widgets/button.dart';
import 'package:bin_got/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:bin_got/widgets/bottom_bar.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

class BingoDetail extends StatefulWidget {
  final int bingoId;
  const BingoDetail({
    super.key,
    required this.bingoId,
  });

  @override
  State<BingoDetail> createState() => _BingoDetailState();
}

class _BingoDetailState extends State<BingoDetail> {
  @override
  Widget build(BuildContext context) {
    int groupId = 0;
    GlobalKey globalKey = GlobalKey();
    void deleteBingo() {
      BingoProvider().deleteOwnBingo(widget.bingoId).then((_) {
        toBack(context);
        showAlert(
          context,
          title: '삭제 완료',
          content: '빙고가 정상적으로 삭제되었습니다.',
          hasCancel: false,
        )();
      }).catchError((_) {
        showAlert(
          context,
          title: '삭제 오류',
          content: '오류가 발생해 빙고가 삭제되지 않았습니다.',
          hasCancel: false,
        )();
      });
    }

    void onDeleteEvent() {
      final start = context.read<GlobalGroupProvider>().start;
      final difference =
          DateTime.now().difference(DateTime.parse(start!)).inDays;
      if (difference < 0) {
        showAlert(
          context,
          title: '삭제 확인',
          content: '빙고를 삭제하시겠습니까?\n그룹 시작 전에\n빙고를 재생성해야 합니다.',
          onPressed: deleteBingo,
        )();
      } else {
        showAlert(
          context,
          title: '삭제 오류',
          content: '시작일이 지난 그룹의 빙고는 삭제할 수 없습니다',
          hasCancel: false,
        )();
      }
    }

    FutureBool bingoToImage() async {
      var renderObject = globalKey.currentContext?.findRenderObject();
      if (renderObject is RenderRepaintBoundary) {
        var boundary = renderObject;
        final image = await boundary.toImage();
        final byteData = await image.toByteData(format: ImageByteFormat.png);
        final pngBytes = byteData?.buffer.asUint8List();
        print(pngBytes);
        final imgFile = File('image_file.png');
        imgFile.writeAsBytes(pngBytes!);
        return true;
      }
      return false;
    }

    return Scaffold(
        appBar: BingoDetailAppBar(
          save: bingoToImage,
          bingoId: widget.bingoId,
        ),
        body: FutureBuilder(
          future: BingoProvider().readBingoDetail(widget.bingoId),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final DynamicMap data = snapshot.data!;
              final int achieve = (data['achieve']! * 100).toInt();
              groupId = data['group'];
              setBingoData(context, data);
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    flex: 2,
                    child: CustomText(
                      content: data['title'],
                      fontSize: FontSize.titleSize,
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: CustomText(
                        content: data['username'],
                        fontSize: FontSize.smallSize,
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButtonInRow(
                          onPressed: toOtherPage(
                            context,
                            page: BingoForm(
                              bingoId: widget.bingoId,
                              bingoSize: context
                                  .read<GlobalGroupProvider>()
                                  .bingoSize!,
                              needAuth: false,
                            ),
                          ),
                          icon: editIcon,
                        ),
                        IconButtonInRow(
                          onPressed: onDeleteEvent,
                          icon: deleteIcon,
                        ),
                        const SizedBox(width: 20)
                      ],
                    ),
                  ),
                  Flexible(
                    flex: 6,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: RepaintBoundary(
                        key: globalKey,
                        child: const BingoBoard(
                          isDetail: true,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: CustomText(
                      content: '달성률 : $achieve%',
                      fontSize: FontSize.largeSize,
                    ),
                  )
                ],
              );
            }
            return const Center(child: CustomText(content: '정보를 불러오는 중입니다'));
          },
        ),
        bottomNavigationBar: BottomBar(
          isMember: true,
          groupId: groupId,
        ) // 수정 필요,
        );
  }
}
