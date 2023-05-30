import 'package:bin_got/pages/search_group_page.dart';
import 'package:bin_got/utilities/global_func.dart';
import 'package:bin_got/utilities/style_utils.dart';
import 'package:bin_got/utilities/type_def_utils.dart';
import 'package:bin_got/widgets/container.dart';
import 'package:bin_got/widgets/button.dart';
import 'package:bin_got/widgets/check_box.dart';
import 'package:bin_got/widgets/modal.dart';
import 'package:bin_got/widgets/row_col.dart';
import 'package:bin_got/widgets/select_box.dart';
import 'package:bin_got/widgets/text.dart';
import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget {
  final int public;
  final int period;
  final String? query;
  final bool isMain;
  const SearchBar({
    super.key,
    this.public = 0,
    this.period = 0,
    this.query,
    this.isMain = false,
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
  late int periodIdx;
  late bool privateGroup, publicGroup;
  bool canShowMenu = false;
  StringMap keyword = {'value': ''};
  final periodBoxKey = GlobalKey();
  Offset? position;

  @override
  void initState() {
    super.initState();
    periodIdx = widget.period;
    privateGroup = widget.public % 2 == 0;
    publicGroup = widget.public < 2;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getOffset();
    });
  }

  void getOffset() {
    if (periodBoxKey.currentContext != null) {
      final renderBox =
          periodBoxKey.currentContext!.findRenderObject() as RenderBox;
      setState(() {
        position = renderBox.localToGlobal(Offset.zero);
      });
    }
  }

  void onSearchAction() {
    if (keyword['value'] != '' || periodIdx != 0) {
      int result = 3;
      if (publicGroup) {
        result -= 2;
      }
      if (privateGroup) {
        result -= 1;
      }

      final page = SearchGroup(
        public: result,
        cnt: 20,
        period: periodIdx,
        getKeyword: () => keyword['value'],
      );

      if (widget.isMain) {
        toOtherPage(context, page: page)();
      } else {
        toOtherPageWithoutPath(context, page: page)();
      }
    } else {
      showModal(
        context,
        page: const CustomModal(
          title: '필수 항목 누락',
          hasConfirm: false,
          cancelText: '확인',
          children: [
            Center(child: CustomText(content: '검색어를 입력하거나\n 기간을 선택해주세요'))
          ],
        ),
      )();
    }
  }

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
                onChanged: (value) {
                  keyword['value'] = value;
                },
                controller: TextEditingController(text: keyword['value']),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(),
                  SelectBox(
                    key: periodBoxKey,
                    onTap: changeShowMenu,
                    value: period[periodIdx],
                    width: 200,
                    height: 50,
                  ),
                  CustomButton(
                    onPressed: onSearchAction,
                    content: '검색',
                  ),
                ],
              ),
              Row(
                children: [
                  CustomCheckBox(
                    label: '공개 그룹',
                    onChange: (_) => changePublic(),
                    value: publicGroup,
                  ),
                  CustomCheckBox(
                    label: '비공개 그룹',
                    onChange: (_) => changePrivate(),
                    value: privateGroup,
                  )
                ],
              )
            ],
          ),
        ),
        canShowMenu
            ? Padding(
                padding: EdgeInsets.fromLTRB(0, 0, position!.dx, 0),
                child: SelectBoxContainer(
                  listItems: period,
                  valueItems: List.generate(6, (i) => i),
                  index: periodIdx,
                  changeShowState: changeShowMenu,
                  changeIdx: changeIdx,
                  mapKey: '',
                ),
              )
            : const SizedBox(),
      ],
    );
  }
}
