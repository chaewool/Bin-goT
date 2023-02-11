import 'package:bin_got/widgets/list.dart';
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
          child: Image.asset(
            'assets/logos/bin_got_logo_0.5x.png',
            fit: BoxFit.contain,
          ),
        ),
        actions: [
          IconButton(
            onPressed: changeSearchMode,
            icon: const Icon(
              Icons.search_rounded,
              color: Colors.black,
              size: 30,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.person,
              color: Colors.black,
              size: 30,
            ),
          )
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(color: Color(0xFFF4FCF9)),
        child: Column(
          children: [
            // const SearchBar(),
            const SizedBox(height: 15),
            for (int i = 0; i < 7; i += 1) const GroupList(),
          ],
        ),
      ),
    );
  }
}
