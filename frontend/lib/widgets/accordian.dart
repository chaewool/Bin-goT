import 'package:bin_got/providers/group_provider.dart';
import 'package:bin_got/utilities/global_func.dart';
import 'package:bin_got/utilities/image_icon_utils.dart';
import 'package:bin_got/utilities/style_utils.dart';
import 'package:bin_got/widgets/container.dart';
import 'package:bin_got/widgets/button.dart';
import 'package:bin_got/widgets/list.dart';
import 'package:bin_got/widgets/text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class EachAccordion extends StatefulWidget {
  final Widget question, answer;
  const EachAccordion(
      {super.key, required this.question, required this.answer});

  @override
  State<EachAccordion> createState() => _EachAccordionState();
}

class _EachAccordionState extends State<EachAccordion> {
  bool accordianState = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ExpansionPanelList(
        children: [
          ExpansionPanel(
            canTapOnHeader: true,
            headerBuilder: (context, isExpended) => Center(
              child: widget.question,
            ),
            body: Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: Center(
                child: widget.answer,
              ),
            ),
            isExpanded: accordianState,
          )
        ],
        expansionCallback: (panelIndex, isExpanded) {
          setState(() {
            accordianState = !accordianState;
          });
        },
      ),
    );
  }
}

//* group admin
class MemberList extends StatefulWidget {
  final int id, bingoId, badge;
  final String nickname;
  final bool isMember;
  const MemberList({
    super.key,
    required this.id,
    required this.nickname,
    required this.isMember,
    required this.bingoId,
    required this.badge,
  });

  @override
  State<MemberList> createState() => _MemberListState();
}

class _MemberListState extends State<MemberList> {
  bool showElement = true;
  @override
  Widget build(BuildContext context) {
    void manageMember(bool grant) {
      try {
        showAlert(
          context,
          title: '가입 신청 ${grant ? '승인' : '거부'}',
          content: '가입 신청 ${grant ? '승인' : '거부'}하시겠습니까?',
          onPressed: () async {
            print(getGroupId(context));
            print(
              {'target_id': widget.id, 'grant': grant},
            );
            await GroupProvider().grantThisMember(
              getGroupId(context)!,
              {'target_id': widget.id, 'grant': grant},
            );
            setState(() {
              showElement = false;
            });
            toBack(context);
          },
        )();
      } catch (error) {
        showAlert(context,
            title: '요청 실패', content: '오류가 발생해 요청한 작업이 처리되지 않았습니다.')();
      }
    }

    return widget.isMember
        ? CustomList(
            height: 70,
            // boxShadow: const [defaultShadow],
            border: true,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleContainer(
                  child: CachedNetworkImage(
                    imageUrl: '${dotenv.env['fileUrl']}/badges/${widget.badge}',
                    placeholder: (context, url) =>
                        const SizedBox(width: 50, height: 50),
                  ),
                ),
                CustomText(content: widget.nickname),
                getId(context) != widget.id
                    ? IconButtonInRow(
                        icon: closeIcon,
                        onPressed: () => manageMember(false),
                        color: blackColor,
                      )
                    : const CustomBoxContainer(
                        color: paleOrangeColor,
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CustomText(
                            content: '그룹장',
                            color: whiteColor,
                          ),
                        ),
                      ),
              ],
            ),
          )
        : showElement
            ? EachAccordion(
                question: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleContainer(
                      child: CachedNetworkImage(
                        imageUrl:
                            '${dotenv.env['fileUrl']}/badges/${widget.badge}',
                        placeholder: (context, url) =>
                            const SizedBox(width: 50, height: 50),
                      ),
                    ),
                    CustomText(content: widget.nickname),
                    Row(
                      children: [
                        IconButtonInRow(
                          icon: confirmIcon,
                          onPressed: () => manageMember(true),
                          color: greenColor,
                        ),
                        IconButtonInRow(
                          icon: closeIcon,
                          onPressed: () => manageMember(false),
                          color: widget.isMember ? blackColor : redColor,
                        ),
                      ],
                    )
                  ],
                ),
                answer: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CachedNetworkImage(
                    imageUrl:
                        '${dotenv.env['fileUrl']}/boards/${widget.bingoId}',
                  ),
                ),
                // Image.network('${dotenv.env['fileUrl']}/bingos/$bingoId'),
              )
            : const SizedBox();
  }
}
