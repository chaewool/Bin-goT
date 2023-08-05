import 'package:bin_got/models/group_model.dart';
import 'package:bin_got/pages/bingo_detail_page.dart';
import 'package:bin_got/pages/bingo_form_page.dart';
import 'package:bin_got/pages/group_rank_page.dart';
import 'package:bin_got/utilities/global_func.dart';
import 'package:bin_got/utilities/style_utils.dart';
import 'package:bin_got/widgets/app_bar.dart';
import 'package:bin_got/widgets/bottom_bar.dart';
import 'package:bin_got/widgets/container.dart';
import 'package:bin_got/widgets/button.dart';
import 'package:bin_got/widgets/row_col.dart';
import 'package:bin_got/widgets/text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GroupMain extends StatefulWidget with WidgetsBindingObserver {
  final int groupId;
  final GroupDetailModel data;
  const GroupMain({
    super.key,
    required this.groupId,
    required this.data,
  });

  @override
  State<GroupMain> createState() => _GroupMainState();
}

class _GroupMainState extends State<GroupMain> {
  late int memberState, size;
  late int? bingoId;
  late bool needAuth;
  @override
  void initState() {
    super.initState();
    memberState = widget.data.memberState;
    size = widget.data.bingoSize;
    needAuth = widget.data.needAuth;
    bingoId = widget.data.bingoId;
    // WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    // WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        toBack(context);
        toBack(context);
        setPublic(context, null);
        return Future.value(false);
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: GroupAppBar(
            groupId: widget.groupId,
            isMember: memberState != 0,
            isAdmin: memberState == 2,
            password: widget.data.password,
          ),
        ),
        body: SingleChildScrollView(
          child: CustomBoxContainer(
              child: ColWithPadding(
            vertical: 30,
            horizontal: 30,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              widget.data.hasImage
                  ? CachedNetworkImage(
                      imageUrl:
                          '${dotenv.env['fileUrl']}/groups/${widget.groupId}',
                      placeholder: (context, url) =>
                          const SizedBox(width: 200, height: 200),
                    )
                  : const SizedBox(),
              groupHeader(widget.data),
              const SizedBox(height: 20),
              memberState != 0
                  ? CustomButton(
                      onPressed: toOtherPage(
                        context,
                        page: widget.data.bingoId != 0
                            ? BingoDetail(bingoId: bingoId!)
                            : BingoForm(
                                bingoSize: size,
                                needAuth: needAuth,
                                beforeJoin: true,
                              ),
                      ),
                      content: bingoId != 0 ? '내 빙고 보기' : '내 빙고 만들기',
                    )
                  : const SizedBox(),
              ShowContentBox(
                  contentTitle: '설명', content: widget.data.description ?? ''),
              ShowContentBox(
                  contentTitle: '규칙', content: widget.data.rule ?? ''),
              // groupRankTop3(context, data),
            ],
          )),
        ),
        bottomNavigationBar: BottomBar(
          isMember: memberState != 0,
          groupId: widget.groupId,
          needAuth: needAuth,
          size: size,
        ),
      ),
    );
  }

  Padding groupRankTop3(BuildContext context, GroupDetailModel data) {
    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RowWithPadding(
            vertical: 10,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const CustomText(content: '랭킹'),
              TextButton(
                onPressed: memberState != 0
                    ? toOtherPage(
                        context,
                        page: GroupRank(
                          groupId: widget.groupId,
                          isMember: memberState != 0,
                          password: widget.data.password,
                        ),
                      )
                    : null,
                child: const CustomText(
                  content: '전체보기',
                  fontSize: FontSize.smallSize,
                ),
              )
            ],
          ),
          // for (int i = 0; i < 3; i += 1)
          //   RankListItem(
          //     rank: i + 1,
          //     rankListItem: data.rank,
          //     isMember: memberState != 0,
          //   ),
        ],
      ),
    );
  }

  Column groupHeader(GroupDetailModel data) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(content: data.groupName, fontSize: FontSize.titleSize),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: CustomText(content: '참여 인원 ${data.count}/${data.headCount}'),
        ),
        CustomText(content: '${data.start} ~ ${data.end}'),
      ],
    );
  }
}
