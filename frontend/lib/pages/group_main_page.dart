import 'package:bin_got/pages/bingo_form_page.dart';
import 'package:bin_got/utilities/style_utils.dart';
import 'package:bin_got/widgets/app_bar.dart';
import 'package:bin_got/widgets/bottom_bar.dart';
import 'package:bin_got/widgets/box_container.dart';
import 'package:bin_got/widgets/button.dart';
import 'package:bin_got/widgets/list.dart';
import 'package:bin_got/widgets/text.dart';
import 'package:flutter/material.dart';

class GroupMain extends StatelessWidget {
  String groupName, start, end, explain, rule;
  int cnt, headcount;
  GroupMain({
    super.key,
    // required this.groupName,
    // required this.start,
    // required this.end,
    // required this.cnt,
    // required this.headcount,
    this.groupName = '빙고 채울 분들!',
    this.start = '2023년 1월 1일',
    this.end = '2023년 12월 31일',
    this.cnt = 5,
    this.headcount = 10,
    this.explain = '그룹 설명이 들어갑니다',
    this.rule = '그룹 규칙이 들어갑니다',
  });

  @override
  Widget build(BuildContext context) {
    const achievementList = [100, 90, 85];
    const nicknameList = ['조코', '아아', '닉넴'];
    void toCreateBingo() {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const BingoForm()));
    }

    void toGroupRank() {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => GroupRank(
                  cnt: 3,
                  achievementList: achievementList,
                  nicknameList: nicknameList)));
    }

    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: GroupAppBar(),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(content: groupName, fontSize: FontSize.titleSize),
                  CustomText(
                      content: '참여 인원 $cnt/$headcount',
                      fontSize: FontSize.textSize),
                  CustomText(
                      content: '$start ~ $end', fontSize: FontSize.textSize),
                ],
              ),
              CustomButton(methodFunc: toCreateBingo, buttonText: '내 빙고 만들기'),
              ShowContentBox(contentTitle: '설명', content: explain),
              ShowContentBox(contentTitle: '규칙', content: rule),
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const CustomText(
                              content: '랭킹', fontSize: FontSize.textSize),
                          TextButton(
                              onPressed: toGroupRank,
                              child: const CustomText(
                                content: '전체보기',
                                fontSize: FontSize.smallSize,
                              ))
                        ],
                      ),
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
      ),
      bottomNavigationBar: const BottomBar(),
    );
  }
}

class GroupRank extends StatelessWidget {
  int cnt;
  List<int> achievementList;
  List<String> nicknameList;
  GroupRank({
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
      bottomNavigationBar: const BottomBar(),
    );
  }
}

class GroupAdmin extends StatelessWidget {
  const GroupAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AdminAppBar(),
      bottomNavigationBar: BottomBar(),
    );
  }
}
