import 'package:bin_got/providers/group_provider.dart';
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
import 'package:bin_got/widgets/scroll.dart';
import 'package:bin_got/widgets/text.dart';
import 'package:flutter/material.dart';

class CustomSearchBar extends StatefulWidget {
  // final int public;
  // final int period;
  // final String? query;
  // final bool isMain;
  // final int sortIdx;

  const CustomSearchBar({
    super.key,
    // this.public = 0,
    // this.period = 0,
    // this.query,
    // this.isMain = false,
    // this.sortIdx = 0,
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
  BoolList publicPrivate = [true, true];
  StringMap keyword = {'value': ''};
  double index = 0;
  int sortIdx = 0;
  MyGroupList groups = [];
  ScrollController controller = ScrollController();
  bool showSearchBar = true;
  int result = 3;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      initLoadingData(context, 0);
      if (getLoading(context)) {
        setLoading(context, false);
        // search(false);
      }
      // getOffset();
      controller.addListener(() {
        if (controller.position.pixels >=
            controller.position.maxScrollExtent * 0.9) {
          // print('${getPage(context, 0)}, ${getTotal(context, 0)}');
          if (getLastId(context, 0) != -1) {
            // if (getPage(context, 1) < getTotal(context, 1)!) {
            if (!getWorking(context)) {
              setWorking(context, true);
              Future.delayed(const Duration(seconds: 2), () {
                if (!getAdditional(context)) {
                  setAdditional(context, true);
                  if (getAdditional(context)) {
                    search();
                  }
                }
              });
            }
          }
        }
      });
    });
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
      result = 3;
      if (publicPrivate[0]) {
        result -= 2;
      }
      if (publicPrivate[1]) {
        result -= 1;
      }
      search(false);

      // toOtherPage(
      //   context,
      //   page: SearchGroup(
      //     public: result,
      //     period: index.toInt(),
      //     query: keyword['value'],
      //     order: sortIdx,
      //   ),
      // )();
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

  void search([bool more = true]) {
    setLastId(context, 0, 0);
    print('''
    keyword: $keyword,
      public: $result,
      order: $sortIdx,
      period: $index,
      lastId: ${getLastId(context, 0)}
''');
    GroupProvider()
        .searchGroupList(
      keyword: keyword['value'],
      public: result,
      lastId: getLastId(context, 0),
      order: sortIdx,
      period: index.toInt(),
    )
        .then((newGroups) {
      if (!more) {
        groups.clear();
      }
      setState(() {
        groups.addAll(newGroups);
      });
      setLoading(context, false);
      if (more) {
        setWorking(context, false);
        setAdditional(context, false);
      }
    });
  }

  void changeShowSearchBar() {
    setState(() {
      showSearchBar = !showSearchBar;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: CustomInput(
                      explain: '그룹명을 입력하세요',
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
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: CustomIconButton(
                      onPressed: changeShowSearchBar,
                      icon: showSearchBar
                          ? Icons.keyboard_arrow_up_outlined
                          : Icons.keyboard_arrow_down_outlined,
                    ),
                  )
                ],
              ),
            ),
            if (showSearchBar)
              ColWithPadding(
                horizontal: 20,
                children: [
                  searchOptions(
                    '기간 선택',
                    [
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
                                });
                              },
                            ),
                          ),
                          if (index != 0)
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: CustomText(
                                content: index.toInt() != 0
                                    ? period[index.toInt()]
                                    : '',
                                fontSize: FontSize.smallSize,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                  searchOptions(
                    '그룹 정렬',
                    [
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
                  searchOptions(
                    '공개 여부 필터',
                    [
                      for (int i = 0; i < 2; i += 1)
                        CustomBoxContainer(
                          onTap: () => changePublicPrivate(i),
                          color: publicPrivate[i] ? paleRedColor : whiteColor,
                          borderColor:
                              publicPrivate[i] ? paleRedColor : greyColor,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CustomText(
                              content: i == 0 ? '공개 그룹' : '비공개 그룹',
                              color: publicPrivate[i] ? whiteColor : blackColor,
                              fontSize: FontSize.smallSize,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            RowWithPadding(
              vertical: 10,
              horizontal: 20,
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
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: CustomText(
                          content: '그룹명을 입력하거나, 기간을 선택해주세요',
                          fontSize: FontSize.smallSize,
                          color: paleRedColor,
                        ),
                      ),
              ],
            ),
            Expanded(
              child: GroupInfiniteScroll(
                controller: controller,
                data: groups,
                mode: 0,
                emptyWidget: const Padding(
                  padding: EdgeInsets.only(top: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      CustomText(
                        center: true,
                        content: '조건에 맞는 그룹이 없어요.\n다른 그룹을 검색하거나\n그룹을 생성해보세요.',
                        height: 1.5,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const CreateGroupButton(),
      ],
    );
  }

  RowWithPadding searchOptions(String optionTitle, WidgetList children) {
    return RowWithPadding(
      vertical: 12,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(
          content: optionTitle,
          fontSize: FontSize.smallSize,
        ),
        ...children
      ],
    );
  }
}
