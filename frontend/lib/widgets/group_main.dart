import 'package:bin_got/providers/group_provider.dart';
import 'package:bin_got/providers/root_provider.dart';
import 'package:bin_got/utilities/global_func.dart';
import 'package:bin_got/utilities/style_utils.dart';
import 'package:bin_got/widgets/container.dart';
import 'package:bin_got/widgets/list.dart';
import 'package:bin_got/widgets/row_col.dart';
import 'package:bin_got/widgets/switch_indicator.dart';
import 'package:bin_got/widgets/text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

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
  // GroupDetailModel? groupDetailModel;
  int? memberState;
  int? groupId;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      groupId = getGroupId(context);
      // setPublic(context, widget.isPublic);
      setLoading(context, true);
      readGroupDetail();
    });
  }

  void readGroupDetail() {
    print('----------- read group detail');
    GroupProvider().readGroupDetail(groupId!).then((data) {
      setState(() {
        print('set state 실행');
        // groupDetailModel = data;
        memberState = data.memberState;
      });
      setGroupData(context, data);
      setBingoSize(context, data.bingoSize);
      setBingoId(context, data.bingoId);
      setLoading(context, false);
    }).catchError((error) {
      print(error);
      setLoading(context, false);
      showAlert(
        context,
        title: '오류 발생',
        content: '오류가 발생해 그룹 정보를 받아올 수 없습니다',
        hasCancel: false,
        onPressed: () {
          toBack(context);
          toBack(context);
        },
      )();
    });
  }

  @override
  Widget build(BuildContext context) {
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   if (watchRefresh(context)) {
    //     applyRefresh(context, false);
    //     readGroupDetail();
    //   }
    // });
    return CustomBoxContainer(
      child: !watchLoading(context)
          ? Column(
              children: [
                context.watch<GlobalGroupProvider>().hasImage
                    ? CustomBoxContainer(
                        width: getWidth(context),
                        child: CachedNetworkImage(
                          imageUrl: '${dotenv.env['fileUrl']}/groups/$groupId',
                          fit: BoxFit.fitWidth,
                          placeholder: (context, url) =>
                              const CustomBoxContainer(
                            width: 200,
                            height: 200,
                          ),
                        ),
                      )
                    : const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 10, 30, 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      groupHeader(context),
                      const SizedBox(height: 20),
                      ShowContentBox(
                        contentTitle: '설명',
                        content:
                            context.watch<GlobalGroupProvider>().description,
                      ),
                      ShowContentBox(
                        contentTitle: '규칙',
                        content: context.watch<GlobalGroupProvider>().rule,
                      ),
                      if (memberState != 0) groupRankTop3(context),
                    ],
                  ),
                ),
              ],
            )
          : const Center(child: CustomCirCularIndicator()),
    );
  }

  Padding groupRankTop3(BuildContext context) {
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
              TextButton(
                onPressed: () => changeGroupIndex(context, 2),
                child: const CustomText(
                  content: '전체보기',
                  fontSize: FontSize.smallSize,
                ),
              )
            ],
          ),
          if (getRank(context).isNotEmpty)
            for (int i = 0; i < getRank(context).length; i += 1)
              RankListItem(
                rank: i + 1,
                rankListItem: getRank(context)[i],
              ),
          if (getRank(context).isEmpty)
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

  Column groupHeader(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 10),
          child: CustomText(
            content: context.watch<GlobalGroupProvider>().groupName,
            fontSize: FontSize.titleSize,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 20),
          child: CustomText(
              content:
                  '참여 인원 ${context.watch<GlobalGroupProvider>().count ?? ''}/${context.watch<GlobalGroupProvider>().headCount ?? ''}'),
        ),
        CustomText(
            content:
                '${getStart(context)} ~ ${context.watch<GlobalGroupProvider>().end ?? ''}'),
      ],
    );
  }
}
