import 'package:bin_got/pages/bingo_form_page.dart';
import 'package:bin_got/providers/root_provider.dart';
import 'package:bin_got/utilities/global_func.dart';
import 'package:bin_got/utilities/image_icon_utils.dart';
import 'package:bin_got/utilities/style_utils.dart';
import 'package:bin_got/widgets/bingo_board.dart';
import 'package:bin_got/widgets/button.dart';
import 'package:bin_got/widgets/container.dart';
import 'package:bin_got/widgets/switch_indicator.dart';
import 'package:bin_got/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//? 빙고 상세
class BingoDetail extends StatefulWidget {
  final int? size;
  const BingoDetail({
    super.key,
    this.size,
  });

  @override
  State<BingoDetail> createState() => _BingoDetailState();
}

class _BingoDetailState extends State<BingoDetail> {
  int bingoSize = 0;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      bingoSize = context.read<GlobalBingoProvider>().bingoSize ??
          context.read<GlobalGroupProvider>().bingoSize!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return !watchLoading(context)
        ? RepaintBoundary(
            key: context.watch<GlobalBingoProvider>().globalKey,
            child: CustomBoxContainer(
              hasRoundEdge: false,
              image: watchBackground(context) != null
                  ? DecorationImage(
                      image:
                          AssetImage(backgroundList[watchBackground(context)!]),
                      fit: BoxFit.fitHeight,
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
                      content: context.watch<GlobalBingoProvider>().title ?? '',
                      fontSize: FontSize.titleSize,
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: CustomText(
                        content: getBingoData(context).containsKey('username')
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
                            onPressed: toOtherPageWithAnimation(
                              context,
                              page: BingoForm(
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
        : const CustomCirCularIndicator();
  }
}
