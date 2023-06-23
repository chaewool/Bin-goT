//* 그룹 생성 완료 페이지
import 'package:bin_got/pages/group_main_page.dart';
import 'package:bin_got/utilities/global_func.dart';
import 'package:bin_got/utilities/image_icon_utils.dart';
import 'package:bin_got/utilities/style_utils.dart';
import 'package:bin_got/widgets/container.dart';
import 'package:bin_got/widgets/button.dart';
import 'package:bin_got/widgets/row_col.dart';
import 'package:bin_got/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GroupCreateCompleted extends StatelessWidget {
  final bool isPublic;
  final String password;
  final int groupId;
  const GroupCreateCompleted({
    super.key,
    this.isPublic = true,
    this.password = '',
    required this.groupId,
  });

  @override
  Widget build(BuildContext context) {
    String message =
        'ㅇㅇㅇ 그룹에서\n당신을 기다리고 있어요\nBin:goT에서\n같이 계획을 공유해보세요\n${isPublic ? '' : '비밀번호 : $password'}';
    return Scaffold(
      body: ColWithPadding(
        vertical: 60,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const CustomText(
            content: '그룹이\n생성되었습니다',
            fontSize: FontSize.titleSize,
            center: true,
          ),
          const CustomText(
            content: '친구들을\n초대해보세요',
            fontSize: FontSize.largeSize,
            center: true,
          ),
          CustomBoxContainer(
            width: 200,
            height: 200,
            borderColor: blackColor,
            child: Center(
              child: CustomText(
                content: message,
                fontSize: FontSize.smallSize,
                center: true,
                height: 1.7,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButtonInRow(
                onPressed: () => shareGroup(
                  groupId: groupId,
                  password: password,
                ),
                icon: shareIcon,
              ),
              IconButtonInRow(
                onPressed: () =>
                    Clipboard.setData(ClipboardData(text: message)),
                icon: copyIcon,
              ),
            ],
          ),
          CustomButton(
            content: '생성된 그룹으로 가기',
            onPressed: toOtherPage(
              context,
              page: GroupMain(
                groupId: groupId,
                isPublic: isPublic,
              ),
            ),
          )
        ],
      ),
    );
  }
}
