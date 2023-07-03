import 'package:bin_got/pages/main_page.dart';
import 'package:bin_got/providers/group_provider.dart';
import 'package:bin_got/utilities/global_func.dart';
import 'package:bin_got/utilities/style_utils.dart';
import 'package:bin_got/utilities/type_def_utils.dart';
import 'package:bin_got/widgets/app_bar.dart';
import 'package:bin_got/widgets/list.dart';
import 'package:bin_got/widgets/row_col.dart';
import 'package:bin_got/widgets/search_bar.dart';
import 'package:bin_got/widgets/select_box.dart';
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
  late Future<MyGroupList> groups;
  bool showSort = false;
  bool showFilter = false;
  int sortIdx = 0;
  int filterIdx = 0;
  final filterKey = GlobalKey();
  final sortKey = GlobalKey();
  Offset? filterPosition;
  Offset? sortPosition;

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
    groups = GroupProvider().searchGroupList(
      keyword: widget.query,
      public: widget.public,
      cnt: widget.cnt,
      page: widget.page,
      order: widget.order,
      period: widget.period,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getOffset();
    });
  }

  void getOffset() {
    if (filterKey.currentContext != null) {
      final renderBox =
          filterKey.currentContext!.findRenderObject() as RenderBox;
      setState(() {
        filterPosition = renderBox.localToGlobal(Offset.zero);
      });
    }
    if (sortKey.currentContext != null) {
      final renderBox = sortKey.currentContext!.findRenderObject() as RenderBox;
      setState(() {
        sortPosition = renderBox.localToGlobal(Offset.zero);
      });
    }
  }

  void changeShowSort() {
    setState(() {
      showSort = !showSort;
    });
  }

  void changeSort(String string, int idx) {
    setState(() {
      sortIdx = idx;
    });
  }

  void changeShowFilter() {
    setState(() {
      showFilter = !showFilter;
    });
  }

  void changeFilter(String string, int idx) {
    setState(() {
      filterIdx = idx;
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
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    horizontal: 25,
                    children: [
                      // SizedBox()
                      SelectBox(
                        key: sortKey,
                        onTap: changeShowSort,
                        value: sortList[sortIdx],
                        width: 120,
                        height: 50,
                      ),
                      SelectBox(
                        key: filterKey,
                        onTap: changeShowFilter,
                        value: filterList[filterIdx],
                        width: 120,
                        height: 50,
                      ),
                    ],
                  ),
                ),
                FutureBuilder(
                  future: groups,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var data = snapshot.data;
                      if (data!.isNotEmpty) {
                        return Expanded(child: myGroupList(data));
                      }
                      return Flexible(
                        // fit: FlexFit.loose,
                        child: Column(
                          children: const [
                            CustomText(
                              center: true,
                              fontSize: FontSize.titleSize,
                              content:
                                  '조건에 맞는 그룹이 없어요.\n다른 그룹을 검색하거나\n그룹을 생성해보세요.',
                              height: 1.5,
                            ),
                          ],
                        ),
                      );
                    }
                    return const Flexible(
                      fit: FlexFit.loose,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  },
                ),
              ],
            ),
            showFilter
                ? Padding(
                    padding: EdgeInsets.fromLTRB(0, filterPosition!.dy, 0, 0),
                    child: SelectBoxContainer(
                      listItems: filterList,
                      valueItems: List.generate(3, (i) => i),
                      index: filterIdx,
                      changeShowState: changeShowFilter,
                      changeIdx: changeFilter,
                      height: 120,
                      mapKey: '',
                    ),
                  )
                : const SizedBox(),
            showSort
                ? Padding(
                    padding: EdgeInsets.fromLTRB(0, sortPosition!.dy, 0, 0),
                    child: SelectBoxContainer(
                      listItems: sortList,
                      valueItems: List.generate(2, (i) => i),
                      index: sortIdx,
                      changeShowState: changeShowSort,
                      changeIdx: changeSort,
                      height: 80,
                      mapKey: '',
                    ),
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }

  ListView myGroupList(MyGroupList data) {
    return ListView.separated(
      itemCount: data.length,
      itemBuilder: (context, index) {
        var group = data[index];
        print(group);
        return GroupListItem(
          isSearchMode: true,
          groupInfo: group,
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 10),
    );
  }
}
