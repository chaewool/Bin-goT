import 'package:bin_got/utilities/image_icon_utils.dart';
import 'package:bin_got/utilities/style_utils.dart';
import 'package:bin_got/utilities/type_def_utils.dart';
import 'package:bin_got/widgets/icon.dart';
import 'package:bin_got/widgets/list.dart';
import 'package:bin_got/widgets/text.dart';
import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:flutter/material.dart';

class BingoTabBar extends StatelessWidget {
  const BingoTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    const List<IconData> iconList = [colorIcon, drawIcon, fontIcon, emojiIcon];
    return Container(
      decoration: const BoxDecoration(),
      child: ContainedTabBarView(
        tabs: [
          for (IconData icon in iconList) Tab(icon: CustomIcon(icon: icon))
        ],
        views: [
          Container(color: Colors.red),
          Container(color: Colors.green),
          Container(color: Colors.amber),
          Container(color: Colors.black),
        ],
        onChange: (index) => {},
      ),
    );
  }
}

//* 그룹 관리 탭
class GroupAdminTabBar extends StatelessWidget {
  const GroupAdminTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomTextTabBar(tabTitles: const [
      '가입 신청',
      '참여자'
    ], listItems: [
      [
        for (int i = 0; i < 10; i += 1)
          MemberList(
            image: halfLogo,
            isMember: false,
            nickname: '조코링링링',
          )
      ],
      [
        for (int i = 0; i < 7; i += 1)
          MemberList(
            image: halfLogo,
            isMember: true,
            nickname: '조코링링링',
          )
      ]
    ]);
  }
}

//* 마이 페이지 탭
class MyPageTabBar extends StatelessWidget {
  const MyPageTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomTextTabBar(tabTitles: const [
      '내 그룹',
      '내 빙고'
    ], listItems: [
      [for (int i = 0; i < 10; i += 1) const GroupList(isSearchMode: true)],
      [for (int i = 0; i < 10; i += 1) const GroupList(isSearchMode: false)]
    ]);
  }
}

//* tab bar 기본 틀
class CustomTextTabBar extends StatelessWidget {
  final StringList tabTitles;
  final List<WidgetList> listItems;
  const CustomTextTabBar({
    super.key,
    required this.tabTitles,
    required this.listItems,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(),
      child: ContainedTabBarView(
        tabs: [
          for (String tabTitle in tabTitles)
            Tab(
              child:
                  CustomText(content: tabTitle, fontSize: FontSize.largeSize),
            ),
        ],
        views: [
          for (int i = 0; i < tabTitles.length; i += 1)
            SingleChildScrollView(
              child: Column(
                children: [for (Widget listItem in listItems[i]) listItem],
              ),
            ),
        ],
        onChange: (index) => {},
      ),
    );
  }
}
