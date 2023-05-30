import 'package:bin_got/widgets/app_bar.dart';
import 'package:bin_got/widgets/container.dart';
import 'package:bin_got/widgets/search_bar.dart';
import 'package:bin_got/widgets/tab_bar.dart';
import 'package:flutter/material.dart';

//* 메인 페이지
class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  bool isSearchMode = false;

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainBar(onPressed: changeSearchMode),
      body: CustomBoxContainer(
        height: MediaQuery.of(context).size.height,
        // color: backgroundColor,
        hasRoundEdge: false,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            isSearchMode ? const SearchBar(isMain: true) : const SizedBox(),
            const SizedBox(height: 15),
            const Expanded(child: MyTabBar()),
          ],
        ),
      ),
    );
  }
}
