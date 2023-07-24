//* 그룹 관리 페이지
import 'package:bin_got/utilities/global_func.dart';
import 'package:bin_got/widgets/app_bar.dart';
import 'package:bin_got/widgets/bottom_bar.dart';
import 'package:bin_got/widgets/container.dart';
import 'package:bin_got/widgets/tab_bar.dart';
import 'package:flutter/material.dart';

class GroupAdmin extends StatelessWidget {
  final int groupId;
  const GroupAdmin({
    super.key,
    required this.groupId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AdminAppBar(groupId: groupId),
      body: CustomBoxContainer(
        height: getHeight(context),
        child: GroupAdminTabBar(groupId: groupId),
      ),
      bottomNavigationBar: BottomBar(
        isMember: true,
        groupId: groupId,
      ),
    );
  }
}
