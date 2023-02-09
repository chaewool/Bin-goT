import 'package:flutter/material.dart';

// class EditIcon extends StatelessWidget {
//   const EditIcon({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(onTap: () {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => const BingoForm(),
//         ),
//       );
//     });
//   }
// }

class EachBingo extends StatelessWidget {
  const EachBingo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: const Text('data'),
                actions: [
                  ElevatedButton(
                      onPressed: () {
                        // Navigator.of(context).pop();
                      },
                      child: const Text('확인'))
                ],
              );
            });
      },
      child: Container(
        decoration: const BoxDecoration(color: Colors.blueGrey),
        child: const Padding(
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
