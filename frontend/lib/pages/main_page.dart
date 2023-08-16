import 'package:bin_got/providers/user_info_provider.dart';
import 'package:bin_got/utilities/global_func.dart';
import 'package:bin_got/utilities/image_icon_utils.dart';
import 'package:bin_got/utilities/style_utils.dart';
import 'package:bin_got/utilities/type_def_utils.dart';
import 'package:bin_got/widgets/bottom_bar.dart';
import 'package:bin_got/widgets/button.dart';
import 'package:bin_got/widgets/container.dart';
import 'package:bin_got/widgets/icon.dart';
import 'package:bin_got/widgets/row_col.dart';
import 'package:bin_got/widgets/scroll.dart';
import 'package:bin_got/widgets/search_bar.dart';
import 'package:bin_got/widgets/settings.dart';
import 'package:bin_got/widgets/text.dart';
import 'package:bin_got/widgets/toast.dart';
import 'package:flutter/material.dart';

//* 메인 페이지
class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  // bool isSearchMode = false;
  double boxHeight = 100;
  double radius = 40;
  int selectedIndex = 1;
  WidgetList nextPages = const [Settings(), MainTabBar(), CustomSearchBar()];
  final List<BottomNavigationBarItem> items = [
    customBottomBarIcon(label: '설정 페이지', iconData: settingsIcon),
    customBottomBarIcon(label: '메인 페이지', iconData: homeIcon),
    customBottomBarIcon(label: '그룹 검색 바 띄우기', iconData: searchIcon),
  ];
  // final List<Color> backgroundColors = [whiteColor, paleRedColor, whiteColor];

  void changeIndex(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        setState(() {
          boxHeight =
              getHeight(context) - 50 - MediaQuery.of(context).padding.top;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => exitApp(context),
      child: Scaffold(
        // backgroundColor: backgroundColors[selectedIndex],
        resizeToAvoidBottomInset: false,
        body: CustomAnimatedPage(
          changeIndex: changeIndex,
          nextPages: nextPages,
          selectedIndex: selectedIndex,
        ),
        bottomNavigationBar: CustomSnakeBottomBar(
          selectedIndex: selectedIndex,
          items: items,
          changeIndex: changeIndex,
        ),
      ),
    );
  }
}

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
    [1, 0],
    [1, 0]
  ];

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

  void changeTab(int index) {
    if (tabBarIndex != index) {
      setState(() {
        tabBarIndex = index;
      });
      // if (index == 1 && bingoTabData == null) {
      //   setBingoTabData();
      // }
    }
  }

  FutureBool setGroupTabData([bool more = true]) {
    print('last id => ${getLastId(context, 1)}');
    final answer = UserInfoProvider().getMainGroupData({
      'order': idxList[0][0],
      'filter': idxList[0][1],
      'idx': getLastId(context, 1),
      // 'page': getPage(context, 1),
    }).then((groupData) {
      print('--------------------------');
      print(idxList[0]);
      print('group tab bar : ${groupData.groups.length}');
      // setState(() {
      // });
      if (groupData.groups.isNotEmpty) {
        groupTabData.addAll(groupData.groups);
      }
      hasNotGroup = groupData.hasNotGroup;
      setLoading(context, false);
      if (more) {
        setWorking(context, false);
        setAdditional(context, false);
      }
      // increasePage(context, 1);

      return true;
    }).catchError((error) {
      showErrorModal(context);
      return false;
    });
    return Future.value(answer);
  }

  void setBingoTabData([bool more = true]) {
    print('--------------- bingo tab last id => ${getLastId(context, 2)}');
    UserInfoProvider().getMainBingoData({
      'order': idxList[1][0],
      'filter': idxList[1][1],
      'idx': getLastId(context, 2),
    }).then((bingoData) {
      if (bingoData.isNotEmpty) {
        bingoTabData.addAll(bingoData);
      }
      setLoading(context, false);
      if (more) {
        setWorking(context, false);
        setAdditional(context, false);
      }
      // increasePage(context, 2);
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initLoadingData(context, 1);
      if (readLoading(context)) {
        setGroupTabData(false).then((_) {
          initLoadingData(context, 2);
          if (readLoading(context)) {
            setBingoTabData(false);
          }
        });
      }

      groupController.addListener(
        () {
          if (groupController.position.pixels >=
              groupController.position.maxScrollExtent * 0.9) {
            print('last id => ${getLastId(context, 1)}');
            if (getLastId(context, 1) != -1) {
              if (!getWorking(context)) {
                setWorking(context, true);
                Future.delayed(const Duration(seconds: 3), () {
                  if (!getAdditional(context)) {
                    setAdditional(context, true);
                    if (getAdditional(context)) {
                      setGroupTabData();
                    }
                  }
                });
              }
            }
          }
        },
      );
    });

    bingoController.addListener(
      () {
        if (bingoController.position.pixels >=
            bingoController.position.maxScrollExtent * 0.9) {
          print('last id => ${getLastId(context, 2)}');
          if (getLastId(context, 2) != -1) {
            // print('${getPage(context, 2)}, ${getTotal(context, 2)}');
            // if (getPage(context, 2) < getTotal(context, 2)!) {
            if (!getWorking(context)) {
              setWorking(context, true);
              Future.delayed(const Duration(seconds: 2), () {
                if (!getAdditional(context)) {
                  setAdditional(context, true);
                  if (getAdditional(context)) {
                    setBingoTabData();
                  }
                }
              });
            }
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
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
            Expanded(
              child: Column(
                children: [
                  RowWithPadding(
                    vertical: 10,
                    horizontal: 25,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      for (int i = 0; i < 2; i += 1)
                        Center(
                          child: CustomTextButton(
                            content: buttonOptions[i][idxList[tabBarIndex][i]],
                            fontSize: FontSize.smallSize,
                            onTap: () => changeIdx(i),
                          ),
                        ),
                    ],
                  ),
                  Expanded(
                    child: tabBarIndex == 0
                        ? GroupInfiniteScroll(
                            controller: groupController,
                            data: groupTabData,
                            mode: 1,
                            emptyWidget: const Column(
                              children: [
                                CustomText(
                                  center: true,
                                  content: '조건을 만족하는 그룹이 없어요.',
                                  height: 1.7,
                                ),
                              ],
                            ),
                            hasNotGroupWidget: hasNotGroup
                                ? const Column(
                                    children: [
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
                                    ],
                                  )
                                : null,
                          )
                        : InfiniteScroll(
                            controller: bingoController,
                            data: bingoTabData,
                            mode: 2,
                            emptyWidget: const Padding(
                              padding: EdgeInsets.only(top: 40),
                              child: CustomText(
                                center: true,
                                height: 1.7,
                                content: '조건을 만족하는 빙고가 없어요.',
                              ),
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
        // const MyTabBar(),
        // CustomBoxContainer(
        //   height: boxHeight,
        //   // color: backgroundColor,
        //   hasRoundEdge: false,
        //   child: Column(
        //     mainAxisSize: MainAxisSize.max,
        //     children: [
        //       const SizedBox(height: 15),
        //       const Expanded(
        //         // height: MediaQuery.of(context).size.height - 200,
        //         child: MyTabBar(),
        //       ),
        //     ],
        //   ),
        // ),
        const CreateGroupButton(),
        if (watchPressed(context))
          const CustomToast(content: '뒤로 가기 버튼을 한 번 더\n누르시면 앱이 종료됩니다')
      ],
    );
  }
}
