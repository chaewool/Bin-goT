import 'package:bin_got/providers/user_provider.dart';
import 'package:bin_got/utilities/style_utils.dart';
import 'package:bin_got/utilities/type_def_utils.dart';
import 'package:bin_got/widgets/app_bar.dart';
import 'package:bin_got/widgets/box_container.dart';
import 'package:bin_got/widgets/list.dart';
import 'package:bin_got/widgets/search_bar.dart';
import 'package:bin_got/widgets/text.dart';
import 'package:flutter/material.dart';

//* 메인 페이지
class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  late Future<MyGroupList> groups;
  bool isSearchMode = false;

  @override
  void initState() {
    super.initState();
    groups = PersonalApi.getMyGroups();
  }

  void changeSearchMode() {
    setState(() {
      if (isSearchMode) {
        isSearchMode = false;
      } else {
        isSearchMode = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainBar(onPressed: changeSearchMode),
      body: SingleChildScrollView(
        child: CustomBoxContainer(
          height: MediaQuery.of(context).size.height,
          color: backgroundColor,
          hasRoundEdge: false,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              isSearchMode ? const SearchBar() : const SizedBox(),
              const SizedBox(height: 15),
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
                              content: '아직 가입된 그룹이 없어요.',
                            ),
                          ),
                          Center(
                            child: CustomText(
                              center: true,
                              fontSize: FontSize.titleSize,
                              content: '그룹에 가입하거나',
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
            ],
          ),
        ),
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
