import 'package:bin_got/models/user_info_model.dart';
import 'package:bin_got/providers/user_info_provider.dart';
import 'package:bin_got/utilities/style_utils.dart';
import 'package:bin_got/widgets/app_bar.dart';
import 'package:bin_got/widgets/box_container.dart';
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
  late Future<MainTabModel> groups;
  bool isSearchMode = false;

  @override
  void initState() {
    super.initState();
    groups = UserInfoProvider().getMainTabData();
  }

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
      body: SingleChildScrollView(
        child: CustomBoxContainer(
          height: MediaQuery.of(context).size.height,
          color: backgroundColor,
          hasRoundEdge: false,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              isSearchMode ? const SearchBar() : const SizedBox(),
              const SizedBox(height: 15),
              const Expanded(child: MyTabBar()),
            ],
          ),
        ),
      ),
    );
  }
}
