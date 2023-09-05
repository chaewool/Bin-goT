//* 그룹 내 달성률 랭킹
import 'package:bin_got/providers/group_provider.dart';
import 'package:bin_got/utilities/global_func.dart';
import 'package:bin_got/utilities/style_utils.dart';
import 'package:bin_got/utilities/type_def_utils.dart';
import 'package:bin_got/widgets/container.dart';
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
  late int groupId;
  RankList rankList = [];

  @override
  void initState() {
    super.initState();
    groupId = getGroupId(context)!;
    GroupProvider().groupRank(groupId).then((data) {
      setState(() {
        rankList.addAll(data);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 30, 10, 0),
      child: CustomBoxContainer(
        color: whiteColor,
        child: !watchLoading(context)
            ? rankList.isNotEmpty
                ? Expanded(
                    child: ListView.builder(
                      itemCount: rankList.length,
                      itemBuilder: (context, index) => RankListItem(
                        rank: index + 1,
                        rankListItem: rankList[index],
                        isMember: true,
                      ),
                    ),
                  )
                : const Padding(
                    padding: EdgeInsets.only(top: 30),
                    child: CustomText(content: '유효한 순위가 없습니다.'),
                  )
            : const CustomCirCularIndicator(),
      ),
    );
  }
}
