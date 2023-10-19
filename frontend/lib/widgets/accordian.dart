import 'package:bin_got/providers/group_provider.dart';
import 'package:bin_got/utilities/global_func.dart';
import 'package:bin_got/utilities/image_icon_utils.dart';
import 'package:bin_got/utilities/style_utils.dart';
import 'package:bin_got/widgets/container.dart';
import 'package:bin_got/widgets/button.dart';
import 'package:bin_got/widgets/image.dart';
import 'package:bin_got/widgets/list_item.dart';
import 'package:bin_got/widgets/text.dart';
import 'package:flutter/material.dart';

//? 아코디언

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
          title: widget.isMember ? '회원 탈퇴' : '가입 신청 ${grant ? '승인' : '거부'}',
          content: widget.isMember
              ? '해당 회원을 탈퇴시키겠습니까?'
              : '가입 신청 ${grant ? '승인' : '거부'}하시겠습니까?',
          onPressed: () async {
            GroupProvider().grantThisMember(
              getGroupId(context)!,
              {'target_id': widget.id, 'grant': grant},
            ).then((value) {
              setState(() {
                showElement = false;
              });
              toBack(context);
            }).catchError((_) {
              showErrorModal(
                  context,
                  '${widget.isMember ? '회원 탈퇴' : '가입 신청 ${grant ? '승인' : '거부'}'} 발생',
                  '오류가 발생해 요청이 처리되지 않았습니다.');
            });
          },
        )();
      } catch (error) {
        showErrorModal(
            context,
            '${widget.isMember ? '회원 탈퇴' : '가입 신청 ${grant ? '승인' : '거부'}'} 발생',
            '오류가 발생해 요청이 처리되지 않았습니다.');
      }
    }

    late Color backgroundColor;
    late Color textColor;

    if (getId(context) == widget.id) {
      backgroundColor = palePinkColor;
      textColor = whiteColor;
    } else {
      backgroundColor = whiteColor;
      textColor = blackColor;
    }

    return widget.isMember
        ? CustomList(
            color: backgroundColor,
            innerHorizontal: 15,
            height: 70,
            border: true,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 7),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleContainer(
                    color: whiteColor,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: CustomCachedNetworkImage(
                        path: '/badges/${widget.badge}',
                      ),
                    ),
                  ),
                  CustomText(content: widget.nickname, color: textColor),
                  getId(context) != widget.id
                      ? IconButtonInRow(
                          icon: closeIcon,
                          onPressed: () => manageMember(false),
                          color: blackColor,
                        )
                      : const SizedBox()
                ],
              ),
            ),
          )
        : showElement
            ? EachAccordion(
                question: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleContainer(
                      child: CustomCachedNetworkImage(
                        path: '/badges/${widget.badge}',
                      ),
                    ),
                    CustomText(content: widget.nickname),
                  ],
                ),
                answer: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: CircleContainer(
                          child: CustomCachedNetworkImage(
                            path: '/boards/${widget.bingoId}',
                            width: 270,
                            height: 150,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomButton(
                            content: '수락',
                            onPressed: () => manageMember(true),
                            color: paleRedColor,
                            textColor: whiteColor,
                          ),
                          const SizedBox(width: 20),
                          CustomButton(
                            content: '거부',
                            onPressed: () => manageMember(false),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              )
            : const SizedBox();
  }
}
