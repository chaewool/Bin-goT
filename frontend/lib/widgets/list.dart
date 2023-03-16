import 'package:bin_got/pages/bingo_detail_page.dart';
import 'package:bin_got/pages/group_main_page.dart';
import 'package:bin_got/utilities/global_func.dart';
import 'package:bin_got/utilities/image_icon_utils.dart';
import 'package:bin_got/utilities/style_utils.dart';
import 'package:bin_got/utilities/type_def_utils.dart';
import 'package:bin_got/widgets/box_container.dart';
import 'package:bin_got/widgets/button.dart';
import 'package:bin_got/widgets/text.dart';
import 'package:flutter/material.dart';

//* 그룹 목록
class GroupList extends StatelessWidget {
  final bool isSearchMode;
  final int groupId, headCount, count;
  final String groupName, start, end, status;
  const GroupList({
    super.key,
    required this.isSearchMode,
    required this.groupId,
    required this.headCount,
    required this.count,
    required this.start,
    required this.end,
    required this.groupName,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    String groupMember = '($count/$headCount)';
    return CustomList(
      height: 70,
      boxShadow: [shadowWithOpacity],
      onTap: toOtherPage(
        context: context,
        page: GroupMain(
          groupName: groupName,
          start: start,
          end: end,
          cnt: count,
          headCount: headCount,
          isMember: true,
          groupId: groupId,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(content: groupName),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CustomText(content: 'D-day'),
              const SizedBox(height: 5),
              isSearchMode
                  ? CustomText(
                      content: groupMember, fontSize: FontSize.smallSize)
                  : const SizedBox(),
            ],
          )
        ],
      ),
    );
  }
}

//* 순위 목록
class RankList extends StatelessWidget {
  final int rank, achievement;
  final String nickname;
  final bool isMember;
  const RankList({
    super.key,
    required this.rank,
    required this.nickname,
    required this.achievement,
    this.isMember = true,
  });

  @override
  Widget build(BuildContext context) {
    return CustomList(
      height: 70,
      boxShadow: const [defaultShadow],
      onTap: isMember
          ? toOtherPage(context: context, page: const BingoDetail())
          : null,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: 50,
            height: 50,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                shape: BoxShape.circle, border: Border.all(color: greyColor)),
            child: CustomText(content: '$rank', fontSize: FontSize.largeSize),
          ),
          const SizedBox(width: 30),
          CustomText(content: '$nickname / $achievement%'),
        ],
      ),
    );
  }
}

//* group admin
class MemberList extends StatelessWidget {
  final Image image;
  final String nickname;
  final bool isMember;
  const MemberList(
      {super.key,
      required this.image,
      required this.nickname,
      required this.isMember});

  @override
  Widget build(BuildContext context) {
    return CustomList(
      height: 70,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 50,
            height: 50,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                shape: BoxShape.circle, border: Border.all(color: greyColor)),
            child: image,
          ),
          CustomText(content: nickname),
          Row(
            children: [
              isMember
                  ? const SizedBox()
                  : IconButtonInRow(
                      icon: confirmIcon,
                      onPressed: () {},
                      color: greenColor,
                    ),
              IconButtonInRow(
                icon: closeIcon,
                onPressed: () {},
                color: isMember ? blackColor : redColor,
              ),
            ],
          )
        ],
      ),
    );
  }
}

//* 리스트 기본 틀
class CustomList extends StatelessWidget {
  final double? width, height;
  final Widget child;
  final ReturnVoid? onTap;
  final BoxShadowList? boxShadow;
  const CustomList(
      {super.key,
      this.height,
      this.width,
      required this.child,
      this.onTap,
      this.boxShadow});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: CustomBoxContainer(
        onTap: onTap,
        height: height,
        width: width,
        boxShadow: boxShadow,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: child,
        ),
      ),
    );
  }
}

//* 빙고 목록
class BingoList extends StatelessWidget {
  const BingoList({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomList(
      height: 70,
      boxShadow: const [defaultShadow],
      onTap: toOtherPage(context: context, page: const BingoDetail()),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          CustomText(content: '빙고 이름'),
          CustomText(content: '그룹 이름'),
          CustomText(content: 'D-day'),
        ],
      ),
    );
  }
}
