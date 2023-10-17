import 'package:bin_got/providers/group_provider.dart';
import 'package:bin_got/utilities/global_func.dart';
import 'package:bin_got/utilities/image_icon_utils.dart';
import 'package:bin_got/utilities/style_utils.dart';
import 'package:bin_got/utilities/type_def_utils.dart';
import 'package:bin_got/widgets/container.dart';
import 'package:bin_got/widgets/button.dart';
import 'package:bin_got/widgets/input.dart';
import 'package:bin_got/widgets/row_col.dart';
import 'package:bin_got/widgets/scroll.dart';
import 'package:bin_got/widgets/text.dart';
import 'package:flutter/material.dart';

//? 검색
class Search extends StatefulWidget {
  const Search({
    super.key,
  });

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  //* 변수
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
  bool initial = true;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      initLoadingData(context, 0);
      if (getLoading(context)) {
        setLoading(context, false);
      }
      controller.addListener(() {
        if (controller.position.pixels >=
            controller.position.maxScrollExtent * 0.9) {
          if (getLastId(context, 0) != -1) {
            if (!getWorking(context)) {
              setWorking(context, true);
              afterFewSec(() {
                if (!getAdditional(context)) {
                  setAdditional(context, true);
                  if (getAdditional(context)) {
                    search();
                  }
                }
              }, 2000);
            }
          }
        }
      });
    });
  }

  //* 검색 버튼 터치 시
  void onSearchAction() {
    if (!publicPrivate[0] && !publicPrivate[1]) {
      showAlert(
        context,
        title: '필수 항목 누락',
        content: '그룹 필터를 설정해 주세요.',
        hasCancel: false,
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
      changeShowSearchBar(false);
    } else {
      showAlert(
        context,
        title: '필수 항목 누락',
        content: '검색어를 입력하거나\n 기간을 선택해주세요',
        hasCancel: false,
      )();
    }
  }

  //* 공개, 비공개 설정
  void changePublicPrivate(int i) {
    setState(() {
      publicPrivate[i] = !publicPrivate[i];
    });
  }

  //* 정렬
  void changeSort(int value) {
    setState(() {
      sortIdx = value;
    });
  }

  //* 검색 데이터 갱신
  void search([bool more = true]) {
    if (initial) {
      setState(() {
        initial = false;
      });
    }
    setLastId(context, 0, 0);
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
        setState(() {
          groups.clear();
        });
      }
      if (newGroups.isNotEmpty) {
        setState(() {
          groups.addAll(newGroups);
        });
      }
      setLoading(context, false);
      if (more) {
        setWorking(context, false);
        setAdditional(context, false);
      }
    });
  }

  //* 검색 창 펼침 여부
  void changeShowSearchBar(bool value) {
    setState(() {
      showSearchBar = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: CustomIconButton(
                  onPressed: () =>
                      changeShowSearchBar(showSearchBar ? false : true),
                  icon: showSearchBar
                      ? Icons.keyboard_arrow_up_outlined
                      : Icons.keyboard_arrow_down_outlined,
                ),
              ),
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
                  suffixIcon: CustomIconButton(
                    icon: searchIcon,
                    color: greyColor,
                    onPressed: onSearchAction,
                  ),
                ),
              ),
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
                            content:
                                index.toInt() != 0 ? period[index.toInt()] : '',
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
                    Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: CustomBoxContainer(
                        width: 90,
                        onTap: () => changeSort(i),
                        color: sortIdx == i ? paleRedColor : whiteColor,
                        borderColor: sortIdx == i ? paleRedColor : greyColor,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: CustomText(
                              content: '시작일 ${i == 0 ? '▲' : '▼'}',
                              color: sortIdx == i ? whiteColor : blackColor,
                              fontSize: FontSize.smallSize,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              searchOptions(
                '공개 여부 필터',
                [
                  for (int i = 0; i < 2; i += 1)
                    Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: CustomBoxContainer(
                        width: 90,
                        onTap: () => changePublicPrivate(i),
                        color: publicPrivate[i] ? paleRedColor : whiteColor,
                        borderColor:
                            publicPrivate[i] ? paleRedColor : greyColor,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: CustomText(
                              content: i == 0 ? '공개 그룹' : '비공개 그룹',
                              color: publicPrivate[i] ? whiteColor : blackColor,
                              fontSize: FontSize.smallSize,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              RowWithPadding(
                vertical: 10,
                horizontal: 20,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  index != 0 || keyword['value'] != ''
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
            ],
          ),
        Expanded(
          child: GroupInfiniteScroll(
            controller: controller,
            data: groups,
            mode: 0,
            emptyWidget: Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  initial
                      ? const SizedBox()
                      : const CustomText(
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
    );
  }

  RowWithPadding searchOptions(String optionTitle, WidgetList children) {
    return RowWithPadding(
      vertical: 12,
      children: [
        Expanded(
          child: CustomText(
            content: optionTitle,
            fontSize: FontSize.smallSize,
          ),
        ),
        ...children
      ],
    );
  }
}
