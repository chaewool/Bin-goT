import 'package:bin_got/models/group_model.dart';
import 'package:bin_got/widgets/group_rank.dart';
import 'package:bin_got/providers/group_provider.dart';
import 'package:bin_got/utilities/global_func.dart';
import 'package:bin_got/utilities/style_utils.dart';
import 'package:bin_got/widgets/container.dart';
import 'package:bin_got/widgets/list.dart';
import 'package:bin_got/widgets/row_col.dart';
import 'package:bin_got/widgets/text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GroupMain extends StatefulWidget {
  // final int groupId;
  // final String password;
  // final void Function({
  //   int? newMemberState,
  //   int? newSize,
  //   bool? newNeedAuth,
  //   int? newBingoId,
  // }) applyNew;
  const GroupMain({
    super.key,
    // required this.groupId,
    // required this.password,
    // required this.applyNew,
  });

  @override
  State<GroupMain> createState() => _GroupMainState();
}

class _GroupMainState extends State<GroupMain> {
  GroupDetailModel? groupDetailModel;
  int? memberState;
  int? groupId;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      groupId = getGroupId(context);
      // setPublic(context, widget.isPublic);
      print('----------- read group detail');
      GroupProvider().readGroupDetail(groupId!).then((data) {
        setState(() {
          print('set state 실행');
          groupDetailModel = data;
          memberState = data.memberState;
        });
        setGroupData(context, data);
        setBingoSize(context, data.bingoSize);
        setBingoId(context, data.bingoId);
      }).catchError((error) {
        print(error);
        showAlert(
          context,
          title: '오류 발생',
          content: '오류가 발생해 그룹 정보를 받아올 수 없습니다',
          hasCancel: false,
          onPressed: () {
            toBack(context);
          },
        )();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomBoxContainer(
      child: groupDetailModel != null
          ? ColWithPadding(
              vertical: 30,
              horizontal: 30,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                if (groupDetailModel!.hasImage)
                  CachedNetworkImage(
                    imageUrl: '${dotenv.env['fileUrl']}/groups/$groupId',
                    placeholder: (context, url) => const CustomBoxContainer(
                      width: 200,
                      height: 200,
                    ),
                  ),
                groupHeader(groupDetailModel!),
                const SizedBox(height: 20),
                ShowContentBox(
                  contentTitle: '설명',
                  content: groupDetailModel!.description,
                ),
                ShowContentBox(
                  contentTitle: '규칙',
                  content: groupDetailModel!.rule,
                ),
                groupRankTop3(context, groupDetailModel!),
              ],
            )
          : const SizedBox(),
    );
  }

  Padding groupRankTop3(BuildContext context, GroupDetailModel data) {
    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RowWithPadding(
            vertical: 10,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const CustomText(content: '순위'),
              if (memberState != 0)
                TextButton(
                  onPressed: toOtherPage(
                    context,
                    page: const GroupRank(),
                  ),
                  child: const CustomText(
                    content: '전체보기',
                    fontSize: FontSize.smallSize,
                  ),
                )
            ],
          ),
          if (data.rank.isNotEmpty)
            for (int i = 0; i < data.rank.length; i += 1)
              RankListItem(
                rank: i + 1,
                rankListItem: data.rank[i],
                isMember: memberState != 0,
              ),
          if (data.rank.isEmpty)
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText(
                  content: '달성한 목표가 있는 그룹원이\n존재하지 않습니다.',
                  height: 1.5,
                  center: true,
                ),
              ],
            )
        ],
      ),
    );
  }

  Column groupHeader(GroupDetailModel data) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 10),
          child: CustomText(
            content: data.groupName,
            fontSize: FontSize.titleSize,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 20),
          child: CustomText(content: '참여 인원 ${data.count}/${data.headCount}'),
        ),
        CustomText(content: '${data.start} ~ ${data.end}'),
      ],
    );
  }
}
