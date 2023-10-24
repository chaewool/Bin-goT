import 'package:bin_got/models/group_model.dart';
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
import 'package:bin_got/widgets/row_col.dart';
import 'package:bin_got/widgets/scroll.dart';
import 'package:bin_got/widgets/text.dart';
import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//? 탭 바

//* 빙고 생성 탭
class BingoTabBar extends StatefulWidget {
  const BingoTabBar({super.key});

  @override
  State<BingoTabBar> createState() => _BingoTabBarState();
}

class _BingoTabBarState extends State<BingoTabBar> {
  final explainText = [
    '화면 배경 사진 (선택)',
    '빙고판 내부 설정 (필수)',
    '빙고판 내부 글씨체 (필수)',
    '목표 달성 시, 표시되는 아이콘 (필수)'
  ];
  int page = 0;

  @override
  Widget build(BuildContext context) {
    const List<IconData> iconList = [colorIcon, drawIcon, fontIcon, emojiIcon];
    return CustomBoxContainer(
      hasRoundEdge: false,
      child: ContainedTabBarView(
        tabBarProperties: const TabBarProperties(indicatorColor: palePinkColor),
        tabs: [
          for (IconData icon in iconList) Tab(child: CustomIcon(icon: icon)),
        ],
        views: List.generate(4, (index) => tabViews(index)),
        onChange: (index) {
          final isCheckTheme = context.read<GlobalBingoProvider>().isCheckTheme;
          if (index == 3) {
            if (!isCheckTheme) {
              setIsCheckTheme(context, true);
            }
          } else if (isCheckTheme) {
            setIsCheckTheme(context, false);
          }
        },
      ),
    );
  }

  Column tabViews(int index) {
    Widget? widget;
    WidgetList? widgetList;
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.spaceEvenly;
    switch (index) {
      case 0:
        widget = paintTab();
        break;
      case 3:
        widget = checkTab();
        break;
      default:
        widgetList = optionOrFontTab(index);
    }
    return Column(
      mainAxisAlignment: mainAxisAlignment,
      mainAxisSize: MainAxisSize.max,
      children: [
        CustomText(
          content: explainText[index],
          color: greyColor,
          fontSize: FontSize.smallSize,
        ),
        if (widgetList != null) ...widgetList,
        if (widget != null) widget,
      ],
    );
  }

  // * 배경 화면
  Row paintTab() {
    int totalPages = backgroundList.length ~/ 2;
    void moveTo(bool toRight) {
      if (toRight) {
        if (page < totalPages - 1) {
          setState(() {
            page = page + 1;
          });
        }
      } else if (page > 0) {
        setState(() {
          page = page - 1;
        });
      }
    }

    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        CustomIconButton(
          onPressed: () => moveTo(false),
          icon: leftIcon,
          size: 40,
          color: page > 0 ? palePinkColor : greyColor,
        ),
        for (int i = 2 * page; i < 2 * page + 2; i += 1)
          GestureDetector(
            onTap: () => changeBingoData(context, 0, i),
            child: ModifiedImage(
              image: backgroundList[i],
              boxShadow: watchBackground(context, false) == i
                  ? [selectedShadow]
                  : null,
            ),
          ),
        CustomIconButton(
          onPressed: () => moveTo(true),
          icon: rightIcon,
          size: 40,
          color: page < totalPages - 1 ? palePinkColor : greyColor,
        ),
      ],
    );
  }

  //* 빙고칸 & font 변경
  WidgetList optionOrFontTab(int index) {
    StringList gapList = ['없음', '보통', '넓음'];

    StringList optionList = [
      '둥근 모서리 적용',
      '테두리 적용',
      '${watchHasBlackBox(context, false) ? '흰색' : '검은색'}으로 변경',
      '칸 여백 ${gapList[watchGap(context, false)!]}'
    ];

    bool isSelected(int i, int j) {
      final elementIdx = 2 * i + j;
      switch (index) {
        case 1:
          final keyList = ['has_round_edge', 'has_border'];
          return i == 0 && getBingoData(context, false)[keyList[j]];
        default:
          return watchFont(context, false) == elementIdx;
      }
    }

    return [
      for (int i = 0; i < index + 1; i += 1)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            for (int j = 0; j < 2; j += 1)
              CustomBoxContainer(
                onTap: () => changeBingoData(context, index, 2 * i + j),
                width: 150,
                height: 40,
                color: isSelected(i, j) ? paleRedColor : whiteColor,
                borderColor: isSelected(i, j) ? paleRedColor : greyColor,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: CustomText(
                      content: index == 2
                          ? showedFont[2 * i + j]
                          : optionList[2 * i + j],
                      font: index == 2 ? matchFont[2 * i + j] : 'RIDIBatang',
                      color: isSelected(i, j) ? whiteColor : blackColor,
                    ),
                  ),
                ),
              ),
          ],
        ),
    ];
  }

  Row checkTab() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        for (int i = 0; i < 3; i += 1)
          CustomIconButton(
            onPressed: () => changeBingoData(context, 3, i),
            icon: iconList[i],
            size: 70,
            color:
                i == watchCheckIcon(context, false) ? paleRedColor : greyColor,
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
    return CustomTextTabBar(
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: ListView.separated(
                                shrinkWrap: true,
                                itemCount: applicants.length,
                                itemBuilder: (context, index) {
                                  var applicant = applicants[index];
                                  return MemberList(
                                    id: applicant.id,
                                    bingoId: applicant.bingoId,
                                    nickname: applicant.username,
                                    badge: applicant.badgeId,
                                    isMember: false,
                                  );
                                },
                                separatorBuilder: (context, index) =>
                                    const SizedBox(height: 10),
                              ),
                            )
                          : const Padding(
                              padding: EdgeInsets.only(top: 20),
                              child: CustomText(content: '자동 가입 그룹입니다.'),
                            ),
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
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: members.length,
                          itemBuilder: (context, index) {
                            final member = members[index];
                            return MemberList(
                              id: member.id,
                              bingoId: member.bingoId,
                              nickname: member.username,
                              badge: member.badgeId,
                              isMember: true,
                            );
                          },
                        ),
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
        tabBarProperties: const TabBarProperties(indicatorColor: paleRedColor),
        tabs: [
          for (String tabTitle in tabTitles)
            Tab(
              child:
                  CustomText(content: tabTitle, fontSize: FontSize.largeSize),
            ),
        ],
        views: [
          for (int i = 0; i < tabTitles.length; i += 1)
            Column(
              children: [
                upperView ?? const SizedBox(height: 10),
                for (Widget listItem in listItems[i]) listItem
              ],
            ),
        ],
        onChange: onChange,
      ),
    );
  }
}

//* main tab bar
class MainTabBar extends StatefulWidget {
  const MainTabBar({
    super.key,
  });

  @override
  State<MainTabBar> createState() => _MainTabBarState();
}

class _MainTabBarState extends State<MainTabBar> {
  final groupController = ScrollController();
  final bingoController = ScrollController();
  final pageController = PageController();
  int tabBarIndex = 0;
  StringList titleList = ['내 그룹', '내 빙고'];
  MyGroupList groupTabData = [];
  bool hasNotGroup = false;
  MyBingoList bingoTabData = [];
  List<StringList> buttonOptions = [
    ['종료일 ▼', '종료일 ▲'],
    ['전체', '진행 중', '완료'],
  ];

  List<IntList> idxList = [
    [1, 1],
    [1, 1]
  ];

  //* 정렬, 필터
  void changeIdx(int idx) {
    if (idxList[tabBarIndex][idx] < buttonOptions[idx].length - 1) {
      setState(() {
        idxList[tabBarIndex][idx] += 1;
      });
    } else {
      setState(() {
        idxList[tabBarIndex][idx] = 0;
      });
    }

    if (tabBarIndex == 0) {
      //* 그룹이 있을 경우에만 적용
      if (idx == 1 || groupTabData.isNotEmpty) {
        initLoadingData(context, 1);
        setLastId(context, 1, 0);
        groupTabData.clear();
        setGroupTabData();
      }
    } else if (idx == 1 || bingoTabData.isNotEmpty) {
      initLoadingData(context, 2);
      setLastId(context, 2, 0);
      bingoTabData.clear();
      setBingoTabData();
    }
  }

  //* tab 변경
  void changeTab(int index) {
    if (tabBarIndex != index) {
      setState(() {
        tabBarIndex = index;
      });
      pageController.jumpToPage(index);
      if (index == 0) {
        initLoadingData(context, 1);
        setLastId(context, 1, 0);
        groupTabData.clear();
        setGroupTabData();
      } else {
        initLoadingData(context, 2);
        setLastId(context, 2, 0);
        bingoTabData.clear();
        setBingoTabData();
      }
    }
  }

  FutureBool setGroupTabData([bool more = true]) {
    final answer = UserInfoProvider().getMainGroupData({
      'order': idxList[0][0],
      'filter': idxList[0][1],
      'idx': getLastId(context, 1),
    }).then((groupData) {
      setState(() {
        if (groupData.groups.isNotEmpty) {
          setState(() {
            groupTabData.addAll(groupData.groups);
          });
        }
        setState(() {
          hasNotGroup = groupData.hasNotGroup;
        });
      });
      setLoading(context, false);
      if (more) {
        setWorking(context, false);
        setAdditional(context, false);
      }

      return true;
    }).catchError((error) {
      if (mounted) {
        showErrorModal(context, '내 그룹 오류', '내 그룹 데이터를 불러오는 데 실패했습니다');
      }
      return false;
    });
    return Future.value(answer);
  }

  void setBingoTabData([bool more = true]) {
    UserInfoProvider().getMainBingoData({
      'order': idxList[1][0],
      'filter': idxList[1][1],
      'idx': getLastId(context, 2),
    }).then((bingoData) {
      if (bingoData.isNotEmpty) {
        setState(() {
          bingoTabData.addAll(bingoData);
        });
      }
      setLoading(context, false);
      if (more) {
        setWorking(context, false);
        setAdditional(context, false);
      }
    }).catchError((_) {
      if (mounted) {
        showErrorModal(context, '내 빙고 오류', '내 빙고 데이터를 불러오는 데 실패했습니다');
      }
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initLoadingData(context, 1);
      if (getLoading(context)) {
        setGroupTabData(false);
      }

      groupController.addListener(
        () {
          if (groupController.position.pixels >=
              groupController.position.maxScrollExtent * 0.9) {
            if (getLastId(context, 1) != -1) {
              if (!getWorking(context)) {
                setWorking(context, true);
                afterFewSec(() {
                  if (!getAdditional(context)) {
                    setAdditional(context, true);
                    if (getAdditional(context)) {
                      setGroupTabData();
                    }
                  }
                }, 2000);
              }
            }
          }
        },
      );

      bingoController.addListener(
        () {
          if (bingoController.position.pixels >=
              bingoController.position.maxScrollExtent * 0.9) {
            if (getLastId(context, 2) != -1) {
              if (!getWorking(context)) {
                setWorking(context, true);
                afterFewSec(() {
                  if (!getAdditional(context)) {
                    setAdditional(context, true);
                    if (getAdditional(context)) {
                      setBingoTabData();
                    }
                  }
                }, 2000);
              }
            }
          }
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomBoxContainer(
      child: Column(
        children: [
          CustomBoxContainer(
            gradient:
                const LinearGradient(colors: [palePinkColor, paleRedColor]),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
            child: Column(
              children: [
                RowWithPadding(
                  vertical: 20,
                  min: true,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    for (int i = 0; i < 2; i += 1)
                      Flexible(
                        child: GestureDetector(
                          onTap: () => changeTab(i),
                          child: Center(
                            child: CustomText(
                              content: titleList[i],
                              bold: true,
                              color: i == tabBarIndex
                                  ? blackColor
                                  : greyColor.withOpacity(0.5),
                              fontSize: FontSize.titleSize,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 5, 20, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      for (int i = 0; i < 2; i += 1)
                        Center(
                          child: CustomTextButton(
                            transparent: true,
                            content: buttonOptions[i][idxList[tabBarIndex][i]],
                            fontSize: FontSize.smallSize,
                            onTap: () => changeIdx(i),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: pageController,
              children: [
                myGroupTabBar(),
                myBingoTabBar(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  BingoInfiniteScroll myBingoTabBar() {
    return BingoInfiniteScroll(
      controller: bingoController,
      data: bingoTabData,
    );
  }

  GroupInfiniteScroll myGroupTabBar() {
    return GroupInfiniteScroll(
      controller: hasNotGroup ? ScrollController() : groupController,
      data: groupTabData,
      mode: 1,
      emptyWidget: const Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomText(
            center: true,
            content: '조건을 만족하는 그룹이 없어요.',
            height: 1.7,
          ),
        ],
      ),
      hasNotGroupWidget: hasNotGroup
          ? const ColWithPadding(
              vertical: 20,
              children: [
                CustomText(
                  center: true,
                  content: '아직 가입된 그룹이 없어요.\n그룹에 가입하거나\n그룹을 생성해보세요.',
                  height: 1.7,
                ),
                SizedBox(
                  height: 40,
                ),
                CustomText(
                  content: '추천그룹',
                  fontSize: FontSize.titleSize,
                ),
              ],
            )
          : null,
    );
  }
}
