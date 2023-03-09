import 'package:bin_got/pages/group_main_page.dart';
import 'package:bin_got/utilities/global_func.dart';
import 'package:bin_got/utilities/image_icon_utils.dart';
import 'package:bin_got/utilities/style_utils.dart';
import 'package:bin_got/utilities/type_def_utils.dart';
import 'package:bin_got/widgets/bottom_bar.dart';
import 'package:bin_got/widgets/box_container.dart';
import 'package:bin_got/widgets/button.dart';
import 'package:bin_got/widgets/check_box.dart';
import 'package:bin_got/widgets/input.dart';
import 'package:bin_got/widgets/modal.dart';
import 'package:bin_got/widgets/row_col.dart';
import 'package:bin_got/widgets/select_box.dart';
import 'package:bin_got/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//* 그룹 생성/수정 첫 번째 페이지
class GroupForm extends StatefulWidget {
  const GroupForm({super.key});

  @override
  State<GroupForm> createState() => _GroupFormState();
}

class _GroupFormState extends State<GroupForm> {
  @override
  Widget build(BuildContext context) {
    const StringList bingoSize = ['N * N', '2 * 2', '3 * 3', '4 * 4', '5 * 5'];
    const StringList joinMethod = ['그룹장의 승인 필요', '자동 가입'];
    // void datePicker() {
    // }

    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: ColWithPadding(
            horizontal: 30,
            vertical: 40,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CustomInput(explain: '그룹명을 입력하세요'),
              const CustomInput(explain: '참여인원', onlyNum: true),
              const InputDate(explain: '기간'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  SelectBox(selectList: bingoSize, width: 60, height: 50),
                  SelectBox(selectList: joinMethod, width: 150, height: 50),
                ],
              ),
              CustomCheckBox(
                label: '공개 여부',
                value: true,
                onChange: (p0) {},
              ),
              const CustomInput(explain: '그룹 가입 시 비밀번호'),
              const CustomInput(explain: '그룹 설명을 입력하세요', needMore: true),
              const CustomInput(explain: '그룹 규칙을 입력하세요', needMore: true),
              GestureDetector(
                onTap: showModal(context: context, page: const ImageModal()),
                child: const CustomInput(
                  explain: '그룹 이미지를 선택하세요',
                  needMore: true,
                  enabled: false,
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: const FormBottomBar());
  }
}

//* 그룹 생성 완료 페이지
class GroupCreateCompleted extends StatelessWidget {
  final bool isPrivate;
  final String password;
  const GroupCreateCompleted(
      {super.key, this.isPrivate = false, this.password = ''});

  @override
  Widget build(BuildContext context) {
    String privateInvitation = isPrivate ? '비밀번호 : $password' : '';
    String message =
        'ㅇㅇㅇ 그룹에서\n당신을 기다리고 있어요\nBin:goT에서\n같이 계획을 공유해보세요\n $privateInvitation';
    void copyText() {
      Clipboard.setData(ClipboardData(text: message));
    }

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
                center: true,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const IconButtonInRow(
                onPressed: shareToFriends,
                icon: shareIcon,
              ),
              IconButtonInRow(
                onPressed: copyText,
                icon: copyIcon,
              ),
            ],
          ),
          CustomButton(
            content: '생성된 그룹으로 가기',
            onPressed: toOtherPage(context: context, page: const GroupMain()),
          )
        ],
      ),
    );
  }
}
