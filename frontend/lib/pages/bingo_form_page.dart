import 'package:bin_got/widgets/bingo_board.dart';
import 'package:flutter/material.dart';

class BingoForm extends StatefulWidget {
  const BingoForm({super.key});

  @override
  State<BingoForm> createState() => _BingoFormState();
}

class _BingoFormState extends State<BingoForm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: const [
          SizedBox(
            height: 50,
          ),
          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: '빙고 이름',
            ),
            style: TextStyle(fontSize: 15),
          ),
          BingoBoard(),
          // BingoTabBar()
        ],
      ),
    );
  }
}
