import 'package:bin_got/utilities/global_func.dart';
import 'package:bin_got/utilities/image_icon_utils.dart';
import 'package:bin_got/utilities/style_utils.dart';
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
  final int initialPage;
  const Main({
    super.key,
    this.initialPage = 1,
  });

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  // bool isSearchMode = false;
  // double boxHeight = 100;
  // double radius = 40;
  late int selectedIndex;
  bool enable = true;
  WidgetList nextPages = const [CustomSearchBar(), MainTabBar(), Settings()];
  final List<BottomNavigationBarItem> items = [
    customBottomBarIcon(label: '그룹 검색 바 띄우기', iconData: searchIcon),
    customBottomBarIcon(label: '메인 페이지', iconData: homeIcon),
    customBottomBarIcon(label: '설정 페이지', iconData: settingsIcon),
  ];
  // final List<Color> backgroundColors = [whiteColor, paleRedColor, whiteColor];

  void changeIndex(int index) {
    if (enable) {
      print(enable);
      setState(() {
        selectedIndex = index;
        print(selectedIndex);
        enable = false;
      });
      afterFewSec(() {
        setState(() {
          enable = true;
        });
      });
    }
  }

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialPage;
    // WidgetsBinding.instance.addPostFrameCallback(
    //   (_) {
    //     setState(() {
    //       boxHeight =
    //           getHeight(context) - 50 - MediaQuery.of(context).padding.top;
    //     });
    //   },
    // );
  }

  @override
  Widget build(BuildContext context) {
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   if (getPrev(context)) {
    //     changePrev(context, false);
    //   }
    // });
    return WillPopScope(
      onWillPop: () => exitApp(context),
      child: Scaffold(
        backgroundColor: whiteColor,
        resizeToAvoidBottomInset: false,
        body: CustomAnimatedPage(
          // changeIndex: changeIndex,
          nextPage: nextPages[selectedIndex],
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
