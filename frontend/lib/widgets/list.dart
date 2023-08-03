import 'package:bin_got/models/group_model.dart';
import 'package:bin_got/models/user_info_model.dart';
import 'package:bin_got/pages/input_password_page.dart';
import 'package:bin_got/providers/group_provider.dart';
import 'package:bin_got/utilities/global_func.dart';
import 'package:bin_got/utilities/style_utils.dart';
import 'package:bin_got/utilities/type_def_utils.dart';
import 'package:bin_got/widgets/button.dart';
import 'package:bin_got/widgets/container.dart';
import 'package:bin_got/widgets/text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

//* 그룹 목록
class GroupListItem extends StatelessWidget {
  final bool isSearchMode;
  final MyGroupModel groupInfo;
  final bool public;
  const GroupListItem({
    super.key,
    required this.isSearchMode,
    required this.groupInfo,
    required this.public,
  });

  @override
  Widget build(BuildContext context) {
    String showedDif() {
      final difference = (DateTime.now()
                  .difference(DateTime.parse(groupInfo.start))
                  .inSeconds /
              Duration.secondsPerDay)
          .floor();
      if (difference < 0) {
        return 'D - ${-difference}';
      } else if (difference > 0) {
        return 'D + $difference';
      } else {
        return 'D-Day';
      }
    }

    String groupMember = '(${groupInfo.count}/${groupInfo.headCount})';
    return CustomList(
      height: 70,
      boxShadow: [shadowWithOpacity],
      onTap: toOtherPage(
        context,
        page: InputPassword(
          groupId: groupInfo.id,
          isPublic: public,
          needCheck: false,
          isSearchMode: isSearchMode,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(content: groupInfo.name),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomText(content: showedDif()),
              const SizedBox(height: 5),
              isSearchMode
                  ? CustomText(
                      content: groupMember,
                      fontSize: FontSize.smallSize,
                    )
                  : const SizedBox(),
            ],
          )
        ],
      ),
    );
  }
}

//* 순위 목록
class RankListItem extends StatelessWidget {
  final int rank;
  final GroupRankModel rankListItem;
  final bool isMember;
  const RankListItem({
    super.key,
    required this.rank,
    required this.rankListItem,
    required this.isMember,
  });

  @override
  Widget build(BuildContext context) {
    return CustomList(
      height: 70,
      boxShadow: const [defaultShadow],
      onTap: () {},
      // isMember ? toOtherPage(context, page: const BingoDetail()) : null,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CircleContainer(
            child: CustomText(content: '$rank', fontSize: FontSize.largeSize),
          ),
          const SizedBox(width: 30),
          CustomText(
              content: '${rankListItem.nickname} / ${rankListItem.achieve}%'),
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
  const CustomList({
    super.key,
    this.height,
    this.width,
    required this.child,
    this.onTap,
    this.boxShadow,
  });

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
// class BingoList extends StatelessWidget {
//   const BingoList({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return CustomList(
//       height: 70,
//       boxShadow: const [defaultShadow],
//       onTap: toOtherPage(context, page: const BingoDetail()),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: const [
//           CustomText(content: '빙고 이름'),
//           CustomText(content: '그룹 이름'),
//           CustomText(content: 'D-day'),
//         ],
//       ),
//     );
//   }
// }

//* 채팅 목록
class ChatListItem extends StatefulWidget {
  final GroupChatModel data;
  final String? date;
  const ChatListItem({
    super.key,
    required this.data,
    required this.date,
  });

  @override
  State<ChatListItem> createState() => _ChatListItemState();
}

class _ChatListItemState extends State<ChatListItem> {
  late bool isMine = widget.data.userId == getId(context);
  void confirmMessage() async {
    if (isMine) {
      showAlert(context, title: '인증 불가', content: '자신의 채팅에 인증 확인할 수 없습니다')();
    } else {
      await GroupProvider().checkReview(getGroupId(context)!, widget.data.id);
      changeReviewed();
    }
  }

  late bool reviewed = widget.data.reviewed;
  void changeReviewed() {
    if (!reviewed) {
      setState(() {
        reviewed = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.date != null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: CustomBoxContainer(
              child: CustomText(content: widget.date!),
            ),
          ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment:
              isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            if (isMine)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: CustomText(
                  color: greyColor,
                  content: widget.data.createdAt.split(' ')[1].substring(0, 5),
                  fontSize: FontSize.smallSize,
                ),
              ),
            Flexible(
              child: CustomList(
                boxShadow: [shadowWithOpacity],
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CachedNetworkImage(
                            imageUrl:
                                '${dotenv.env['fileUrl']}/badges/${widget.data.badgeId}',
                            width: 30,
                            height: 30,
                            placeholder: (context, url) =>
                                const CustomBoxContainer(color: greyColor),
                          ),
                          const SizedBox(width: 10),
                          CustomText(
                            content: widget.data.username,
                            fontSize: FontSize.smallSize,
                          ),
                        ],
                      ),
                      // if (widget.data.itemId != -1)
                      // CustomText(content: widget.data.),
                      if (widget.data.hasImage == true)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: SizedBox(
                            width: 100,
                            height: 100,
                            child: CachedNetworkImage(
                              imageUrl:
                                  '${dotenv.env['fileUrl']}/chats/${getGroupId(context)}/${widget.data.id}',
                            ),
                          ),
                        ),
                      if (widget.data.content != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: CustomText(content: widget.data.content!),
                        ),
                      if (widget.data.itemId != -1)
                        reviewed
                            ? const CustomText(
                                content: '인증된 채팅입니다',
                                color: greyColor,
                              )
                            : Center(
                                child: CustomButton(
                                  onPressed: confirmMessage,
                                  content: '인증 확인',
                                  enabled: !isMine,
                                ),
                              )
                    ],
                  ),
                ),
              ),
            ),
            if (!isMine)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: CustomText(
                  color: greyColor,
                  content: widget.data.createdAt.split(' ')[1].substring(0, 5),
                  fontSize: FontSize.smallSize,
                ),
              )
          ],
        ),
      ],
    );
  }
}
