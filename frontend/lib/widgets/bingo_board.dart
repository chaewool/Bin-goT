import 'package:bin_got/utilities/global_func.dart';
import 'package:bin_got/utilities/style_utils.dart';
import 'package:bin_got/widgets/box_container.dart';
import 'package:flutter/material.dart';

class BingoBoard extends StatelessWidget {
  const BingoBoard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Column(
        children: [
          for (int i = 0; i < 3; i += 1)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int i = 0; i < 3; i += 1) const EachBingo(),
              ],
            )
        ],
      ),
    );
  }
}

class EachBingo extends StatelessWidget {
  const EachBingo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: showModal(
        context: context,
        page: AlertDialog(
          content: const Text('data'),
          actions: [
            ElevatedButton(
                onPressed: () {
                  // Navigator.of(context).pop();
                },
                child: const Text('확인'))
          ],
        ),
      ),
      child: const CustomBoxContainer(
        color: greyColor,
        hasRoundEdge: false,
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 26,
            horizontal: 26,
          ),
          child: Text(
            '빙고칸',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }
}
