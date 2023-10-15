import 'package:bin_got/utilities/global_func.dart';
import 'package:bin_got/utilities/image_icon_utils.dart';
import 'package:bin_got/utilities/style_utils.dart';
import 'package:bin_got/utilities/type_def_utils.dart';
import 'package:bin_got/widgets/bottom_bar.dart';
import 'package:bin_got/widgets/search.dart';
import 'package:bin_got/widgets/settings.dart';
import 'package:bin_got/widgets/tab_bar.dart';
import 'package:flutter/material.dart';

//? 메인 (검색, 내 그룹/내 빙고, 설정)
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
  //* 변수
  late int selectedIndex;
  WidgetList nextPages = const [Search(), MainTabBar(), Settings()];
  late final PageController pageController;
  final List<IconData> items = [
    searchIcon,
    homeIcon,
    settingsIcon,
  ];
  // double opacity = 1;

  //* 페이지 변경
  void changeIndex(int index) {
    if (index != selectedIndex) {
      setState(() {
        selectedIndex = index;
        // opacity = 0;
      });
      pageController.jumpToPage(index);
      // afterFewSec(() {
      //   setState(() {
      //     // opacity = 1;
      //   });
      // });
    }
  }

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialPage;
    //* 페이지 이동 시
    pageController = PageController(initialPage: selectedIndex);
  }

  //* 종료
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
        //* 화면
        body: PageView.builder(
          physics: const NeverScrollableScrollPhysics(),
          controller: pageController,
          itemCount: 3,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.only(
                top: getStatusBarHeight(context),
              ),
              child: nextPages[index],
            );
          },
        ),
        //* 하단 바
        bottomNavigationBar: CustomNavigationBar(
          selectedIndex: selectedIndex,
          items: items,
          changeIndex: (index) => changeIndex(index),
        ),
      ),
    );
  }
}
