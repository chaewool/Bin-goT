import 'package:bin_got/providers/api_provider.dart';
import 'package:bin_got/providers/user_provider.dart';
import 'package:bin_got/utilities/style_utils.dart';
import 'package:bin_got/widgets/app_bar.dart';
import 'package:bin_got/widgets/box_container.dart';
import 'package:bin_got/widgets/list.dart';
import 'package:bin_got/widgets/search_bar.dart';
import 'package:flutter/material.dart';

//* 메인 페이지
class Main extends StatefulWidget {
  const Main({super.key});
  // final Future<MyGroupList> groups =

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

  void test() async {
    final response = await dio.get(PersonalApi().groupListUrl);
    print(response);
  }

  @override
  void initState() {
    super.initState();
    test();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainBar(onPressed: changeSearchMode),
      body: SingleChildScrollView(
        child: CustomBoxContainer(
          color: backgroundColor,
          hasRoundEdge: false,
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
