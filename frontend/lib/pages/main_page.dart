import 'package:bin_got/utilities/global_func.dart';
import 'package:bin_got/widgets/app_bar.dart';
import 'package:bin_got/widgets/container.dart';
import 'package:bin_got/widgets/search_bar.dart';
import 'package:bin_got/widgets/tab_bar.dart';
import 'package:bin_got/widgets/toast.dart';
import 'package:flutter/material.dart';

//* 메인 페이지
class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  bool isSearchMode = false;
  double boxHeight = 0;

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
        appBar: MainBar(onPressed: changeSearchMode),
        body: Stack(
          children: [
            CustomBoxContainer(
              height:
                  getHeight(context) - 50 - MediaQuery.of(context).padding.top,
              // color: backgroundColor,
              hasRoundEdge: false,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  if (isSearchMode) const CustomSearchBar(isMain: true),
                  const SizedBox(height: 15),
                  const Expanded(
                    // height: MediaQuery.of(context).size.height - 200,
                    child: MyTabBar(),
                  ),
                ],
              ),
            ),
            watchPressed(context)
                ? const CustomToast(content: '뒤로 가기 버튼을 한 번 더\n누르시면 앱이 종료됩니다')
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
