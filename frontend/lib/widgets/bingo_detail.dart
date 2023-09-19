import 'package:bin_got/pages/bingo_form_page.dart';
import 'package:bin_got/providers/bingo_provider.dart';
import 'package:bin_got/providers/root_provider.dart';
import 'package:bin_got/utilities/global_func.dart';
import 'package:bin_got/utilities/image_icon_utils.dart';
import 'package:bin_got/utilities/style_utils.dart';
import 'package:bin_got/widgets/bingo_board.dart';
import 'package:bin_got/widgets/button.dart';
import 'package:bin_got/widgets/container.dart';
import 'package:bin_got/widgets/switch_indicator.dart';
import 'package:bin_got/widgets/text.dart';
import 'package:bin_got/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BingoDetail extends StatefulWidget {
  final int? size;
  // final GlobalKey globalKey;
  const BingoDetail({
    super.key,
    this.size,
    // required this.globalKey,
  });

  @override
  State<BingoDetail> createState() => _BingoDetailState();
}

class _BingoDetailState extends State<BingoDetail> {
  int bingoSize = 0;
  int bingoId = 0;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      bingoSize = context.read<GlobalBingoProvider>().bingoSize ??
          context.read<GlobalGroupProvider>().bingoSize!;

      bingoId = getBingoId(context) ?? myBingoId(context)!;
      context.read<GlobalBingoProvider>().initKey();
      setLoading(context, true);
      readBingoDetail();
    });
  }

  void readBingoDetail() {
    BingoProvider()
        .readBingoDetail(
      getGroupId(context)!,
      bingoId,
    )
        .then((data) {
      setBingoData(context, data);
      final length = bingoSize * bingoSize;
      initFinished(context, length);
      for (int i = 0; i < length; i += 1) {
        setFinished(context, i, data['items'][i]['finished']);
      }
      setLoading(context, false);
      print('bingo data => ${getBingoData(context)}');
    });
  }

  @override
  Widget build(BuildContext context) {
    // GlobalKey globalKey = GlobalKey();

    print('bingo id => ${getBingoId(context)}');
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   if (watchRefresh(context)) {
    //     applyRefresh(context, false);
    //   }
    // });

    return
        // watchBingoId(context) != null ?
        Stack(
      children: [
        !watchLoading(context)
            ? RepaintBoundary(
                key: context.watch<GlobalBingoProvider>().globalKey,
                child: CustomBoxContainer(
                  image: watchBackground(context) != null
                      ? DecorationImage(
                          image: AssetImage(
                              backgroundList[watchBackground(context)!]),
                          fit: BoxFit.fill,
                        )
                      : null,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                        flex: 2,
                        child: CustomText(
                          content: watchTitle(context) ?? '',
                          fontSize: FontSize.titleSize,
                        ),
                      ),
                      Flexible(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: CustomText(
                            content:
                                getBingoData(context).containsKey('username')
                                    ? getBingoData(context)['username']
                                    : '',
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
                                    myBingoId(context) == getBingoId(context)))
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
                            content:
                                '달성률 : ${context.watch<GlobalBingoProvider>().achieve}%',
                            fontSize: FontSize.largeSize,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            : const CustomCirCularIndicator(),
        // FutureBuilder(
        //   future:
        //   builder: (context, snapshot) {
        //     if (snapshot.hasData) {
        //       context.read<GlobalBingoProvider>().initKey();
        //       final DynamicMap data = snapshot.data!;
        //       // print('--------- bingo data => $data');
        //       final int achieve = (data['achieve']! * 100).toInt();
        //       // print(achieve);
        //       // groupId = data['group'];
        //       setBingoData(context, data);
        //       final length = bingoSize * bingoSize;
        //       // print(length);
        //       initFinished(context, length);
        //       for (int i = 0; i < length; i += 1) {
        //         setFinished(context, i, data['items'][i]['finished']);
        //       }
        //       // print(getBingoData(context));

        //       return
        //     }
        //     return const Center(child: CustomCirCularIndicator());
        //   },
        // ),
        if (watchAfterWork(context))
          CustomToast(
            content: watchToastString(context),
          )
      ],
    );
    // : const CustomBoxContainer(
    //     color: blackColor,
    //     width: 100,
    //     height: 100,
    //   );
  }
}
