import 'package:bin_got/pages/bingo_form_page.dart';
import 'package:bin_got/widgets/bingo_widget.dart';
import 'package:flutter/material.dart';
import 'package:bin_got/widgets/bottom_bar.dart';

class BingoDetail extends StatelessWidget {
  // final String title, nickname, achieve;
  const BingoDetail({
    super.key,
    // required this.title,
    // required this.nickname,
    // required this.achieve,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Text(
          'appBar',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.share),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'title',
            style: TextStyle(fontSize: 40),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            'nickname',
            style: TextStyle(fontSize: 20),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const BingoForm()),
                    );
                  },
                  icon: const Icon(Icons.edit)),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.delete),
              )
            ],
          ),
          Column(
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
          const SizedBox(
            height: 30,
          ),
          const Text(
            '달성률 : 100%',
            style: TextStyle(fontSize: 30),
          ),
        ],
      ),
      bottomNavigationBar: const bottomBar(),
    );
  }
}

// class TempCol extends StatelessWidget {
//   const TempCol({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Row(
//           children: const [
//             TempBingo(
//               width: 10,
//               height: 10,
//             ),
//             TempBingo(
//               width: 10,
//               height: 10,
//             ),
//             TempBingo(
//               width: 10,
//               height: 10,
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }


