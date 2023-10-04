import 'package:bin_got/utilities/global_func.dart';
import 'package:bin_got/utilities/image_icon_utils.dart';
import 'package:bin_got/utilities/style_utils.dart';
import 'package:bin_got/utilities/type_def_utils.dart';
import 'package:bin_got/widgets/bottom_bar.dart';
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
  late int selectedIndex;
  bool enable = true;
  WidgetList nextPages = const [CustomSearchBar(), MainTabBar(), Settings()];
  late final PageController pageController;
  final List<IconData> items = [
    searchIcon,
    homeIcon,
    settingsIcon,
    // customBottomBarIcon(label: '그룹 검색 바 띄우기', iconData: searchIcon),
    // customBottomBarIcon(label: '메인 페이지', iconData: homeIcon),
    // customBottomBarIcon(label: '설정 페이지', iconData: settingsIcon),
  ];

  void changeIndex(int index, [bottomBar = false]) {
    if (index != selectedIndex) {
      setState(() {
        selectedIndex = index;
      });
      if (bottomBar) {
        pageController.animateToPage(
          index,
          duration: const Duration(milliseconds: 500),
          curve: Curves.ease,
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialPage;
    pageController = PageController(initialPage: selectedIndex);
    pageController.addListener(
      () {
        if (pageController.page!.round() != selectedIndex) {
          setState(() {
            selectedIndex = pageController.page!.round();
          });
        }
      },
    );
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
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => exitApp(context),
      child: Scaffold(
        backgroundColor: whiteColor,
        resizeToAvoidBottomInset: false,
        body: PageView.builder(
          controller: pageController,
          onPageChanged: changeIndex,
          itemCount: 3,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              child: nextPages[index],
            );
          },
        ),
        bottomNavigationBar: CustomNavigationBar(
          selectedIndex: selectedIndex,
          items: items,
          changeIndex: (index) => changeIndex(index, true),
        ),
      ),
    );
  }
}
