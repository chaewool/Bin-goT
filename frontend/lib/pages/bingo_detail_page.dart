import 'package:bin_got/models/bingo_model.dart';
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
import 'package:provider/provider.dart';

class BingoDetail extends StatelessWidget {
  final int bingoId;
  const BingoDetail({
    super.key,
    required this.bingoId,
  });

  @override
  Widget build(BuildContext context) {
    int groupId = 0;
    GlobalKey globalKey = GlobalKey();

    void deleteBingo() {
      final start = context.read<GlobalGroupProvider>().start;
      if (start != '') {}
    }

    Map<String, dynamic> bingoToMap(BingoDetailModel bingoDetail) {
      final Map<String, dynamic> bingoDetailMap = {};
      bingoDetailMap['group_id'] = bingoDetail.groupId;
      bingoDetailMap['author_id'] = bingoDetail.authorId;
      bingoDetailMap['achieve'] = bingoDetail.achieve;
      bingoDetailMap['title'] = bingoDetail.title;
      bingoDetailMap['is_black'] = bingoDetail.hasBlackBox;
      bingoDetailMap['has_round_edge'] = bingoDetail.hasRoundEdge;
      bingoDetailMap['background'] = bingoDetail.background;
      bingoDetailMap['has_boarder'] = bingoDetail.hasBoarder;
      bingoDetailMap['around_kan'] = bingoDetail.gap;
      bingoDetailMap['complete_icon'] = bingoDetail.completeIcon;
      bingoDetailMap['font'] = bingoDetail.font;
      bingoDetailMap['items'] = bingoDetail.items;

      groupId = bingoDetail.groupId;

      return bingoDetailMap;
    }

    return Scaffold(
        appBar: const BingoDetailAppBar(),
        body: FutureBuilder(
          future: BingoProvider().readBingoDetail(bingoId),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final DynamicMap data = snapshot.data!;
              groupId = data['group_id'];
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
                        content: data['title'],
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
                          onPressed: toOtherPage(context,
                              page: BingoForm(
                                bingoId: bingoId,
                                bingoSize: context
                                    .read<GlobalGroupProvider>()
                                    .bingoSize!,
                                needAuth: false,
                              )),
                          icon: editIcon,
                        ),
                        IconButtonInRow(
                          onPressed: deleteBingo,
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
                      content: '달성률 : ${data['achieve']}%',
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
