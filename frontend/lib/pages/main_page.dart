import 'package:bin_got/utilities/global_func.dart';
import 'package:bin_got/utilities/style_utils.dart';
import 'package:bin_got/widgets/app_bar.dart';
import 'package:bin_got/widgets/container.dart';
import 'package:bin_got/widgets/search_bar.dart';
import 'package:bin_got/widgets/tab_bar.dart';
import 'package:bin_got/widgets/text.dart';
import 'package:flutter/material.dart';

//* 메인 페이지
class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  bool isSearchMode = false;
  double paddingTop = 0;

  void changeSearchMode() {
    setState(() {
      if (isSearchMode) {
        isSearchMode = false;
      } else {
        isSearchMode = true;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        setState(() {
          paddingTop = MediaQuery.of(context).padding.top;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => exitApp(context),
      child: Scaffold(
        appBar: MainBar(onPressed: changeSearchMode),
        body: Stack(
          children: [
            CustomBoxContainer(
              height: getHeight(context) - 50 - paddingTop,
              // color: backgroundColor,
              hasRoundEdge: false,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  isSearchMode
                      ? const CustomSearchBar(isMain: true)
                      : const SizedBox(),
                  const SizedBox(height: 15),
                  const Expanded(
                    // height: MediaQuery.of(context).size.height - 200,
                    child: MyTabBar(),
                  ),
                ],
              ),
            ),
            watchPressed(context)
                ? const Center(
                    child: CustomBoxContainer(
                      height: 80,
                      width: 300,
                      color: Color.fromRGBO(0, 0, 0, 0.8),
                      child: Center(
                        child: CustomText(
                          content: '뒤로 가기 버튼을 한 번 더\n누르시면 앱이 종료됩니다',
                          height: 1.5,
                          center: true,
                          color: whiteColor,
                        ),
                      ),
                    ),
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
