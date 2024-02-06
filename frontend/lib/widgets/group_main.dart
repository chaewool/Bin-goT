import 'package:bin_got/providers/group_provider.dart';
import 'package:bin_got/providers/root_provider.dart';
import 'package:bin_got/utilities/global_func.dart';
import 'package:bin_got/utilities/style_utils.dart';
import 'package:bin_got/widgets/container.dart';
import 'package:bin_got/widgets/image.dart';
import 'package:bin_got/widgets/list_item.dart';
import 'package:bin_got/widgets/switch_indicator.dart';
import 'package:bin_got/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//? 그룹 메인 (정보 출력)

class GroupMain extends StatefulWidget {
  final void Function(int) changeIndex;
  const GroupMain({
    super.key,
    required this.changeIndex,
  });

  @override
  State<GroupMain> createState() => _GroupMainState();
}

class _GroupMainState extends State<GroupMain> {
  int? memberState;
  int? groupId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      groupId = getGroupId(context);
      setLoading(context, true);
      readGroupDetail();
    });
  }

  void readGroupDetail() {
    GroupProvider().readGroupDetail(groupId!).then((data) {
      setState(() {
        memberState = data.memberState;
      });
      setGroupData(context, data);
      setBingoSize(context, data.bingoSize);
      setBingoId(context, data.bingoId);
      setLoading(context, false);
    }).catchError((error) {
      setLoading(context, false);
      showAlert(
        context,
        title: '오류 발생',
        content: '오류가 발생해 그룹 정보를 받아올 수 없습니다',
        onPressed: () {
          toBack(context);
          toBack(context);
        },
      )();
    });
  }

  @override
  Widget build(BuildContext context) {
    return !watchLoading(context)
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              context.watch<GlobalGroupProvider>().hasImage
                  ? CustomBoxContainer(
                      hasRoundEdge: false,
                      width: getWidth(context),
                      height: 200,
                      child: CustomCachedNetworkImage(
                        path:
                            '/groups/${context.watch<GlobalGroupProvider>().groupId}',
                        width: getWidth(context),
                        height: 200,
                      ),
                    )
                  : const SizedBox(height: 30),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  groupHeader(context),
                  const SizedBox(height: 20),
                  ShowContentBox(
                    contentTitle: '설명',
                    content: watchDescription(context) != ''
                        ? watchDescription(context)
                        : '작성된 내용이 없습니다',
                    hasContent: watchDescription(context) != '',
                  ),
                  ShowContentBox(
                    contentTitle: '규칙',
                    content: watchRule(context) != ''
                        ? watchRule(context)
                        : '작성된 내용이 없습니다',
                    hasContent: watchRule(context) != '',
                  ),
                  if (memberState != 0) groupRankTop3(context),
                  const SizedBox(height: 20)
                ],
              ),
            ],
          )
        : const Center(child: CustomCirCularIndicator());
  }

  Padding groupRankTop3(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: CustomBoxContainer(
        width: 300,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                const CustomText(content: '순위'),
                TextButton(
                  onPressed: () => widget.changeIndex(2),
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
                  rankListItem: getRank(context)[i],
                  changeIndex: widget.changeIndex,
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
