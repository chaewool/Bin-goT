import 'package:bin_got/pages/my_page.dart';
import 'package:bin_got/utilities/image_icon.dart';
import 'package:bin_got/widgets/list.dart';
import 'package:bin_got/widgets/search_bar.dart';
import 'package:flutter/material.dart';

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
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: Padding(
          padding: const EdgeInsets.all(6),
          child: halfLogo,
        ),
        actions: [
          IconButton(onPressed: changeSearchMode, icon: searchIcon),
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const MyPage()));
              },
              icon: myPageIcon)
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(color: Color(0xFFF4FCF9)),
          child: Column(
            children: [
              isSearchMode ? const SearchBar() : const SizedBox(),
              const SizedBox(height: 15),
              for (int i = 0; i < 10; i += 1) const GroupList(),
            ],
          ),
        ),
      ),
    );
  }
}
