//* 그룹 내 달성률 랭킹
import 'package:bin_got/providers/root_provider.dart';
import 'package:bin_got/utilities/global_func.dart';
import 'package:bin_got/utilities/style_utils.dart';
import 'package:bin_got/widgets/container.dart';
import 'package:bin_got/widgets/switch_indicator.dart';
import 'package:bin_got/widgets/list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroupRank extends StatefulWidget {
  const GroupRank({
    super.key,
  });

  @override
  State<GroupRank> createState() => _GroupRankState();
}

class _GroupRankState extends State<GroupRank> {
  // int groupId = 0;
  // RankList rankList = [];
  // bool enable = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 30, 10, 0),
      child: CustomBoxContainer(
        color: whiteColor,
        child: !watchLoading(context) &&
                context.watch<GlobalGroupProvider>().rankList.isNotEmpty
            ? ListView.builder(
                itemCount: context.watch<GlobalGroupProvider>().rankList.length,
                itemBuilder: (context, index) => RankListItem(
                  rankListItem:
                      context.watch<GlobalGroupProvider>().rankList[index],
                ),
              )
            : const CustomCirCularIndicator(),
      ),
    );
  }
}
