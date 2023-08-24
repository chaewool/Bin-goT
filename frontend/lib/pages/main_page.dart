import 'package:bin_got/utilities/global_func.dart';
import 'package:bin_got/utilities/image_icon_utils.dart';
import 'package:bin_got/utilities/type_def_utils.dart';
import 'package:bin_got/widgets/bottom_bar.dart';
import 'package:bin_got/widgets/container.dart';
import 'package:bin_got/widgets/icon.dart';
import 'package:bin_got/widgets/search_bar.dart';
import 'package:bin_got/widgets/settings.dart';
import 'package:bin_got/widgets/tab_bar.dart';
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
