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
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class BingoDetail extends StatelessWidget {
  final int bingoId;
  final int? size;
  const BingoDetail({
    super.key,
    required this.bingoId,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    int groupId = 0;
    GlobalKey globalKey = GlobalKey();
    int bingoSize = size ?? context.read<GlobalGroupProvider>().bingoSize!;
    // void deleteBingo() {
    //   BingoProvider().deleteOwnBingo(widget.bingoId).then((_) {
    //     toBack(context);
    //     showAlert(
    //       context,
    //       title: '삭제 완료',
    //       content: '빙고가 정상적으로 삭제되었습니다.',
    //       hasCancel: false,
    //     )();
    //   }).catchError((_) {
    //     showAlert(
    //       context,
    //       title: '삭제 오류',
    //       content: '오류가 발생해 빙고가 삭제되지 않았습니다.',
    //       hasCancel: false,
    //     )();
    //   });
    // }

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

    FutureBool saveBingoImg() {
      try {
        Permission.storage.request().then((value) {
          if (value == PermissionStatus.denied ||
              value == PermissionStatus.permanentlyDenied) {
            showAlert(
              context,
              title: '미디어 접근 권한 거부',
              content: '미디어 접근 권한이 없습니다. 설정에서 접근 권한을 허용해주세요',
              hasCancel: false,
            )();
          } else {
            bingoToImage();
          }
        });
        return Future.value(true);
      } catch (error) {
        print(error);
        return Future.value(false);
      }
    }

    return Scaffold(
        appBar: BingoDetailAppBar(
          save: saveBingoImg,
          bingoId: bingoId,
        ),
        body: FutureBuilder(
          future: BingoProvider().readBingoDetail(bingoId),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final DynamicMap data = snapshot.data!;
              print('bingo data => $data');
              final int achieve = (data['achieve']! * 100).toInt();
              groupId = data['group'];
              setBingoData(context, data);
              if (data['statusCode'] == 401) {
                showLoginModal(context);
                return const SizedBox();
              } else {
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
                          DateTime.now().difference(
                                    DateTime.parse(getStart(context)!),
                                  ) >
                                  Duration.zero
                              ? IconButtonInRow(
                                  onPressed: toOtherPage(
                                    context,
                                    page: BingoForm(
                                      bingoId: bingoId,
                                      bingoSize: bingoSize,
                                      needAuth: false,
                                    ),
                                  ),
                                  icon: editIcon,
                                )
                              : const SizedBox(),
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
                          child: BingoBoard(
                            isDetail: true,
                            bingoSize: bingoSize,
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
