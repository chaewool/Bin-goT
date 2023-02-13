import 'package:bin_got/pages/search_group_page.dart';
import 'package:bin_got/widgets/button.dart';
import 'package:bin_got/widgets/check_box.dart';
import 'package:bin_got/widgets/select_box.dart';
import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    const List<String> period = <String>[
      '기간을 선택해주세요',
      '하루 ~ 한 달',
      '한 달 ~ 세 달',
      '세 달 ~ 여섯 달',
      '여섯 달 ~ 아홉 달',
      '아홉 달 ~ 1년'
    ];
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
              const SelectBox(selectList: period),
              CustomButton(
                methodFunc: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SearchGroup()));
                },
                buttonText: '검색',
              ),
            ],
          ),
          Row(
            children: const [
              CustomCheckBox(
                label: '공개',
              ),
              CustomCheckBox(
                label: '비공개',
              )
            ],
          )
        ]),
      ),
    );
  }
}
