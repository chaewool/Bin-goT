import 'dart:ui';

import 'package:bin_got/pages/bingo_form_page.dart';
import 'package:bin_got/providers/bingo_provider.dart';
import 'package:bin_got/providers/root_provider.dart';
import 'package:bin_got/utilities/global_func.dart';
import 'package:bin_got/utilities/image_icon_utils.dart';
import 'package:bin_got/utilities/style_utils.dart';
import 'package:bin_got/utilities/type_def_utils.dart';
import 'package:bin_got/widgets/bingo_board.dart';
import 'package:bin_got/widgets/button.dart';
import 'package:bin_got/widgets/text.dart';
import 'package:bin_got/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class BingoDetail extends StatelessWidget {
  final int? size;
  const BingoDetail({
    super.key,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    GlobalKey globalKey = GlobalKey();
    int bingoSize = size ?? context.read<GlobalGroupProvider>().bingoSize!;

    FutureBool bingoToImage() async {
      var renderObject = globalKey.currentContext?.findRenderObject();
      if (renderObject is RenderRepaintBoundary) {
        var boundary = renderObject;
        final image = await boundary.toImage();
        final byteData = await image.toByteData(format: ImageByteFormat.png);
        final pngBytes = byteData?.buffer.asUint8List();
        await ImageGallerySaver.saveImage(
          pngBytes!,
          name: context.read<GlobalBingoProvider>().title,
        );
        print('성공!!!');
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

    return getBingoId(context) != null
        ? Stack(
            children: [
              FutureBuilder(
                future: BingoProvider().readBingoDetail(getBingoId(context)!),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final DynamicMap data = snapshot.data!;
                    print('bingo data => $data');
                    final int achieve = (data['achieve']! * 100).toInt();
                    // groupId = data['group'];
                    setBingoData(context, data);
                    final length = bingoSize * bingoSize;
                    initFinished(context, length);
                    for (int i = 0; i < length; i += 1) {
                      setFinished(context, i, data['items'][i]['finished']);
                    }

                    return RepaintBoundary(
                      key: globalKey,
                      child: Column(
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
                                if (DateTime.now().difference(
                                      DateTime.parse(getStart(context)!),
                                    ) <
                                    Duration.zero)
                                  IconButtonInRow(
                                    onPressed: toOtherPage(
                                      context,
                                      page: BingoForm(
                                        // bingoId: getBingoId(context),
                                        bingoSize: bingoSize,
                                        needAuth: false,
                                      ),
                                    ),
                                    icon: editIcon,
                                  ),
                                const SizedBox(width: 20)
                              ],
                            ),
                          ),
                          Flexible(
                            flex: 6,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: BingoBoard(
                                isDetail: true,
                                bingoSize: bingoSize,
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 2,
                            child: Center(
                              child: CustomText(
                                content: '달성률 : $achieve%',
                                fontSize: FontSize.largeSize,
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  }
                  return const Center(
                      child: CustomText(content: '정보를 불러오는 중입니다'));
                },
              ),
              if (watchAfterWork(context))
                const CustomToast(content: '인증 요청되었습니다.')
            ],
          )
        : const SizedBox();
  }
}
