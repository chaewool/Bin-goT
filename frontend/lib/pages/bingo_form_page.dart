import 'package:bin_got/utilities/style_utils.dart';
import 'package:bin_got/widgets/app_bar.dart';
import 'package:bin_got/widgets/bingo_board.dart';
import 'package:bin_got/widgets/button.dart';
import 'package:bin_got/widgets/input.dart';
import 'package:bin_got/widgets/tab_bar.dart';
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
      appBar: const AppBarWithBack(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Column(
          children: [
            const Flexible(
              flex: 1,
              child: CustomInput(explain: '빙고 이름'),
            ),
            const Flexible(
              flex: 4,
              child: BingoBoard(bingoSize: 3),
            ),
            const Flexible(flex: 4, child: BingoTabBar()),
            Flexible(
              flex: 1,
              child: CustomButton(
                onPressed: () {},
                content: '완료',
                fontSize: FontSize.textSize,
              ),
            )
          ],
        ),
      ),
    );
  }
}
