//* 그룹 내 달성률 랭킹
import 'package:bin_got/providers/group_provider.dart';
import 'package:bin_got/utilities/style_utils.dart';
import 'package:bin_got/utilities/type_def_utils.dart';
import 'package:bin_got/widgets/app_bar.dart';
import 'package:bin_got/widgets/bottom_bar.dart';
import 'package:bin_got/widgets/list.dart';
import 'package:bin_got/widgets/text.dart';
import 'package:flutter/material.dart';

class GroupRank extends StatefulWidget {
  final int groupId;
  final bool isMember;
  const GroupRank({required this.groupId, required this.isMember, super.key});

  @override
  State<GroupRank> createState() => _GroupRankState();
}

class _GroupRankState extends State<GroupRank> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GroupAppBar(
        onlyBack: true,
        groupId: widget.groupId,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child:
                    CustomText(content: '그룹 랭킹', fontSize: FontSize.titleSize),
              ),
              FutureBuilder(
                future: GroupProvider().groupRank(widget.groupId),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return groupRankList(snapshot);
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomBar(
        isMember: true,
        groupId: widget.groupId,
      ),
    );
  }

  ListView groupRankList(AsyncSnapshot<RankList> snapshot) {
    return ListView.separated(
      itemBuilder: (context, index) {
        var rankListItem = snapshot.data![index];
        return RankListItem(
          rank: index + 1,
          rankListItem: rankListItem,
          isMember: widget.isMember,
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 20),
      itemCount: snapshot.data!.length,
    );
  }
}
