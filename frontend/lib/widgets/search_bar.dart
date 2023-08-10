import 'package:bin_got/pages/search_group_page.dart';
import 'package:bin_got/utilities/global_func.dart';
import 'package:bin_got/utilities/style_utils.dart';
import 'package:bin_got/utilities/type_def_utils.dart';
import 'package:bin_got/widgets/container.dart';
import 'package:bin_got/widgets/button.dart';
import 'package:bin_got/widgets/modal.dart';
import 'package:bin_got/widgets/row_col.dart';
import 'package:bin_got/widgets/text.dart';
import 'package:flutter/material.dart';

class CustomSearchBar extends StatefulWidget {
  final int public;
  final int period;
  final String? query;
  final bool isMain;
  final int sortIdx;

  const CustomSearchBar({
    super.key,
    this.public = 0,
    this.period = 0,
    this.query,
    this.isMain = false,
    this.sortIdx = 0,
  });

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  final StringList period = <String>[
    '기간 미선택',
    '하루 ~ 한 달',
    '한 달 ~ 세 달',
    '세 달 ~ 여섯 달',
    '여섯 달 ~ 아홉 달',
    '아홉 달 ~ 1년',
  ];
  late bool privateGroup, publicGroup;
  StringMap keyword = {};
  late double index;
  late int sortIdx;

  @override
  void initState() {
    super.initState();
    index = widget.period.toDouble();
    sortIdx = widget.sortIdx;
    privateGroup = widget.public % 2 == 0;
    publicGroup = widget.public < 2;
    keyword['value'] = widget.query ?? '';
  }

  void onSearchAction() {
    if (!publicGroup && !privateGroup) {
      showModal(
        context,
        page: const CustomModal(
          title: '필수 항목 누락',
          hasConfirm: false,
          cancelText: '확인',
          children: [Center(child: CustomText(content: '그룹 필터를 설정해 주세요.'))],
        ),
      )();
    }
    if (keyword['value'] != '' || index != 0) {
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
          period: index.toInt(),
          query: keyword['value'],
          order: sortIdx,
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

  void changeSort(int value) {
    setState(() {
      sortIdx = value;
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
              Slider(
                min: 0,
                max: 5,
                value: index,
                onChanged: (value) {
                  setState(() {
                    index = value;
                  });
                },
              ),
              CustomText(
                content: index.toInt() != 0 ? period[index.toInt()] : '',
                fontSize: FontSize.smallSize,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomBoxContainer(
                onTap: () => changeSort(0),
                color: sortIdx == 0 ? greenColor : whiteColor,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomText(
                    content: '시작일 ▲',
                    color: sortIdx == 0 ? whiteColor : blackColor,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              CustomBoxContainer(
                onTap: () => changeSort(1),
                color: sortIdx == 1 ? greenColor : whiteColor,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomText(
                    content: '시작일 ▼',
                    color: sortIdx == 1 ? whiteColor : blackColor,
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomBoxContainer(
                onTap: changePublic,
                color: publicGroup ? greenColor : whiteColor,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomText(
                    content: '공개 그룹',
                    color: publicGroup ? whiteColor : blackColor,
                    fontSize: FontSize.smallSize,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              CustomBoxContainer(
                onTap: changePrivate,
                color: privateGroup ? greenColor : whiteColor,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomText(
                    content: '비공개 그룹',
                    color: privateGroup ? whiteColor : blackColor,
                    fontSize: FontSize.smallSize,
                  ),
                ),
              ),
              CustomButton(
                onPressed: onSearchAction,
                content: '검색',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
