import 'package:bin_got/pages/main_page.dart';
import 'package:bin_got/providers/group_provider.dart';
import 'package:bin_got/utilities/global_func.dart';
import 'package:bin_got/utilities/style_utils.dart';
import 'package:bin_got/utilities/type_def_utils.dart';
import 'package:bin_got/widgets/app_bar.dart';
import 'package:bin_got/widgets/button.dart';
import 'package:bin_got/widgets/row_col.dart';
import 'package:bin_got/widgets/scroll.dart';
import 'package:bin_got/widgets/search_bar.dart';
import 'package:bin_got/widgets/text.dart';
import 'package:flutter/material.dart';

class SearchGroup extends StatefulWidget {
  final int public, order, page, cnt, period;
  final String? query;
  const SearchGroup({
    super.key,
    required this.public,
    this.page = 1,
    this.order = 0,
    required this.cnt,
    required this.period,
    required this.query,
  });

  @override
  State<SearchGroup> createState() => _SearchGroupState();
}

class _SearchGroupState extends State<SearchGroup> {
  final StringList sortList = ['시작일 ▲', '시작일 ▼'];
  final StringList filterList = ['공개', '비공개', '전체'];
  MyGroupList groups = [];
  // bool showSort = false;
  // bool showFilter = false;
  late int sortIdx;
  late int filterIdx;
  // final filterKey = GlobalKey();
  // final sortKey = GlobalKey();
  // Offset? filterPosition;
  // Offset? sortPosition;
  final controller = ScrollController();

  @override
  void initState() {
    super.initState();
    print('''
    keyword: ${widget.query},
      public: ${widget.public},
      cnt: ${widget.cnt},
      page: ${widget.page},
      order: ${widget.order},
      period: ${widget.period},
''');
    sortIdx = widget.order;
    filterIdx = widget.public;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      initLoadingData(context, 0);
      if (readLoading(context)) {
        search(false);
      }
      // getOffset();
      controller.addListener(() {
        () {
          if (controller.position.pixels >=
              controller.position.maxScrollExtent * 0.9) {
            print('${getPage(context, 0)}, ${getTotal(context, 0)}');
            if (getPage(context, 1) < getTotal(context, 1)!) {
              if (!getWorking(context)) {
                setWorking(context, true);
                Future.delayed(const Duration(seconds: 3), () {
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
        };
      });
    });
  }

  void search([bool more = true]) {
    GroupProvider()
        .searchGroupList(
      keyword: widget.query,
      public: widget.public,
      cnt: widget.cnt,
      page: widget.page,
      order: widget.order,
      period: widget.period,
    )
        .then((newGroups) {
      if (newGroups is MyGroupList) {
        groups.addAll(newGroups);
        setLoading(context, false);
        if (more) {
          setWorking(context, false);
          setAdditional(context, false);
        }
      }
    });
    increasePage(context, 0);
  }

  // void getOffset() {
  //   if (filterKey.currentContext != null) {
  //     final renderBox =
  //         filterKey.currentContext!.findRenderObject() as RenderBox;
  //     setState(() {
  //       filterPosition = renderBox.localToGlobal(Offset.zero);
  //     });
  //   }
  //   if (sortKey.currentContext != null) {
  //     final renderBox = sortKey.currentContext!.findRenderObject() as RenderBox;
  //     setState(() {
  //       sortPosition = renderBox.localToGlobal(Offset.zero);
  //     });
  //   }
  // }

  // void changeShowSort() {
  //   setState(() {
  //     showSort = !showSort;
  //   });
  // }

  void changeSort() {
    setState(() {
      sortIdx = 1 - sortIdx;
    });
  }

  // void changeShowFilter() {
  //   setState(() {
  //     showFilter = !showFilter;
  //   });
  // }

  void changeFilter() {
    setState(() {
      if (filterIdx == 2) {
        filterIdx = 0;
      } else {
        filterIdx += 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        toOtherPage(context, page: const Main())();
        return Future.value(false);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: backgroundColor,
        appBar: const MainBar(),
        body: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Flexible(
                  fit: FlexFit.loose,
                  child: SearchBar(
                    public: widget.public,
                    period: widget.period,
                    query: widget.query,
                  ),
                ),
                Flexible(
                  fit: FlexFit.loose,
                  child: RowWithPadding(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    horizontal: 25,
                    children: [
                      Center(
                        child: CustomTextButton(
                          content: sortList[sortIdx],
                          fontSize: FontSize.smallSize,
                          onTap: changeSort,
                        ),
                      ),
                      Center(
                        child: CustomTextButton(
                          content: filterList[filterIdx],
                          fontSize: FontSize.smallSize,
                          onTap: changeFilter,
                        ),
                      ),

                      // SelectBox(
                      //   key: sortKey,
                      //   onTap: changeShowSort,
                      //   value: sortList[sortIdx],
                      //   width: 120,
                      //   height: 50,
                      // ),
                      // SelectBox(
                      //   key: filterKey,
                      //   onTap: changeShowFilter,
                      //   value: filterList[filterIdx],
                      //   width: 120,
                      //   height: 50,
                      // ),
                    ],
                  ),
                ),
                Expanded(
                  child: InfiniteScroll(
                    data: groups,
                    isGroupMode: true,
                    mode: 0,
                    emptyWidget: const Padding(
                      padding: EdgeInsets.only(top: 40),
                      child: CustomText(
                        center: true,
                        content: '조건에 맞는 그룹이 없어요.\n다른 그룹을 검색하거나\n그룹을 생성해보세요.',
                        height: 1.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // showFilter
            //     ? Padding(
            //         padding: EdgeInsets.fromLTRB(0, filterPosition!.dy, 0, 0),
            //         child: SelectBoxContainer(
            //           listItems: filterList,
            //           valueItems: List.generate(3, (i) => i),
            //           index: filterIdx,
            //           changeShowState: changeShowFilter,
            //           changeIdx: changeFilter,
            //           height: 120,
            //           mapKey: '',
            //         ),
            //       )
            //     : const SizedBox(),
            // showSort
            //     ? Padding(
            //         padding: EdgeInsets.fromLTRB(0, sortPosition!.dy, 0, 0),
            //         child: SelectBoxContainer(
            //           listItems: sortList,
            //           valueItems: List.generate(2, (i) => i),
            //           index: sortIdx,
            //           changeShowState: changeShowSort,
            //           changeIdx: changeSort,
            //           height: 80,
            //           mapKey: '',
            //         ),
            //       )
            //     : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
