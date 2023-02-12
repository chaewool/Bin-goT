import 'package:bin_got/pages/search_group_page.dart';
import 'package:bin_got/widgets/check_box.dart';
import 'package:bin_got/widgets/select_box.dart';
import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Colors.white),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 17),
        child: Column(children: [
          const TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: '키워드를 입력하세요',
            ),
            style: TextStyle(fontSize: 20),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SelectBox(),
              OutlinedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SearchGroup()));
                },
                child: const Text('검색'),
                // style: ButtonStyle(textStyle: MaterialStateProperty.),
              )
            ],
          ),
          Row(
            children: const [CustomCheckBox()],
          )
        ]),
      ),
    );
  }
}
