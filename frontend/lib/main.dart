import 'package:bin_got/pages/group_main_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const GroupMain(),
      // home: const Intro(),
      // home: const BingoForm(),
      theme: ThemeData(
        fontFamily: 'RIDIBatang',
      ),
    );
  }
}
