import 'package:bin_got/widgets/button.dart';
import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        Row(
          children: const [
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: '키워드를 입력하세요',
              ),
              style: TextStyle(fontSize: 15),
            ),
          ],
        ),
        Row(
          children: const [
            // DropdownButton(
            //   items: const [],
            //   onChanged: () {},
            // ),
            Button(
                text: '검색',
                bgColor: Colors.white,
                textColor: Colors.black,
                size: 10)
          ],
        )
      ]),
    );
  }
}
