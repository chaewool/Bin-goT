import 'package:bin_got/widgets/list.dart';
import 'package:bin_got/widgets/search_bar.dart';
import 'package:flutter/material.dart';

class SearchGroup extends StatelessWidget {
  const SearchGroup({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: topBar(context),
      body: SingleChildScrollView(
        child: Column(children: [
          const SearchBar(),
          const SizedBox(
            height: 15,
            child: Text('여기에 필터, 정렬'),
          ),
          for (int i = 0; i < 10; i += 1) const GroupList(),
        ]),
      ),
    );
  }
}
