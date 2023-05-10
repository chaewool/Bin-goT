import 'package:bin_got/providers/group_provider.dart';
import 'package:bin_got/utilities/type_def_utils.dart';
import 'package:bin_got/widgets/app_bar.dart';
import 'package:bin_got/widgets/list.dart';
import 'package:bin_got/widgets/row_col.dart';
import 'package:bin_got/widgets/search_bar.dart';
import 'package:flutter/material.dart';

class SearchGroup extends StatefulWidget {
  final int public, order, page, cnt, period;
  final String? keyword;
  const SearchGroup({
    super.key,
    required this.public,
    this.page = 1,
    this.order = 0,
    required this.cnt,
    required this.period,
    this.keyword,
  });

  @override
  State<SearchGroup> createState() => _SearchGroupState();
}

class _SearchGroupState extends State<SearchGroup> {
  final StringList sort = <String>['모집 중', '전체'];

  final StringList publicFilter = <String>['공개', '비공개', '전체'];
  late Future<MyGroupList> groups;
  StringMap keyword = {'value': ''};

  @override
  void initState() {
    super.initState();
    if (widget.keyword != null) {
      keyword['value'] = widget.keyword!;
    }
    print(widget.keyword);
    groups = GroupProvider().searchGroupList(
      keyword: widget.keyword,
      public: widget.public,
      cnt: widget.cnt,
      page: widget.page,
      order: widget.order,
      period: widget.period,
    );
  }

  @override
  Widget build(BuildContext context) {
    const List<String> dateFilter = <String>['시작일 ▲', '시작일 ▼'];

    return Scaffold(
      appBar: const MainBar(),
      body: SingleChildScrollView(
        child: Column(children: [
          const SearchBar(),
          const RowWithPadding(
            horizontal: 25,
            children: [
              SizedBox()
              // SelectBox(
              //   selectList: dateFilter,
              //   valueList: const [],
              //   width: 100,
              //   height: 50,
              //   setValue: (p0) {},
              // ),
            ],
          ),
          FutureBuilder(
            future: groups,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var data = snapshot.data;
                // if (data!.isNotEmpty) {
                //   return Column(
                //     children: [
                //       Expanded(child: myGroupList(data)),
                //     ],
                //   );
                // } else {
                //   return Column(
                //     children: const [
                //       Center(
                //         child: CustomText(
                //           center: true,
                //           fontSize: FontSize.titleSize,
                //           content: '조건에 맞는 그룹이 없어요.\n다른 그룹을 검색하거나\n그룹을 생성해보세요.',
                //         ),
                //       ),
                //     ],
                //   );
                // }
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ]),
      ),
    );
  }

  ListView myGroupList(MyGroupList data) {
    return ListView.separated(
      itemCount: data.length,
      itemBuilder: (context, index) {
        var group = data[index];
        return GroupListItem(
          isSearchMode: false,
          groupInfo: group,
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 20),
    );
  }
}
