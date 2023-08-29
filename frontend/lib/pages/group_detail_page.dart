import 'package:bin_got/widgets/group_rank.dart';
import 'package:bin_got/utilities/style_utils.dart';
import 'package:bin_got/utilities/type_def_utils.dart';
import 'package:bin_got/widgets/bingo_detail.dart';
import 'package:bin_got/widgets/container.dart';
import 'package:bin_got/utilities/global_func.dart';
import 'package:bin_got/widgets/app_bar.dart';
import 'package:bin_got/widgets/bottom_bar.dart';
import 'package:bin_got/widgets/group_chat.dart';
import 'package:bin_got/widgets/group_main.dart';
import 'package:flutter/material.dart';

class GroupDetail extends StatefulWidget
// with WidgetsBindingObserver
{
  final int initialIndex;
  final bool isPublic, admin;
  final int? bingoId, size, groupId;
  // final String start;
  const GroupDetail({
    super.key,
    this.groupId,
    required this.isPublic,
    this.initialIndex = 1,
    this.bingoId,
    this.size,
    required this.admin,
    // required this.start,
  });

  @override
  State<GroupDetail> createState() => _GroupDetailState();
}

class _GroupDetailState extends State<GroupDetail> {
  // late int memberState, size;
  // late bool needAuth;
  late int selectedIndex;
  final WidgetList nextPages = [
    const BingoDetail(),
    const GroupMain(),
    const GroupChat(),
    const GroupRank(),
  ];
  final List<Widget?> appbarList = [
    BingoDetailAppBar(save: () => Future.value(true)),
    const GroupAppBar(),
    null,
    const GroupAppBar(),
  ];

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialIndex;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.bingoId != null) {
        setBingoSize(context, widget.size!);
        setBingoId(context, widget.bingoId!);
      } else if (widget.groupId != null) {
        setGroupId(context, widget.groupId!);
      }
    });

    // WidgetsBinding.instance.addObserver(this);
  }

  void changeIndex(int index) {
    if (index != selectedIndex) {
      // print('selected index => $index $nextPages');
      setState(() {
        selectedIndex = index;
      });
    }
  }

  // @override
  // void dispose() {
  //   super.dispose();
  //   // WidgetsBinding.instance.removeObserver(this);
  // }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        toBack(context);
        toBack(context);
        if (selectedIndex == 1) {
          // setPublic(context, null);
        }
        return Future.value(false);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: whiteColor,
        body: CustomAnimatedPage(
          needScroll: selectedIndex % 2 == 1,
          changeIndex: changeIndex,
          nextPage: nextPages[selectedIndex],
          appBar: appbarList[selectedIndex],
        ),
        bottomNavigationBar: GroupMainBottomBar(
          selectedIndex: selectedIndex,
          changeIndex: changeIndex,
        ),
      ),
    );
  }
}
