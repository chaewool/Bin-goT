import 'package:bin_got/models/group_model.dart';
import 'package:bin_got/models/user_info_model.dart';
import 'package:bin_got/pages/input_password_page.dart';
import 'package:bin_got/providers/group_provider.dart';
import 'package:bin_got/providers/root_provider.dart';
import 'package:bin_got/providers/user_info_provider.dart';
import 'package:bin_got/utilities/global_func.dart';
import 'package:bin_got/utilities/image_icon_utils.dart';
import 'package:bin_got/utilities/style_utils.dart';
import 'package:bin_got/utilities/type_def_utils.dart';
import 'package:bin_got/widgets/accordian.dart';
import 'package:bin_got/widgets/container.dart';
import 'package:bin_got/widgets/button.dart';
import 'package:bin_got/widgets/icon.dart';
import 'package:bin_got/widgets/image.dart';
import 'package:bin_got/widgets/list.dart';
import 'package:bin_got/widgets/row_col.dart';
import 'package:bin_got/widgets/text.dart';
import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//* 빙고 생성 탭
class BingoTabBar extends StatefulWidget {
  const BingoTabBar({super.key});

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
        onChange: (index) {
          final isCheckTheme = context.read<GlobalBingoProvider>().isCheckTheme;
          void setCheckTheme(bool value) =>
              context.read<GlobalBingoProvider>().setIsCheckTheme(value);
          if (index == 3) {
            if (!isCheckTheme) {
              setCheckTheme(true);
            }
          } else if (isCheckTheme) {
            setCheckTheme(false);
          }
        },
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
            onTap: () => changeBingoData(context, 0, i),
            child: ModifiedImage(
              image: backgroundList[i],
              boxShadow: getBackground(context) == i ? [selectedShadow] : null,
            ),
          ),
      ],
    );
  }

  //* 빙고칸 & font 변경
  Column optionOrFontTab(int index) {
    StringList gapList = ['좁은', '보통', '넓은'];

    StringList optionList = [
      '둥근 모서리 적용',
      '테두리 적용',
      '${getHasBlackBox(context) ? '흰색' : '검은색'}으로 변경',
      '${gapList[getGap(context)!]} 간격'
    ];

    BoxShadowList applyBoxShadow(int i, int j) {
      final elementIdx = 2 * i + j;
      switch (index) {
        case 1:
          final keyList = ['has_round_edge', 'has_border'];
          return i == 0 && getBingoData(context)[keyList[j]]
              ? [selectedShadow]
              : [defaultShadow];
        default:
          return getFont(context) != elementIdx
              ? const [defaultShadow]
              : const [selectedShadow];
      }
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
                  onTap: () => changeBingoData(context, index, 2 * i + j),
                  width: 150,
                  height: 40,
                  boxShadow: applyBoxShadow(i, j),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: CustomText(
                          content: index == 2
                              ? showedFont[2 * i + j]
                              : optionList[2 * i + j],
                          font:
                              index == 2 ? matchFont[2 * i + j] : 'RIDIBatang',
                        ),
                      ),
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
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            for (int i = 0; i < 3; i += 1)
              CustomIconButton(
                onPressed: () => changeBingoData(context, 3, i),
                icon: iconList[i],
                size: 70,
                color: i == getCheckIcon(context) ? greenColor : blackColor,
              ),
          ],
        ),
      ],
    );
  }
}

//* 그룹 관리 탭
class GroupAdminTabBar extends StatefulWidget {
  final int groupId;
  const GroupAdminTabBar({
    super.key,
    required this.groupId,
  });

  @override
  State<GroupAdminTabBar> createState() => _GroupAdminTabBarState();
}

class _GroupAdminTabBarState extends State<GroupAdminTabBar> {
  late Future<GroupAdminTabModel> tabData;
  int presentIdx = 0;

  @override
  void initState() {
    super.initState();
    tabData = GroupProvider().getAdminTabData(widget.groupId);
  }

  void changeTab(int index) {
    if (presentIdx != index) {
      setState(() {
        presentIdx = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: CustomTextTabBar(
        tabTitles: const ['가입 신청', '참여자'],
        onChange: changeTab,
        listItems: [
          [
            SingleChildScrollView(
              child: FutureBuilder(
                future: tabData,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final needAuth = snapshot.data!.needAuth;
                    final applicants = snapshot.data!.applicants;
                    return Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        needAuth
                            ? Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                                child: ListView.separated(
                                  shrinkWrap: true,
                                  itemCount: applicants.length,
                                  itemBuilder: (context, index) {
                                    var applicant = applicants[index];
                                    return MemberList(
                                      id: applicant.id,
                                      bingoId: applicant.bingoId,
                                      nickname: applicant.username,
                                      isMember: false,
                                    );
                                  },
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(
                                    height: 10,
                                  ),
                                ),
                              )
                            : const CustomText(content: '자동 가입 그룹입니다.'),
                      ],
                    );
                  }
                  return const CustomText(content: '정보를 불러오는 중입니다');
                },
              ),
            ),
          ],
          [
            SingleChildScrollView(
              child: FutureBuilder(
                future: tabData,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final members = snapshot.data!.members;
                    return Column(
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: members.length,
                          itemBuilder: (context, index) {
                            var member = members[index];
                            return MemberList(
                              id: member.id,
                              bingoId: member.bingoId,
                              nickname: member.username,
                              isMember: true,
                            );
                          },
                        )
                      ],
                    );
                  }
                  return const CustomText(content: '정보를 불러오는 중입니다');
                },
              ),
            ),
          ],
        ],
      ),
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
  late Future<MainGroupListModel> groupTabData;
  List<List<StringList>> buttonOptions = [
    [
      ['종료일 ▼', '종료일 ▼'],
      ['전체', '진행 중', '완료'],
      ['캘린더로 보기', '리스트로 보기']
    ],
    [
      ['종료일 ▼', '종료일 ▼'],
      ['전체', '진행 중', '완료'],
      ['', '']
    ]
  ];
  late List<StringList> presentOptions;
  late int presentIdx;

  List<IntList> idxList = [
    [1, 0, 0],
    [1, 0, 0]
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
    groupTabData = UserInfoProvider().getMainGroupData({
      'filter': 1,
      'order': 0,
      'page': 1,
    });
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
          SingleChildScrollView(
            child: CustomBoxContainer(
              height: MediaQuery.of(context).size.height,
              color: backgroundColor,
              child: FutureBuilder(
                future: groupTabData,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final hasNotGroup = snapshot.data!.hasNotGroup;
                    return Column(
                      children: [
                        hasNotGroup
                            ? Column(children: [
                                const CustomText(
                                  center: true,
                                  content:
                                      '아직 가입된 그룹이 없어요.\n그룹에 가입하거나\n그룹을 생성해보세요.',
                                  height: 1.7,
                                ),
                                const SizedBox(
                                  height: 70,
                                ),
                                GestureDetector(
                                  onTap: toOtherPage(context,
                                      page: const InputPassword(
                                        groupId: 1,
                                        isPublic: true,
                                      )),
                                  child: const CustomText(
                                    content: '추천그룹',
                                    fontSize: FontSize.titleSize,
                                  ),
                                ),
                              ])
                            : const SizedBox(),
                        groupList(snapshot.data!.groups, hasNotGroup)
                      ],
                    );
                  }
                  return const CustomText(content: '그룹 정보를 불러오는 중입니다');
                },
              ),
            ),
          )
        ],
        [
          FutureBuilder(
            future: UserInfoProvider().getMainBingoData({
              'filter': 1,
              'order': 0,
              'page': 1,
            }),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final bingos = snapshot.data!;
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
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Flexible(
                child: BingoGallery(
                  bingo: bingos[index * 2],
                ),
              ),
              Flexible(
                child: index != quot || remain == 0
                    ? BingoGallery(
                        bingo: bingos[index * 2 + 1],
                      )
                    : const SizedBox(),
              )
            ],
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
    return const SizedBox();
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
        tabBarProperties: const TabBarProperties(indicatorColor: greenColor),
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
