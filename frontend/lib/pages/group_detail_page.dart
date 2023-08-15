import 'package:bin_got/widgets/container.dart';
import 'package:bin_got/widgets/group_chat.dart';
import 'package:bin_got/utilities/global_func.dart';
import 'package:bin_got/utilities/type_def_utils.dart';
import 'package:bin_got/widgets/app_bar.dart';
import 'package:bin_got/widgets/bingo_detail.dart';
import 'package:bin_got/widgets/bottom_bar.dart';
import 'package:bin_got/widgets/group_main.dart';
import 'package:flutter/material.dart';

class GroupDetail extends StatefulWidget
// with WidgetsBindingObserver
{
  final int groupId, initialIndex;
  final String password;
  final bool isPublic;
  final int? bingoId;
  const GroupDetail({
    super.key,
    required this.groupId,
    required this.password,
    this.initialIndex = 1,
    required this.isPublic,
    this.bingoId,
  });

  @override
  State<GroupDetail> createState() => _GroupDetailState();
}

class _GroupDetailState extends State<GroupDetail> {
  late int memberState, size;
  int? bingoId;
  late bool needAuth;
  late int selectedIndex;
  final WidgetList nextPages = [];
  final List<PreferredSizeWidget> appbarList =
      List.generate(3, (_) => AppBar());
  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialIndex;
    memberState = -1;
    size = -1;
    needAuth = false;
    bingoId = widget.bingoId ?? 0;
    if (memberState != 0) {
      nextPages.addAll([
        BingoDetail(bingoId: bingoId!, size: size),
        GroupMain(
          groupId: widget.groupId,
          password: widget.password,
          applyNew: applyNew,
        ),
        GroupChat(bingoId: bingoId!)
      ]);
    }
    appbarList[2] = const AppBarWithBack();
    // appbarList.addAll([
    //   BingoDetailAppBar(
    //     save: () => Future.value(true),
    //     bingoId: bingoId!,
    //   ),
    //   GroupAppBar(
    //     groupId: widget.groupId,
    //     isMember: memberState != 0,
    //     isAdmin: memberState == 2,
    //     password: widget.password,
    //   ),
    //   const AppBarWithBack()
    // ]);
    WidgetsBinding.instance.addPostFrameCallback((_) {});

    // WidgetsBinding.instance.addObserver(this);
  }

  void changeIndex(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  void applyNew({
    int? newMemberState,
    int? newSize,
    bool? newNeedAuth,
    int? newBingoId,
  }) {
    setState(() {
      if (newMemberState != null) {
        memberState = newMemberState;
      }
      if (newSize != null) {
        size = newSize;
      }
      if (newNeedAuth != null) {
        needAuth = newNeedAuth;
      }
      bingoId = newBingoId;
      appbarList[0] = BingoDetailAppBar(
        save: () => Future.value(true),
        bingoId: bingoId!,
      );
      appbarList[1] = GroupAppBar(
        groupId: widget.groupId,
        isMember: memberState != 0,
        isAdmin: memberState == 2,
        password: widget.password,
      );
    });
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
        if (selectedIndex == 0) {
          toBack(context);
          toBack(context);
          setPublic(context, null);
          return Future.value(false);
        } else {
          toBack(context);
          return Future.value(false);
        }
      },
      child: Scaffold(
        appBar: appbarList[selectedIndex],
        body: CustomAnimatedPage(
          initialPage: widget.initialIndex,
          changeIndex: changeIndex,
          nextPages: nextPages,
          selectedIndex: selectedIndex,
        ),
        bottomNavigationBar: selectedIndex != 2
            ? GroupMainBottomBar(
                isMember: memberState != 0,
                groupId: widget.groupId,
                needAuth: needAuth,
                size: size,
                selectedIndex: selectedIndex,
                bingoId: bingoId,
                changeIndex: changeIndex,
              )
            : null,
      ),
    );
  }
}
