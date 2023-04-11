import 'package:bin_got/models/user_info_model.dart';
import 'package:bin_got/providers/user_info_provider.dart';
import 'package:bin_got/utilities/image_icon_utils.dart';
import 'package:bin_got/utilities/style_utils.dart';
import 'package:bin_got/utilities/type_def_utils.dart';
import 'package:bin_got/widgets/box_container.dart';
import 'package:bin_got/widgets/button.dart';
import 'package:bin_got/widgets/date_picker.dart';
import 'package:bin_got/widgets/icon.dart';
import 'package:bin_got/widgets/image.dart';
import 'package:bin_got/widgets/list.dart';
import 'package:bin_got/widgets/row_col.dart';
import 'package:bin_got/widgets/text.dart';
import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:flutter/material.dart';

//* 빙고 생성 탭
class BingoTabBar extends StatefulWidget {
  final List<dynamic> selected;
  final void Function(int tabIndex, int i) changeSelected;
  const BingoTabBar(
      {super.key, required this.selected, required this.changeSelected});

  @override
  State<BingoTabBar> createState() => _BingoTabBarState();
}

class _BingoTabBarState extends State<BingoTabBar> {
  @override
  Widget build(BuildContext context) {
    const List<IconData> iconList = [colorIcon, drawIcon, fontIcon, emojiIcon];
    return CustomBoxContainer(
      hasRoundEdge: false,
      child: ContainedTabBarView(
        tabs: [
          for (IconData icon in iconList) Tab(child: CustomIcon(icon: icon)),
        ],
        views: [paintTab(), optionOrFontTab(1), optionOrFontTab(2), checkTab()],
      ),
    );
  }

  // * 배경 화면
  Row paintTab() {
    var page = 0;

    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        for (int i = 2 * page; i < 2 * page + 2; i += 1)
          GestureDetector(
            onTap: () => widget.changeSelected(0, i),
            child: ModifiedImage(
              image: backgroundList[i],
              boxShadow: widget.selected[0] == i ? [selectedShadow] : null,
            ),
          ),
      ],
    );
  }

  //* 빙고칸 & font 변경
  Column optionOrFontTab(int index) {
    StringList gapList = ['좁은', '보통', '넓은'];
    String convertedColor() => widget.selected[1][2] ? '흰색' : '검은색';
    String presentGap(int i) => gapList[i];

    StringList optionList = [
      '둥근 모서리 적용',
      '테두리 적용',
      '${convertedColor()}으로 변경',
      '${presentGap(widget.selected[1][3])} 간격'
    ];
    BoxShadowList applyBoxShadow(int i, int j) {
      int elementIdx = 2 * i + j;
      if (index == 1) {
        // return [defaultShadow];
        if (elementIdx == 3) {
          return [defaultShadow];
        }
        return widget.selected[index][elementIdx]
            ? const [selectedShadow]
            : const [defaultShadow];
      }
      return widget.selected[index] != elementIdx
          ? const [defaultShadow]
          : const [selectedShadow];
    }

    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        for (int i = 0; i < index + 1; i += 1)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              for (int j = 0; j < 2; j += 1)
                CustomBoxContainer(
                  onTap: () => widget.changeSelected(index, 2 * i + j),
                  width: 150,
                  height: 40,
                  boxShadow: applyBoxShadow(i, j),
                  child: Center(
                    child: CustomText(
                      content: index == 2
                          ? showedFont[2 * i + j]
                          : optionList[2 * i + j],
                      font: index == 2 ? matchFont[2 * i + j] : 'RIDIBatang',
                    ),
                  ),
                  // width: MediaQuery.of(context).size.width,
                ),
            ],
          ),
      ],
    );
  }

  Column checkTab() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (int i = 0; i < 3; i += 1)
              CustomIconButton(
                onPressed: () => widget.changeSelected(3, i),
                icon: iconList[i],
                size: 70,
                color: i == widget.selected[3] ? greenColor : blackColor,
              ),
          ],
        ),
      ],
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

//* 메인 페이지 탭
class MyTabBar extends StatefulWidget {
  const MyTabBar({super.key});

  @override
  State<MyTabBar> createState() => _MyTabBarState();
}

class _MyTabBarState extends State<MyTabBar> {
  late Future<MainTabModel> tabData;
  List<List<StringList>> buttonOptions = [
    [
      ['그룹명 순', '그룹명 역순'],
      ['전체', '진행 중', '완료'],
      ['캘린더로 보기', '리스트로 보기']
    ],
    [
      ['최신순', '오래된순'],
      ['전체', '진행 중', '완료'],
      ['', '']
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
    tabData = UserInfoProvider().getMainTabData();
  }

  @override
  Widget build(BuildContext context) {
    return CustomTextTabBar(
      tabTitles: const ['내 그룹', '내 빙고'],
      onChange: changeTab,
      upperView: RowWithPadding(
        vertical: 20,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          for (int i = 0; i < 3; i += 1)
            Center(
              child: CustomTextButton(
                content: presentOptions[i][idxList[presentIdx][i]],
                fontSize: FontSize.smallSize,
                onTap: () => changeIdx(i),
              ),
            ),
        ],
      ),
      listItems: [
        [
          FutureBuilder(
            future: tabData,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final hasNotGroup = snapshot.data!.hasNotGroup;
                return Column(
                  children: [
                    hasNotGroup
                        ? Column(children: const [
                            CustomText(
                              center: true,
                              content:
                                  '아직 가입된 그룹이 없어요.\n그룹에 가입하거나\n그룹을 생성해보세요.',
                              height: 1.7,
                            ),
                            SizedBox(
                              height: 70,
                            ),
                            CustomText(
                              content: '추천그룹',
                              fontSize: FontSize.titleSize,
                            ),
                          ])
                        : const SizedBox(),
                    groupList(snapshot.data!.groups, hasNotGroup)
                  ],
                );
              }
              return const CustomText(content: '그룹 정보를 불러오는 중입니다');
            },
          )
        ],
        [
          FutureBuilder(
            future: tabData,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final bingos = snapshot.data!.bingos;
                if (bingos.isNotEmpty) {
                  return bingoList(bingos);
                }
                return const CustomText(
                  center: true,
                  height: 1.7,
                  content: '아직 생성한 빙고가 없어요.\n그룹 내에서\n빙고를 생성해보세요.',
                );
              }
              return const CustomText(content: '빙고 정보를 불러오는 중입니다');
            },
          )
        ]
      ],
    );
  }

  ListView bingoList(MyBingoList bingos) {
    final length = bingos.length;
    final quot = length ~/ 2;
    final remain = length % 2;
    return ListView.builder(
        shrinkWrap: true,
        itemCount: quot + 1,
        itemBuilder: (context, index) {
          var bingo = bingos[index];
          return BingoGallery(
            bingo: bingo,
          );
        });
  }

  Widget groupList(MyGroupList groups, bool isSearchMode) {
    if (idxList[0][2] == 0) {
      return ListView.builder(
          shrinkWrap: true,
          itemCount: groups.length,
          itemBuilder: (context, index) {
            var group = groups[index];
            return GroupListItem(
              isSearchMode: isSearchMode,
              groupInfo: group,
            );
          });
    }
    return const DatePicker();
  }

  // Column emptyGroup() {
  //   return Column(
  //     children: [
  //       const Center(
  //         child: CustomText(
  //           center: true,
  //           fontSize: FontSize.titleSize,
  //           content: '아직 가입된 그룹이 없어요.\n그룹에 가입하거나\n그룹을 생성해보세요.',
  //         ),
  //       ),
  //       Center(
  //         child: FutureBuilder(
  //           future: GroupProvider().recommendGroupList(),
  //           builder: (context, snapshot) {
  //             if (snapshot.hasData) {
  //               if (snapshot.data!.isNotEmpty) {
  //                 return ColWithPadding(
  //                   children: [
  //                     const CustomText(content: '추천 그룹'),
  //                     ListView.builder(
  //                         shrinkWrap: true,
  //                         itemCount: snapshot.data!.length,
  //                         itemBuilder: (context, index) {
  //                           var group = snapshot.data![index];
  //                           return GroupListItem(
  //                             isSearchMode: false,
  //                             groupInfo: group,
  //                           );
  //                         })
  //                   ],
  //                 );
  //               }
  //               return const CustomText(
  //                 content: '추천 그룹을 불러올 수 없습니다.\n 직접 그룹을 만들어보세요',
  //               );
  //             }
  //             return const CircularProgressIndicator();
  //           },
  //         ),
  //       )
  //     ],
  //   );
  // }
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
