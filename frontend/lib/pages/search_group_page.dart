import 'package:bin_got/widgets/app_bar.dart';
import 'package:bin_got/widgets/list.dart';
import 'package:bin_got/widgets/search_bar.dart';
import 'package:bin_got/widgets/select_box.dart';
import 'package:flutter/material.dart';

class SearchGroup extends StatelessWidget {
  const SearchGroup({super.key});

  @override
  Widget build(BuildContext context) {
    const List<String> dateFilter = <String>['시작일 ▲', '시작일 ▼'];

    return Scaffold(
      appBar: const MainBar(),
      body: SingleChildScrollView(
        child: Column(children: [
          const SearchBar(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: const [
                SelectBox(selectList: dateFilter, width: 100, height: 50),
              ],
            ),
          ),
          for (int i = 0; i < 10; i += 1) const GroupList(isSearchMode: true),
        ]),
      ),
    );
  }
}
