import 'package:bin_got/providers/group_provider.dart';
import 'package:bin_got/utilities/style_utils.dart';
import 'package:bin_got/utilities/type_def_utils.dart';
import 'package:bin_got/widgets/app_bar.dart';
import 'package:bin_got/widgets/list.dart';
import 'package:bin_got/widgets/row_col.dart';
import 'package:bin_got/widgets/search_bar.dart';
import 'package:bin_got/widgets/text.dart';
import 'package:flutter/material.dart';

class SearchGroup extends StatefulWidget {
  final int public, order, page, cnt, period;
  final String? Function() getKeyword;
  const SearchGroup({
    super.key,
    required this.public,
    this.page = 1,
    this.order = 0,
    required this.cnt,
    required this.period,
    required this.getKeyword,
  });

  @override
  State<SearchGroup> createState() => _SearchGroupState();
}

class _SearchGroupState extends State<SearchGroup> {
  final StringList sort = <String>['모집 중', '전체'];
  final StringList publicFilter = <String>['공개', '비공개', '전체'];
  late Future<MyGroupList> groups;
  late String query;

  @override
  void initState() {
    super.initState();
    print('''
    keyword: ${widget.getKeyword()},
      public: ${widget.public},
      cnt: ${widget.cnt},
      page: ${widget.page},
      order: ${widget.order},
      period: ${widget.period},
''');
    setState(() {
      query = widget.getKeyword() ?? '';
    });
    groups = GroupProvider().searchGroupList(
      keyword: widget.getKeyword(),
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
      resizeToAvoidBottomInset: false,
      appBar: const MainBar(),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            fit: FlexFit.loose,
            child: SearchBar(
              public: widget.public,
              period: widget.period,
            ),
          ),
          const Flexible(
            fit: FlexFit.loose,
            child: RowWithPadding(
              horizontal: 25,
              children: [
                // SizedBox()
                // SelectBox(
                //   onTap: () {},
                //   selectList: dateFilter,
                //   valueList: const [0, 1],
                //   width: 100,
                //   height: 50,
                //   setValue: (p0) {},
                // ),
              ],
            ),
          ),
          FutureBuilder(
            future: groups,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var data = snapshot.data;
                if (data!.isNotEmpty) {
                  return Flexible(
                    fit: FlexFit.loose,
                    child: myGroupList(data),
                  );
                }
                return Flexible(
                  fit: FlexFit.loose,
                  child: Column(
                    children: const [
                      CustomText(
                        center: true,
                        fontSize: FontSize.titleSize,
                        content: '조건에 맞는 그룹이 없어요.\n다른 그룹을 검색하거나\n그룹을 생성해보세요.',
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
    );
  }

  ListView myGroupList(MyGroupList data) {
    return ListView.separated(
      itemCount: data.length,
      itemBuilder: (context, index) {
        var group = data[index];
        return GroupListItem(
          isSearchMode: true,
          groupInfo: group,
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 20),
    );
  }
}
