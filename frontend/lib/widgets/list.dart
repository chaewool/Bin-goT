import 'package:bin_got/pages/bingo_detail_page.dart';
import 'package:bin_got/pages/group_main_page.dart';
import 'package:bin_got/utilities/global_func.dart';
import 'package:bin_got/utilities/image_icon_utils.dart';
import 'package:bin_got/utilities/style_utils.dart';
import 'package:bin_got/utilities/type_def_utils.dart';
import 'package:bin_got/widgets/button.dart';
import 'package:bin_got/widgets/text.dart';
import 'package:flutter/material.dart';

//* 그룹 목록
class GroupList extends StatelessWidget {
  final bool isSearchMode;
  const GroupList({super.key, required this.isSearchMode});

  @override
  Widget build(BuildContext context) {
    const String count = '(5/10)';
    return CustomList(
        height: 70,
        boxShadow: [shadowWithOpacity],
        onTap: toOtherPage(context: context, page: const GroupMain()),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const CustomText(content: '미라클 모닝', fontSize: FontSize.textSize),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CustomText(content: 'D-day', fontSize: FontSize.textSize),
                const SizedBox(height: 5),
                isSearchMode
                    ? const CustomText(
                        content: count, fontSize: FontSize.smallSize)
                    : const SizedBox(),
              ],
            )
          ],
        ));
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
          CustomText(
              content: '$nickname / $achievement%',
              fontSize: FontSize.textSize),
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
          CustomText(content: nickname, fontSize: FontSize.textSize),
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
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              boxShadow: boxShadow,
              color: whiteColor),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: child,
          ),
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
          CustomText(content: '빙고 이름', fontSize: FontSize.textSize),
          CustomText(content: '그룹 이름', fontSize: FontSize.textSize),
          CustomText(content: 'D-day', fontSize: FontSize.textSize),
        ],
      ),
    );
  }
}
