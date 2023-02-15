import 'package:bin_got/pages/group_main_page.dart';
import 'package:bin_got/utilities/style_utils.dart';
import 'package:flutter/material.dart';

class GroupList extends StatelessWidget {
  final bool isSearchMode;
  const GroupList({super.key, required this.isSearchMode});

  @override
  Widget build(BuildContext context) {
    const String count = '(5/10)';
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const GroupMain()),
          );
        },
        child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      spreadRadius: 0,
                      blurRadius: 4,
                      offset: const Offset(0, 3))
                ]),
            height: 70,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('미라클 모닝', style: nineteenText),
                      Text('D-day', style: nineteenText),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: const [
                      Text(count, style: nineteenText),
                    ],
                  )
                ],
              ),
            )),
      ),
    );
  }
}
