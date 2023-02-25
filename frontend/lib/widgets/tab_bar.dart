import 'package:bin_got/utilities/image_icon_utils.dart';
import 'package:bin_got/utilities/style_utils.dart';
import 'package:bin_got/utilities/type_def_utils.dart';
import 'package:bin_got/widgets/button.dart';
import 'package:bin_got/widgets/icon.dart';
import 'package:bin_got/widgets/list.dart';
import 'package:bin_got/widgets/text.dart';
import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:flutter/material.dart';

//* 빙고 생성 탭
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
class MyPageTabBar extends StatefulWidget {
  const MyPageTabBar({super.key});

  @override
  State<MyPageTabBar> createState() => _MyPageTabBarState();
}

class _MyPageTabBarState extends State<MyPageTabBar> {
  List<StringList> buttonOptions = [
    ['그룹명 순', '그룹명 역순'],
    ['전체', '진행 중', '완료'],
    ['캘린더로 보기', '리스트로 보기']
  ];
  IntList idxList = [0, 0, 0];
  void changeIdx(int idx) {
    if (idxList[idx] < buttonOptions[idx].length - 1) {
      setState(() {
        idxList[idx] += 1;
      });
    } else {
      setState(() {
        idxList[idx] = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomTextTabBar(
      tabTitles: const ['내 그룹', '내 빙고'],
      upperView: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            for (int i = 0; i < 3; i += 1)
              CustomTextButton(
                content: buttonOptions[i][idxList[i]],
                fontSize: FontSize.smallSize,
                onTap: () => changeIdx(i),
              ),
          ],
        ),
      ),
      listItems: [
        [
          for (int i = 0; i < 10; i += 1)
            idxList[2] == 0
                ? const GroupList(isSearchMode: true)
                : const SizedBox()
        ],
        [for (int i = 0; i < 10; i += 1) const GroupList(isSearchMode: false)]
      ],
    );
  }
}

//* tab bar 기본 틀
class CustomTextTabBar extends StatelessWidget {
  final StringList tabTitles;
  final List<WidgetList> listItems;
  final Widget? upperView;
  const CustomTextTabBar(
      {super.key,
      required this.tabTitles,
      required this.listItems,
      this.upperView});

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
                children: [
                  upperView ?? const SizedBox(),
                  for (Widget listItem in listItems[i]) listItem
                ],
              ),
            ),
        ],
        onChange: (index) => {},
      ),
    );
  }
}
