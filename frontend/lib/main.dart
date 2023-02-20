import 'package:bin_got/pages/group_form_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // home: const Main(),
      home: const GroupFirstForm(),
      theme: ThemeData(
        fontFamily: 'RIDIBatang',
      ),
      // home: BingoForm(),
    );
  }
}