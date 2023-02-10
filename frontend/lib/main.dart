import 'package:bin_got/pages/bingo_detail_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const BingoDetail(),
      theme: ThemeData(
        fontFamily: 'RIDIBatang',
      ),
      // home: BingoForm(),
    );
  }
}
