//* 그룹 내 달성률 랭킹
import 'package:bin_got/providers/group_provider.dart';
import 'package:bin_got/utilities/global_func.dart';
import 'package:bin_got/utilities/style_utils.dart';
import 'package:bin_got/utilities/type_def_utils.dart';
import 'package:bin_got/widgets/app_bar.dart';
import 'package:bin_got/widgets/switch_indicator.dart';
import 'package:bin_got/widgets/list.dart';
import 'package:bin_got/widgets/text.dart';
import 'package:flutter/material.dart';

class GroupRank extends StatefulWidget {
  // final int groupId;
  // final bool isMember;
  // final String password;
  const GroupRank({
    super.key,
    // required this.groupId,
    // required this.isMember,
    // required this.password,
  });

  @override
  State<GroupRank> createState() => _GroupRankState();
}

class _GroupRankState extends State<GroupRank> {
  // Future<RankList>? rankList;
  late int groupId;

  @override
  void initState() {
    super.initState();
    groupId = getGroupId(context)!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          // AppBarWithBack(),
          const GroupAppBar(
              // onlyBack: true,
              // groupId: widget.groupId,
              // password: widget.password,
              ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 10),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: CustomText(content: '그룹 랭킹', fontSize: FontSize.titleSize),
            ),
            Expanded(
              child: FutureBuilder(
                future: GroupProvider().groupRank(groupId),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Expanded(child: groupRankList(snapshot));
                  }
                  return const CustomCirCularIndicator();
                },
              ),
            )
          ],
        ),
      ),
      // bottomNavigationBar:
      // GroupMainBottomBar(
      //   isMember: true,
      //   groupId: widget.groupId,
      // ),
    );
  }

  ListView groupRankList(AsyncSnapshot<RankList> snapshot) {
    return ListView.separated(
      itemBuilder: (context, index) {
        var rankListItem = snapshot.data![index];
        return RankListItem(
          rank: index + 1,
          rankListItem: rankListItem,
          isMember: true,
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 20),
      itemCount: snapshot.data!.length,
    );
  }
}
