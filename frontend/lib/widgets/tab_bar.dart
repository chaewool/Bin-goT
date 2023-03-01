import 'package:bin_got/utilities/image_icon_utils.dart';
import 'package:bin_got/utilities/style_utils.dart';
import 'package:bin_got/utilities/type_def_utils.dart';
import 'package:bin_got/widgets/box_container.dart';
import 'package:bin_got/widgets/button.dart';
import 'package:bin_got/widgets/date_picker.dart';
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
    return CustomBoxContainer(
      hasRoundEdge: false,
      child: ContainedTabBarView(
        tabs: [
          for (IconData icon in iconList)
            Tab(
              child: CustomIcon(icon: icon),
            ),
        ],
        views: [paintTab(), lineTab(), fontTab(), stickerTab()],
      ),
    );
  }

  SingleChildScrollView paintTab() {
    return SingleChildScrollView(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          for (int i = 0; i < 10; i += 1)
            CustomBoxContainer(
              hasRoundEdge: false,
              child: halfLogo,
            ),
        ],
      ),
    );
  }

  SingleChildScrollView lineTab() {
    return SingleChildScrollView(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          CustomBoxContainer(
            hasRoundEdge: false,
            child: halfLogo,
            // width: MediaQuery.of(context).size.width,
          ),
        ],
      ),
    );
  }

  SingleChildScrollView fontTab() {
    return SingleChildScrollView(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          CustomBoxContainer(
            hasRoundEdge: false,
            child: halfLogo,
            // width: MediaQuery.of(context).size.width,
          ),
        ],
      ),
    );
  }

  SingleChildScrollView stickerTab() {
    return SingleChildScrollView(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          CustomBoxContainer(
            hasRoundEdge: false,
            child: halfLogo,
            // width: MediaQuery.of(context).size.width,
          ),
        ],
      ),
    );
  }
}

//* 그룹 관리 탭
class GroupAdminTabBar extends StatelessWidget {
  const GroupAdminTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomTextTabBar(
      tabTitles: const ['가입 신청', '참여자'],
      listItems: [
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
            ),
        ],
      ],
    );
  }
}

//* 마이 페이지 탭
class MyPageTabBar extends StatefulWidget {
  const MyPageTabBar({super.key});

  @override
  State<MyPageTabBar> createState() => _MyPageTabBarState();
}

class _MyPageTabBarState extends State<MyPageTabBar> {
  List<List<StringList>> buttonOptions = [
    [
      ['그룹명 순', '그룹명 역순'],
      ['전체', '진행 중', '완료'],
      ['캘린더로 보기', '리스트로 보기']
    ],
    [
      ['최신순', '오래된순'],
      ['전체', '진행 중', '완료'],
      ['리스트로 보기', '갤러리로 보기']
    ]
  ];
  late List<StringList> presentOptions;
  late int presentIdx;

  List<IntList> idxList = [
    [0, 0, 0],
    [0, 0, 0]
  ];
  void changeIdx(int idx) {
    if (idxList[presentIdx][idx] < presentOptions[idx].length - 1) {
      setState(() {
        idxList[presentIdx][idx] += 1;
      });
    } else {
      setState(() {
        idxList[presentIdx][idx] = 0;
      });
    }
  }

  void changeTab(int index) {
    if (presentIdx != index) {
      setState(() {
        presentIdx = index;
        presentOptions = buttonOptions[presentIdx];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    presentOptions = buttonOptions[0];
    presentIdx = 0;
  }

  @override
  Widget build(BuildContext context) {
    return CustomTextTabBar(
      tabTitles: const ['내 그룹', '내 빙고'],
      onChange: changeTab,
      upperView: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            for (int i = 0; i < 3; i += 1)
              CustomTextButton(
                content: presentOptions[i][idxList[presentIdx][i]],
                fontSize: FontSize.smallSize,
                onTap: () => changeIdx(i),
              ),
          ],
        ),
      ),
      listItems: [
        [
          for (int i = 0; i < 10; i += 1)
            idxList[0][2] == 0
                ? const GroupList(isSearchMode: true)
                : const DatePicker()
        ],
        idxList[1][2] == 0
            ? [
                BingoGallery(bingoList: [
                  for (int k = 0; k < 10; k += 1)
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CustomBoxContainer(
                        width: 150,
                        height: 200,
                        color: greenColor,
                      ),
                    )
                ])
              ]
            : [
                for (int i = 0; i < 10; i += 1) const BingoList(),
              ]
      ],
    );
  }
}

//* tab bar 기본 틀
class CustomTextTabBar extends StatelessWidget {
  final StringList tabTitles;
  final List<WidgetList> listItems;
  final Widget? upperView;
  final void Function(int)? onChange;
  const CustomTextTabBar({
    super.key,
    required this.tabTitles,
    required this.listItems,
    this.upperView,
    this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return CustomBoxContainer(
      hasRoundEdge: false,
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
        onChange: onChange,
      ),
    );
  }
}
