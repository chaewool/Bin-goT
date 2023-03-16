import 'package:bin_got/pages/bingo_detail_page.dart';
import 'package:bin_got/pages/bingo_form_page.dart';
import 'package:bin_got/utilities/global_func.dart';
import 'package:bin_got/utilities/style_utils.dart';
import 'package:bin_got/widgets/app_bar.dart';
import 'package:bin_got/widgets/bottom_bar.dart';
import 'package:bin_got/widgets/box_container.dart';
import 'package:bin_got/widgets/button.dart';
import 'package:bin_got/widgets/list.dart';
import 'package:bin_got/widgets/row_col.dart';
import 'package:bin_got/widgets/tab_bar.dart';
import 'package:bin_got/widgets/text.dart';
import 'package:flutter/material.dart';

class GroupMain extends StatelessWidget {
  final String groupName, start, end, explain, rule;
  final int cnt, headCount, groupId;
  final bool isMember, hasBingo;
  const GroupMain({
    super.key,
    required this.groupId,
    required this.groupName,
    required this.start,
    required this.end,
    required this.cnt,
    required this.headCount,
    this.explain = '그룹 설명이 들어갑니다',
    this.rule = '그룹 규칙이 들어갑니다',
    required this.isMember,
    this.hasBingo = false,
  });

  @override
  Widget build(BuildContext context) {
    const achievementList = [100, 90, 85];
    const nicknameList = ['조코', '아아', '닉넴'];

    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: GroupAppBar(),
      ),
      body: SingleChildScrollView(
        child: ColWithPadding(
          vertical: 30,
          horizontal: 30,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(content: groupName, fontSize: FontSize.titleSize),
                const SizedBox(height: 10),
                CustomText(content: '참여 인원 $cnt/$headCount'),
                const SizedBox(height: 10),
                CustomText(content: '$start ~ $end'),
              ],
            ),
            const SizedBox(height: 20),
            isMember
                ? CustomButton(
                    onPressed: toOtherPage(
                      context: context,
                      page: hasBingo ? const BingoDetail() : const BingoForm(),
                    ),
                    content: hasBingo ? '내 빙고 보기' : '내 빙고 만들기')
                : const SizedBox(),
            ShowContentBox(contentTitle: '설명', content: explain),
            ShowContentBox(contentTitle: '규칙', content: rule),
            Padding(
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
                          onPressed: toOtherPage(
                              context: context,
                              page: const GroupRank(
                                  cnt: 3,
                                  achievementList: achievementList,
                                  nicknameList: nicknameList)),
                          child: const CustomText(
                            content: '전체보기',
                            fontSize: FontSize.smallSize,
                          ))
                    ],
                  ),
                  for (int i = 0; i < 3; i += 1)
                    RankList(
                      rank: i + 1,
                      nickname: nicknameList[i],
                      achievement: achievementList[i],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomBar(isMember: isMember),
    );
  }
}

//* 그룹 내 달성률 랭킹
class GroupRank extends StatelessWidget {
  final int cnt;
  final List<int> achievementList;
  final List<String> nicknameList;
  const GroupRank({
    super.key,
    required this.cnt,
    required this.achievementList,
    required this.nicknameList,
  });

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
              for (int i = 0; i < cnt; i += 1)
                RankList(
                    rank: i + 1,
                    nickname: nicknameList[i],
                    achievement: achievementList[i])
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomBar(isMember: true),
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
