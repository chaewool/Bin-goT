import 'package:bin_got/pages/search_group_page.dart';
import 'package:bin_got/utilities/global_func.dart';
import 'package:bin_got/utilities/style_utils.dart';
import 'package:bin_got/utilities/type_def_utils.dart';
import 'package:bin_got/widgets/container.dart';
import 'package:bin_got/widgets/button.dart';
import 'package:bin_got/widgets/check_box.dart';
import 'package:bin_got/widgets/modal.dart';
import 'package:bin_got/widgets/row_col.dart';
import 'package:bin_got/widgets/text.dart';
import 'package:flutter/material.dart';

class CustomSearchBar extends StatefulWidget {
  final int public;
  final int period;
  final String? query;
  final bool isMain;

  const CustomSearchBar({
    super.key,
    this.public = 0,
    this.period = 0,
    this.query,
    this.isMain = false,
  });

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  final List<String> period = <String>[
    '기간 미선택',
    '한 달',
    '세 달',
    '여섯 달',
    '아홉 달',
    '1년',
    '하루',
  ];
  late bool privateGroup, publicGroup;
  StringMap keyword = {};
  late double end;
  late double start;

  @override
  void initState() {
    super.initState();
    end = widget.period.toDouble();
    start = end == 0.0 ? 0 : end - 1;
    privateGroup = widget.public % 2 == 0;
    publicGroup = widget.public < 2;
    keyword['value'] = widget.query ?? '';
  }

  void onSearchAction() {
    if (keyword['value'] != '' || end != 0) {
      int result = 3;
      if (publicGroup) {
        result -= 2;
      }
      if (privateGroup) {
        result -= 1;
      }

      toOtherPage(
        context,
        page: SearchGroup(
          public: result,
          cnt: 20,
          period: end.toInt(),
          query: keyword['value'],
        ),
      )();
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

  @override
  Widget build(BuildContext context) {
    return CustomBoxContainer(
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
            onSubmitted: (_) => onSearchAction(),
            textInputAction: TextInputAction.search,
            controller: TextEditingController(text: keyword['value']),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(),
              RangeSlider(
                min: 0,
                max: 5,
                values: RangeValues(start, end),
                divisions: 5,
                labels: RangeLabels(
                    period[start == 0.0 && end != 0.0 ? 6 : start.toInt()],
                    period[end.toInt()]),
                onChanged: (value) {
                  final newStart = value.start;
                  final newEnd = value.end;
                  setState(() {
                    if (newEnd == 0) {
                      end = 0;
                      start = 0;
                    } else if (end != newEnd) {
                      end = newEnd;
                      start = newEnd - 1;
                    } else if (start < 5 && start != newStart) {
                      start = newStart;
                      end = newStart + 1;
                    }
                  });
                },
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
    );
  }
}
