import 'package:bin_got/pages/bingo_form_page.dart';
import 'package:bin_got/providers/bingo_provider.dart';
import 'package:bin_got/providers/root_provider.dart';
import 'package:bin_got/utilities/global_func.dart';
import 'package:bin_got/utilities/image_icon_utils.dart';
import 'package:bin_got/utilities/style_utils.dart';
import 'package:bin_got/utilities/type_def_utils.dart';
import 'package:bin_got/widgets/bingo_board.dart';
import 'package:bin_got/widgets/button.dart';
import 'package:bin_got/widgets/container.dart';
import 'package:bin_got/widgets/text.dart';
import 'package:bin_got/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BingoDetail extends StatelessWidget {
  final int? size;
  const BingoDetail({
    super.key,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    int bingoSize = context.read<GlobalBingoProvider>().bingoSize ??
        context.read<GlobalGroupProvider>().bingoSize!;

    int bingoId = getBingoId(context) ?? myBingoId(context)!;

    print('bingo id => ${getBingoId(context)}');

    return
        // watchBingoId(context) != null ?
        Stack(
      children: [
        FutureBuilder(
          future: BingoProvider().readBingoDetail(
            getGroupId(context)!,
            bingoId,
          ),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final DynamicMap data = snapshot.data!;
              // print('--------- bingo data => $data');
              final int achieve = (data['achieve']! * 100).toInt();
              // print(achieve);
              // groupId = data['group'];
              setBingoData(context, data);
              final length = bingoSize * bingoSize;
              // print(length);
              initFinished(context, length);
              for (int i = 0; i < length; i += 1) {
                setFinished(context, i, data['items'][i]['finished']);
              }
              // print(getBingoData(context));

              return RepaintBoundary(
                key: context.read<GlobalBingoProvider>().globalKey,
                child: CustomBoxContainer(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
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
                            if (alreadyStarted(context) != true &&
                                (myBingoId(context) == null ||
                                    myBingoId(context) == getId(context)))
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
                          padding: const EdgeInsets.symmetric(
                            vertical: 20,
                            horizontal: 10,
                          ),
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
                ),
              );
            }
            return const Center(
              child: CustomText(
                content: '정보를 불러오는 중입니다',
                color: blackColor,
              ),
            );
          },
        ),
        if (watchAfterWork(context)) const CustomToast(content: '인증 요청되었습니다.')
      ],
    );
    // : const CustomBoxContainer(
    //     color: blackColor,
    //     width: 100,
    //     height: 100,
    //   );
  }
}
