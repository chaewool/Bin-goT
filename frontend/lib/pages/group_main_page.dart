import 'package:bin_got/models/group_model.dart';
import 'package:bin_got/pages/bingo_detail_page.dart';
import 'package:bin_got/pages/bingo_form_page.dart';
import 'package:bin_got/providers/group_provider.dart';
import 'package:bin_got/utilities/global_func.dart';
import 'package:bin_got/utilities/style_utils.dart';
import 'package:bin_got/utilities/type_def_utils.dart';
import 'package:bin_got/widgets/app_bar.dart';
import 'package:bin_got/widgets/bottom_bar.dart';
import 'package:bin_got/widgets/box_container.dart';
import 'package:bin_got/widgets/button.dart';
import 'package:bin_got/widgets/list.dart';
import 'package:bin_got/widgets/row_col.dart';
import 'package:bin_got/widgets/tab_bar.dart';
import 'package:bin_got/widgets/text.dart';
import 'package:flutter/material.dart';

class GroupMain extends StatefulWidget {
  final int groupId;
  const GroupMain({
    super.key,
    required this.groupId,
  });

  @override
  State<GroupMain> createState() => _GroupMainState();
}

class _GroupMainState extends State<GroupMain> {
  int memberState = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: GroupAppBar(),
      ),
      body: SingleChildScrollView(
          child: FutureBuilder(
        future: GroupProvider().readGroupDetail(widget.groupId, ''),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final GroupDetailModel data = snapshot.data!;
            memberState = data.memberState;
            return ColWithPadding(
              vertical: 30,
              horizontal: 30,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                groupHeader(data),
                const SizedBox(height: 20),
                data.memberState != 0
                    ? CustomButton(
                        onPressed: toOtherPage(
                          context,
                          page: data.bingoId != 0
                              ? const BingoDetail()
                              : const BingoForm(),
                        ),
                        content: data.bingoId != 0 ? '내 빙고 보기' : '내 빙고 만들기',
                      )
                    : const SizedBox(),
                ShowContentBox(
                    contentTitle: '설명', content: data.description ?? ''),
                ShowContentBox(contentTitle: '규칙', content: data.rule ?? ''),
                // groupRankTop3(context, data),
              ],
            );
          }
          return const Center(child: CustomText(content: '정보를 불러오는 중입니다'));
        },
      )),
      bottomNavigationBar: BottomBar(isMember: memberState != 0),
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
          for (int i = 0; i < 3; i += 1)
            RankListItem(
              rank: i + 1,
              rankListItem: data.rank,
              isMember: memberState != 0,
            ),
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

//* 그룹 내 달성률 랭킹
class GroupRank extends StatefulWidget {
  final int groupId;
  final bool isMember;
  const GroupRank({required this.groupId, required this.isMember, super.key});

  @override
  State<GroupRank> createState() => _GroupRankState();
}

class _GroupRankState extends State<GroupRank> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GroupAppBar(onlyBack: true),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child:
                    CustomText(content: '그룹 랭킹', fontSize: FontSize.titleSize),
              ),
              FutureBuilder(
                future: GroupProvider().groupRank(widget.groupId),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return groupRankList(snapshot);
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomBar(isMember: true),
    );
  }

  ListView groupRankList(AsyncSnapshot<RankList> snapshot) {
    return ListView.separated(
      itemBuilder: (context, index) {
        var rankListItem = snapshot.data![index];
        return RankListItem(
          rank: index + 1,
          rankListItem: rankListItem,
          isMember: widget.isMember,
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 20),
      itemCount: snapshot.data!.length,
    );
  }
}

//* 그룹 관리 페이지
class GroupAdmin extends StatelessWidget {
  const GroupAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AdminAppBar(),
      body: GroupAdminTabBar(),
      bottomNavigationBar: BottomBar(
        isMember: true,
      ),
    );
  }
}
