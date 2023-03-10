import 'package:bin_got/utilities/global_func.dart';
import 'package:bin_got/utilities/image_icon_utils.dart';
import 'package:bin_got/utilities/style_utils.dart';
import 'package:bin_got/widgets/badge.dart';
import 'package:bin_got/widgets/bottom_bar.dart';
import 'package:bin_got/widgets/box_container.dart';
import 'package:bin_got/widgets/row_col.dart';
import 'package:bin_got/widgets/text.dart';
import 'package:flutter/material.dart';

class GroupChat extends StatefulWidget {
  const GroupChat({super.key});

  @override
  State<GroupChat> createState() => _GroupChatState();
}

class _GroupChatState extends State<GroupChat> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    chatBox(needAuth: true),
                    for (int i = 0; i < 10; i += 1) chatBox()
                  ],
                ),
              ),
            ),
            const GroupChatBottomBar()
          ],
        ),
      ),
    );
  }

  Padding chatBox({bool needAuth = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: CustomBoxContainer(
        onTap: needAuth
            ? showAlert(
                context: context,
                title: '인증 확인',
                content: '이 인증이 유효한가요?',
              )
            : null,
        color: paleRedColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            children: [
              const RowWithPadding(
                vertical: 5,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: CustomBadge(radius: 20),
                  ),
                  CustomText(
                    content: '조코조코링링링',
                    fontSize: FontSize.smallSize,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: CustomText(
                    content: needAuth ? '코딩테스트 10회 응시 (1/10)' : '채팅'),
              ),
              needAuth ? halfLogo : const SizedBox(),
              needAuth
                  ? const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: CustomText(
                        content: '유플러스 인턴십 코테도 인정이죠?',
                        fontSize: FontSize.smallSize,
                      ),
                    )
                  : const SizedBox()
            ],
          ),
        ),
      ),
    );
  }
}
