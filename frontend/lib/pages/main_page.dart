import 'package:bin_got/pages/my_page.dart';
import 'package:bin_got/utilities/style_utils.dart';
import 'package:bin_got/widgets/app_bar.dart';
import 'package:bin_got/widgets/list.dart';
import 'package:bin_got/widgets/search_bar.dart';
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

  void toMyPage() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const MyPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: topBar(
        context: context,
        isMainPage: true,
        methodFunc1: changeSearchMode,
        methodFunc2: toMyPage,
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(color: backgroundColor),
          child: Column(
            children: [
              isSearchMode ? const SearchBar() : const SizedBox(),
              const SizedBox(height: 15),
              for (int i = 0; i < 10; i += 1)
                const GroupList(isSearchMode: false),
            ],
          ),
        ),
      ),
    );
  }
}
