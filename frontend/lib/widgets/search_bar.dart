import 'package:bin_got/pages/search_group_page.dart';
import 'package:bin_got/utilities/global_func.dart';
import 'package:bin_got/utilities/style_utils.dart';
import 'package:bin_got/widgets/box_container.dart';
import 'package:bin_got/widgets/button.dart';
import 'package:bin_got/widgets/check_box.dart';
import 'package:bin_got/widgets/row_col.dart';
import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget {
  const SearchBar({super.key});

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final List<String> period = <String>[
    '기간을 선택해주세요',
    '하루 ~ 한 달',
    '한 달 ~ 세 달',
    '세 달 ~ 여섯 달',
    '여섯 달 ~ 아홉 달',
    '아홉 달 ~ 1년'
  ];
  bool privateGroup = true;
  bool publicGroup = true;
  void changePrivate() {
    setState(() {
      privateGroup = !privateGroup;
    });
  }

  void changePublic() {
    setState(() {
      publicGroup = !publicGroup;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomBoxContainer(
      color: whiteColor,
      child: ColWithPadding(
        horizontal: 30,
        vertical: 17,
        children: [
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
              const SizedBox(),
              // SelectBox(
              //   selectList: period,
              //   valueList: const [],
              //   width: 150,
              //   height: 50,
              //   setValue: (p0) {},
              // ),
              CustomButton(
                onPressed: toOtherPage(context,
                    page: SearchGroup(
                      public: publicGroup && privateGroup
                          ? 0
                          : publicGroup
                              ? 1
                              : 2,
                    )),
                content: '검색',
              ),
            ],
          ),
          Row(
            children: [
              CustomCheckBox(
                label: '공개',
                onChange: (_) => changePublic(),
                value: publicGroup,
              ),
              CustomCheckBox(
                label: '비공개',
                onChange: (_) => changePrivate(),
                value: privateGroup,
              )
            ],
          )
        ],
      ),
    );
  }
}
