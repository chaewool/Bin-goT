import 'package:bin_got/pages/group_chat_page.dart';
import 'package:bin_got/providers/root_provider.dart';
import 'package:bin_got/utilities/image_icon_utils.dart';
import 'package:bin_got/widgets/bingo_detail.dart';
import 'package:bin_got/widgets/group_rank.dart';
import 'package:bin_got/utilities/style_utils.dart';
import 'package:bin_got/utilities/type_def_utils.dart';
import 'package:bin_got/widgets/container.dart';
import 'package:bin_got/utilities/global_func.dart';
import 'package:bin_got/widgets/app_bar.dart';
import 'package:bin_got/widgets/bottom_bar.dart';
import 'package:bin_got/widgets/group_main.dart';
import 'package:bin_got/widgets/icon.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroupDetail extends StatefulWidget
// with WidgetsBindingObserver
{
  final int initialIndex;
  final bool isPublic, admin, isMember;
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
    required this.isMember,

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
    // const GroupMain(),
    const BingoDetail(),
    const GroupMain(),
    const GroupRank(),
  ];
  final List<Widget?> appbarList = [
    BingoDetailAppBar(save: () {
      print('touched');
      return Future.value(true);
    }),
    null,
    const GroupAppBar(),
  ];

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialIndex;
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   if (widget.bingoId != null) {
    //     setBingoSize(context, widget.size!);
    //     setBingoId(context, widget.bingoId!);
    //   } else if (widget.groupId != null) {
    //     setGroupId(context, widget.groupId!);
    //   }
    // });

    // WidgetsBinding.instance.addObserver(this);
  }

  void changeIndex(int index) {
    if (index != selectedIndex) {
      // print('selected index => $index $nextPages');
      setState(() {
        selectedIndex = index;
      });
      print(selectedIndex);
      print(nextPages[selectedIndex]);
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
        } else {
          // toBack(context);
        }
        return Future.value(false);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: whiteColor,
        body: Stack(
          children: [
            CustomAnimatedPage(
              needScroll: selectedIndex == 1,
              changeIndex: changeIndex,
              nextPage: nextPages[selectedIndex],
              appBar: appbarList[selectedIndex],
            ),
            Positioned(
              left: getWidth(context) - 80,
              top: getHeight(context) - 150,
              child: FloatingActionButton(
                backgroundColor: palePinkColor.withOpacity(0.8),
                onPressed: toOtherPage(context, page: const GroupChat()),
                child: const CustomIcon(
                  icon: chatIcon,
                  color: whiteColor,
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: GroupMainBottomBar(
          selectedIndex: selectedIndex,
          changeIndex: changeIndex,
          isMember: widget.isMember,
          size: context.watch<GlobalGroupProvider>().bingoSize ??
              context.watch<GlobalBingoProvider>().bingoSize,
        ),
      ),
    );
  }
}
