import 'package:bin_got/models/group_model.dart';
import 'package:bin_got/models/user_info_model.dart';
import 'package:bin_got/pages/input_password_page.dart';
import 'package:bin_got/providers/group_provider.dart';
import 'package:bin_got/utilities/global_func.dart';
import 'package:bin_got/utilities/image_icon_utils.dart';
import 'package:bin_got/utilities/style_utils.dart';
import 'package:bin_got/utilities/type_def_utils.dart';
import 'package:bin_got/widgets/button.dart';
import 'package:bin_got/widgets/container.dart';
import 'package:bin_got/widgets/icon.dart';
import 'package:bin_got/widgets/row_col.dart';
import 'package:bin_got/widgets/text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

//* 목록 아이템

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
          Flexible(
            flex: 3,
            child: CustomText(
              content: groupInfo.name,
              cutText: true,
            ),
          ),
          Flexible(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText(
                  content: showedDif(),
                ),
                const SizedBox(height: 5),
                isSearchMode
                    ? CustomText(
                        content: groupMember,
                        fontSize: FontSize.smallSize,
                      )
                    : const SizedBox(),
              ],
            ),
          )
        ],
      ),
    );
  }
}

//* 순위 목록
class RankListItem extends StatelessWidget {
  final GroupRankModel rankListItem;
  const RankListItem({
    super.key,
    required this.rankListItem,
  });

  @override
  Widget build(BuildContext context) {
    void toBingoDetail() {
      setBingoId(context, rankListItem.bingoId);
      changeGroupIndex(context, 0);
    }

    return CustomList(
      innerHorizontal: 15,
      height: 70,
      border: true,
      onTap: toBingoDetail,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircleContainer(
            boxShadow: null,
            color: palePinkColor,
            radius: 20,
            border: false,
            child: CustomText(
              content: '${rankListItem.rank != -1 ? rankListItem.rank : '-'}',
              fontSize: FontSize.largeSize,
              color: whiteColor,
              bold: true,
            ),
          ),
          CustomText(content: rankListItem.nickname),
          CustomText(
            content: '${(rankListItem.achieve * 100).toInt()}%',
            fontSize: FontSize.smallSize,
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
  final Color color;
  final bool border;
  final double vertical, horizontal, innerHorizontal;
  const CustomList({
    super.key,
    this.height,
    this.width,
    required this.child,
    this.onTap,
    this.boxShadow,
    this.color = whiteColor,
    this.vertical = 10,
    this.horizontal = 10,
    this.innerHorizontal = 30,
    this.border = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: vertical, horizontal: horizontal),
      child: CustomBoxContainer(
        color: color,
        onTap: onTap,
        height: height,
        width: width,
        borderColor: border ? greyColor : whiteColor,
        boxShadow: boxShadow,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: innerHorizontal),
          child: child,
        ),
      ),
    );
  }
}

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
            padding: const EdgeInsets.only(bottom: 20, top: 10),
            child: CustomText(
              content: widget.date!,
              fontSize: FontSize.textSize,
              bold: true,
            ),
          ),
        Row(
          mainAxisAlignment:
              isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isMine)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: CachedNetworkImage(
                  imageUrl:
                      '${dotenv.env['fileUrl']}/badges/${widget.data.badgeId}',
                  width: 30,
                  height: 30,
                  placeholder: (context, url) =>
                      const CustomBoxContainer(color: greyColor),
                ),
              ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!isMine)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: CustomText(
                      content: widget.data.username,
                      fontSize: FontSize.smallSize,
                    ),
                  ),
                RowWithPadding(
                  vertical: 12,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (isMine) checkAndTimeInfo(),
                    widget.data.content != '' || widget.data.itemId != -1
                        ? Stack(
                            children: [
                              CustomList(
                                vertical: 0,
                                innerHorizontal: 20,
                                color: isMine
                                    ? paleRedColor.withOpacity(0.8)
                                    : greyColor.withOpacity(0.5),
                                child: ColWithPadding(
                                  vertical: 10,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    if (widget.data.itemId != -1)
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 10),
                                        child: CustomText(
                                          content: widget.data.title,
                                          color: blackColor,
                                        ),
                                      ),
                                    if (widget.data.hasImage == true)
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 5,
                                        ),
                                        child: ChatImage(
                                          widget: widget,
                                          onTap: showModal(
                                            context,
                                            page: InteractiveViewer(
                                              child: ChatImage(
                                                hasRoundEdge: false,
                                                widget: widget,
                                                height: getHeight(context),
                                                onTap: () => toBack(context),
                                                transparent: false,
                                              ),
                                            ),
                                          ),
                                          height: 250,
                                        ),
                                      ),
                                    if (widget.data.content != null)
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 5,
                                        ),
                                        child: CustomText(
                                          content: widget.data.content!,
                                          fontSize: FontSize.textSize,
                                          color: whiteColor,
                                        ),
                                      ),
                                    if (widget.data.itemId != -1 && !reviewed)
                                      Center(
                                        child: CustomButton(
                                          onPressed: confirmMessage,
                                          content: '인증 확인',
                                          enabled: !isMine,
                                          fontSize: FontSize.smallSize,
                                          color: whiteColor,
                                        ),
                                      )
                                  ],
                                ),
                              ),
                              if (widget.data.itemId != -1 && reviewed)
                                Transform.translate(
                                  offset: const Offset(0, -10),
                                  child: const CustomIcon(
                                    icon: checkIcon,
                                    color: darkGreyColor,
                                    size: 25,
                                  ),
                                ),
                            ],
                          )
                        : Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 10,
                            ),
                            child: ChatImage(
                              onTap: showModal(
                                context,
                                page: InteractiveViewer(
                                  child: ChatImage(
                                    hasRoundEdge: false,
                                    widget: widget,
                                    height: getHeight(context),
                                    onTap: () => toBack(context),
                                    transparent: false,
                                  ),
                                ),
                              ),
                              widget: widget,
                              height: 250,
                            ),
                          ),
                    if (!isMine)
                      CustomText(
                        color: greyColor,
                        content:
                            widget.data.createdAt.split(' ')[1].substring(0, 5),
                        fontSize: FontSize.smallSize,
                      )
                  ],
                )
              ],
            ),
          ],
        ),
      ],
    );
  }

  CustomText checkAndTimeInfo() {
    return CustomText(
      color: greyColor,
      content: widget.data.createdAt.split(' ')[1].substring(0, 5),
      fontSize: FontSize.smallSize,
    );
  }
}

//* 채팅 이미지
class ChatImage extends StatelessWidget {
  final ChatListItem widget;
  final double height;
  final double? width;
  final ReturnVoid? onTap;
  final bool transparent;
  final bool hasRoundEdge;

  const ChatImage({
    super.key,
    required this.widget,
    required this.height,
    this.hasRoundEdge = true,
    this.width,
    this.onTap,
    this.transparent = true,
  });

  @override
  Widget build(BuildContext context) {
    return CustomBoxContainer(
      color: transparent ? transparentColor : blackColor.withOpacity(0.8),
      width: width,
      height: height,
      onTap: onTap,
      child: ClipRRect(
        borderRadius: hasRoundEdge ? BorderRadius.circular(8) : null,
        child: CachedNetworkImage(
          fit: BoxFit.fitWidth,
          imageUrl:
              '${dotenv.env['fileUrl']}/chats/${getGroupId(context)}/${widget.data.id}',
        ),
      ),
    );
  }
}