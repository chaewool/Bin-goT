import 'package:bin_got/pages/search_group_page.dart';
import 'package:bin_got/utilities/global_func.dart';
import 'package:bin_got/utilities/style_utils.dart';
import 'package:bin_got/utilities/type_def_utils.dart';
import 'package:bin_got/widgets/container.dart';
import 'package:bin_got/widgets/button.dart';
import 'package:bin_got/widgets/check_box.dart';
import 'package:bin_got/widgets/row_col.dart';
import 'package:bin_got/widgets/select_box.dart';
import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget {
  // final String query;
  // final Function(String value) onChange;
  // final ReturnVoid onSearchAction;
  const SearchBar({
    super.key,
    // required this.query,
    // required this.onChange,
    // required this.onSearchAction,
  });

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final List<String> period = <String>[
    '기간을 선택해주세요',
    '한 달 이하',
    '한 달 ~ 세 달',
    '세 달 ~ 여섯 달',
    '여섯 달 ~ 아홉 달',
    '아홉 달 ~ 1년'
  ];
  int periodIdx = 0;
  bool canShowMenu = false;
  bool privateGroup = true;
  bool publicGroup = true;
  StringMap keyword = {'value': '미라클'};
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

  void changeShowMenu() {
    setState(() {
      canShowMenu = !canShowMenu;
    });
  }

  void changeIdx(String string, int intVal) {
    setState(() {
      periodIdx = intVal;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomBoxContainer(
          color: whiteColor,
          child: ColWithPadding(
            horizontal: 30,
            vertical: 17,
            children: [
              TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: '키워드를 입력하세요',
                ),
                style: const TextStyle(fontSize: 20),
                // onChanged: widget.onChange,
                onChanged: (value) => keyword['value'] = value,
                // controller: TextEditingController(text: widget.query),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(),
                  SelectBox(
                    onTap: changeShowMenu,
                    value: period[periodIdx],
                    width: 150,
                    height: 50,
                  ),
                  CustomButton(
                    onPressed:
                        // widget.onSearchAction,
                        toOtherPage(
                      context,
                      page: SearchGroup(
                        public: publicGroup && privateGroup
                            ? 0
                            : publicGroup
                                ? 1
                                : 2,
                        cnt: 20,
                        period: 0,
                        keyword: keyword['value'],
                      ),
                    ),
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
        ),
        canShowMenu
            ? SelectBoxContainer(
                listItems: period,
                valueItems: List.generate(6, (i) => i),
                index: 0,
                mapKey: '',
                changeShowState: changeShowMenu,
                changeIdx: changeIdx,
              )
            : const SizedBox(),
      ],
    );
  }
}
