import 'package:bin_got/providers/group_provider.dart';
import 'package:bin_got/utilities/type_def_utils.dart';
import 'package:bin_got/widgets/app_bar.dart';
import 'package:bin_got/widgets/list.dart';
import 'package:bin_got/widgets/row_col.dart';
import 'package:bin_got/widgets/search_bar.dart';
import 'package:flutter/material.dart';

class SearchGroup extends StatefulWidget {
  final int public;
  const SearchGroup({
    super.key,
    required this.public,
  });

  @override
  State<SearchGroup> createState() => _SearchGroupState();
}

class _SearchGroupState extends State<SearchGroup> {
  late Future<MyGroupList> groups;
  StringMap keyword = {'value': ''};
  int order = 0;
  int? period, filter;

  @override
  void initState() {
    super.initState();
    groups = GroupProvider().searchGroupList(
      public: widget.public,
      cnt: 10,
      page: 1,
      keyword: keyword['value'],
      order: order,
      period: period,
      filter: filter,
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
