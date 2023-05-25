import 'package:bin_got/models/user_info_model.dart';
import 'package:bin_got/pages/search_group_page.dart';
import 'package:bin_got/providers/user_info_provider.dart';
import 'package:bin_got/utilities/global_func.dart';
import 'package:bin_got/utilities/type_def_utils.dart';
import 'package:bin_got/widgets/app_bar.dart';
import 'package:bin_got/widgets/container.dart';
import 'package:bin_got/widgets/modal.dart';
import 'package:bin_got/widgets/search_bar.dart';
import 'package:bin_got/widgets/tab_bar.dart';
import 'package:bin_got/widgets/text.dart';
import 'package:flutter/material.dart';

//* 메인 페이지
class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  late Future<MainTabModel> groups;
  bool isSearchMode = false;
  DynamicMap query = {'value': null};

  @override
  void initState() {
    super.initState();
    groups = UserInfoProvider().getMainTabData();
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

  void onSearchAction() {
    if (query['value'] != '') {
      return toOtherPage(
        context,
        page: const SearchGroup(
          public: 0,
          period: 1,
          cnt: 20,
        ),
      )();
    }
    showModal(
      context,
      page: const CustomModal(
        title: '검색어 입력',
        hasConfirm: false,
        children: [CustomText(content: '검색어를 입력해주세요')],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainBar(onPressed: changeSearchMode),
      body: CustomBoxContainer(
        height: MediaQuery.of(context).size.height,
        // color: backgroundColor,
        hasRoundEdge: false,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            isSearchMode
                ? const SearchBar(
                    // query: query['value'],
                    // onChange: (value) => query['value'] = value,
                    // onSearchAction: ,

                    )
                : const SizedBox(),
            const SizedBox(height: 15),
            const Expanded(child: MyTabBar()),
          ],
        ),
      ),
    );
  }
}
