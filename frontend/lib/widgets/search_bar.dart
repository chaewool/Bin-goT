import 'package:bin_got/pages/search_group_page.dart';
import 'package:bin_got/utilities/global_func.dart';
import 'package:bin_got/utilities/image_icon_utils.dart';
import 'package:bin_got/utilities/style_utils.dart';
import 'package:bin_got/utilities/type_def_utils.dart';
import 'package:bin_got/widgets/container.dart';
import 'package:bin_got/widgets/button.dart';
import 'package:bin_got/widgets/icon.dart';
import 'package:bin_got/widgets/input.dart';
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
  late BoolList publicPrivate;
  StringMap keyword = {};
  late double index;
  late int sortIdx;

  @override
  void initState() {
    super.initState();
    index = widget.period.toDouble();
    sortIdx = widget.sortIdx;
    publicPrivate = [widget.public < 2, widget.public % 2 == 0];
    keyword['value'] = widget.query ?? '';
  }

  void onSearchAction() {
    if (!publicPrivate[0] && !publicPrivate[1]) {
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
      if (publicPrivate[0]) {
        result -= 2;
      }
      if (publicPrivate[1]) {
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

  void changePublicPrivate(int i) {
    setState(() {
      publicPrivate[i] = !publicPrivate[i];
    });
    print(publicPrivate);
  }

  bool Function() isPossible() => () => index != 0 || keyword['value'] != '';

  void changeSort(int value) {
    setState(() {
      sortIdx = value;
    });
  }

  // void changePossible(String value) {
  //   if (value == '') {
  //     if (isPossible) {
  //       setState(() {
  //         isPossible = false;
  //       });
  //     }
  //   } else if (!isPossible) {
  //     setState(() {
  //       isPossible = true;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return CustomBoxContainer(
      hasRoundEdge: false,
      // color: blackColor,
      child: ColWithPadding(
        horizontal: 30,
        vertical: 30,
        children: [
          // const Center(
          //     child: CustomText(
          //   content: '검색',
          //   fontSize: FontSize.titleSize,
          // )),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: CustomInput(
              explain: '검색할 그룹명을 입력하세요',
              setValue: (value) {
                keyword['value'] = value;
              },
              fontSize: FontSize.textSize,
              initialValue: keyword['value'],
              needSearch: true,
              onSubmitted: (_) => onSearchAction(),
              suffixIcon: const CustomIcon(
                icon: searchIcon,
                color: greyColor,
              ),
            ),
          ),
          // TextField(
          //   decoration: const InputDecoration(
          //     border: OutlineInputBorder(),
          //     hintText: '키워드를 입력하세요',
          //   ),
          //   style: const TextStyle(fontSize: 20),
          //   onChanged: (value) {
          //     keyword['value'] = value;
          //   },
          //   onSubmitted: (_) => onSearchAction(),
          //   textInputAction: TextInputAction.search,
          //   controller: TextEditingController(text: keyword['value']),
          // ),
          RowWithPadding(
            vertical: 20,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const CustomText(
                content: '기간 선택',
                fontSize: FontSize.smallSize,
              ),
              Column(
                children: [
                  SliderTheme(
                    data: SliderThemeData(
                      overlayShape: SliderComponentShape.noOverlay,
                    ),
                    child: Slider(
                      activeColor: palePinkColor,
                      thumbColor: palePinkColor,
                      inactiveColor: palePinkColor.withOpacity(0.5),
                      min: 0,
                      max: 5,
                      divisions: 5,
                      value: index,
                      onChanged: (value) {
                        setState(() {
                          index = value;
                          // if (value == 0) {
                          //   if (isPossible) {
                          //     isPossible = false;
                          //   }
                          // } else if (!isPossible) {
                          //   isPossible = true;
                          // }
                        });
                      },
                    ),
                  ),
                  if (index != 0)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: CustomText(
                        content:
                            index.toInt() != 0 ? period[index.toInt()] : '',
                        fontSize: FontSize.smallSize,
                      ),
                    ),
                ],
              ),
            ],
          ),
          RowWithPadding(
            vertical: 20,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const CustomText(
                content: '그룹 정렬',
                fontSize: FontSize.smallSize,
              ),
              for (int i = 0; i < 2; i += 1)
                CustomBoxContainer(
                  onTap: () => changeSort(i),
                  color: sortIdx == i ? paleRedColor : whiteColor,
                  borderColor: sortIdx == i ? paleRedColor : greyColor,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomText(
                      content: '시작일 ${i == 0 ? '▲' : '▼'}',
                      color: sortIdx == i ? whiteColor : blackColor,
                    ),
                  ),
                ),
            ],
          ),
          RowWithPadding(
            vertical: 20,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const CustomText(
                content: '공개 여부 필터',
                fontSize: FontSize.smallSize,
              ),
              for (int i = 0; i < 2; i += 1)
                CustomBoxContainer(
                  onTap: () => changePublicPrivate(i),
                  color: publicPrivate[i] ? paleRedColor : whiteColor,
                  borderColor: publicPrivate[i] ? paleRedColor : greyColor,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomText(
                      content: i == 0 ? '공개 그룹' : '비공개 그룹',
                      color: publicPrivate[i] ? whiteColor : blackColor,
                      fontSize: FontSize.smallSize,
                    ),
                  ),
                ),
              // const SizedBox(width: 10),
              // CustomBoxContainer(
              //   onTap: changePrivate,
              //   color: privateGroup ? paleOrangeColor : whiteColor,
              //   child: Padding(
              //     padding: const EdgeInsets.all(8.0),
              //     child: CustomText(
              //       content: '비공개 그룹',
              //       color: privateGroup ? whiteColor : blackColor,
              //       fontSize: FontSize.smallSize,
              //     ),
              //   ),
              // ),
              // CustomButton(
              //   onPressed: onSearchAction,
              //   content: '검색',
              // ),
            ],
          ),
          RowWithPadding(
            vertical: 10,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              isPossible()()
                  ? Expanded(
                      child: CustomButton(
                        onPressed: onSearchAction,
                        content: '검색',
                      ),
                    )
                  : const Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: CustomText(
                        content: '그룹명을 입력하거나, 기간을 선택해주세요',
                        fontSize: FontSize.smallSize,
                        color: paleRedColor,
                      ),
                    ),
            ],
          ),
          // CustomText(
          //   content: isPossible ? '검색 가능합니다' : '그룹명을 입력하거나, 기간을 선택해주세요',
          //   fontSize: FontSize.smallSize,
          //   color: isPossible ? blackColor : paleRedColor,
          // )
        ],
      ),
    );
  }
}
