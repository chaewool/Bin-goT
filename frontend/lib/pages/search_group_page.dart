import 'package:bin_got/providers/user_provider.dart';
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
  const SearchGroup({super.key});

  @override
  State<SearchGroup> createState() => _SearchGroupState();
}

class _SearchGroupState extends State<SearchGroup> {
  late Future<MyGroupList> groups;

  @override
  void initState() {
    super.initState();
    groups = PersonalApi.getMyGroups();
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
              SelectBox(selectList: dateFilter, width: 100, height: 50),
            ],
          ),
          FutureBuilder(
            future: groups,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var data = snapshot.data;
                if (data!.isNotEmpty) {
                  return Column(
                    children: [
                      Expanded(child: myGroupList(data)),
                    ],
                  );
                } else {
                  return Column(
                    children: const [
                      Center(
                        child: CustomText(
                          center: true,
                          fontSize: FontSize.titleSize,
                          content: '조건에 맞는 그룹이 없어요.',
                        ),
                      ),
                      Center(
                        child: CustomText(
                          center: true,
                          fontSize: FontSize.titleSize,
                          content: '다른 그룹을 검색하거나',
                        ),
                      ),
                      Center(
                        child: CustomText(
                          center: true,
                          fontSize: FontSize.titleSize,
                          content: '그룹을 생성해보세요.',
                        ),
                      ),
                    ],
                  );
                }
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
        return GroupList(
          isSearchMode: false,
          groupId: group.id,
          groupName: group.groupName,
          headCount: group.headCount,
          count: group.count,
          start: group.start,
          end: group.end,
          status: group.status,
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 20),
    );
  }
}
