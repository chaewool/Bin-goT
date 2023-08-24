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
  final String password;
  final bool isPublic;
  final int? bingoId, size, groupId;
  const GroupDetail({
    super.key,
    this.groupId,
    required this.password,
    required this.isPublic,
    this.initialIndex = 1,
    this.bingoId,
    this.size,
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
    const GroupChat()
  ];
  final List<Widget?> appbarList = [
    BingoDetailAppBar(save: () => Future.value(true)),
    const GroupAppBar(),
    null
  ];

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialIndex;

    // nextPages = List.generate(3, (_) => const SizedBox());
    // appbarList = List.generate(3, (_) => null);
    // if (selectedIndex == 1) {
    //   nextPages[1] = GroupMain(
    //     groupId: widget.groupId,
    //     password: widget.password,
    //     applyNew: applyNew,
    //   );
    // } else {
    //   nextPages[0] = BingoDetail(bingoId: bingoId!, size: size);
    //   nextPages[1] = GroupMain(
    //     groupId: widget.groupId,
    //     password: '',
    //     applyNew: applyNew,
    //   );
    //   appbarList[0] = BingoDetailAppBar(
    //     save: () => Future.value(true),
    //     bingoId: bingoId!,
    //   );
    // appbarList[1] = GroupAppBar(
    //   groupId: widget.groupId,
    //   isMember: memberState != 0,
    //   isAdmin: memberState == 2,
    //   password: widget.password,
    // );
    // }
    // appbarList[2] = const AppBarWithBack();
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.bingoId != null) {
        setBingoId(context, widget.bingoId!, widget.size!);
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
          needScroll: selectedIndex == 1,
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
