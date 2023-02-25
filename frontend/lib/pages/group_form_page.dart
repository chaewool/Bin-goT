import 'package:bin_got/pages/group_main_page.dart';
import 'package:bin_got/utilities/global_func.dart';
import 'package:bin_got/utilities/image_icon_utils.dart';
import 'package:bin_got/utilities/style_utils.dart';
import 'package:bin_got/utilities/type_def_utils.dart';
import 'package:bin_got/widgets/bottom_bar.dart';
import 'package:bin_got/widgets/button.dart';
import 'package:bin_got/widgets/check_box.dart';
import 'package:bin_got/widgets/input.dart';
import 'package:bin_got/widgets/modal.dart';
import 'package:bin_got/widgets/select_box.dart';
import 'package:bin_got/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//* 그룹 생성/수정 첫 번째 페이지
class GroupFirstForm extends StatefulWidget {
  const GroupFirstForm({super.key});

  @override
  State<GroupFirstForm> createState() => _GroupFirstFormState();
}

class _GroupFirstFormState extends State<GroupFirstForm> {
  @override
  Widget build(BuildContext context) {
    const StringList bingoSize = ['N * N', '2 * 2', '3 * 3', '4 * 4', '5 * 5'];
    const StringList joinMethod = ['그룹장의 승인 필요', '자동 가입'];
    // void datePicker() {
    // }

    return Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
            child: Column(
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
                const CustomCheckBox(label: '공개 여부'),
                const CustomInput(explain: '그룹 가입 시 비밀번호'),
              ],
            ),
          ),
        ),
        bottomNavigationBar: const FormBottomBar(isFirstPage: true));
  }
}

//* 그룹 생성/수정 두 번째 페이지
class GroupSecondForm extends StatelessWidget {
  const GroupSecondForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const CustomInput(explain: '그룹 설명을 입력하세요', needMore: true),
              const CustomInput(explain: '그룹 규칙을 입력하세요', needMore: true),
              GestureDetector(
                onTap: () => showDialog(
                  context: context,
                  builder: (context) => const ImageModal(),
                ),
                child: const CustomInput(
                  explain: '그룹 이미지를 선택하세요',
                  needMore: true,
                  enabled: false,
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const FormBottomBar(isFirstPage: false),
    );
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
      body: Column(
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
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.black)),
            child: Center(
              child: CustomText(
                content: message,
                fontSize: FontSize.textSize,
                center: true,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CustomIconButton(
                  onPressed: shareToFriends, icon: shareIcon),
              CustomIconButton(onPressed: copyText, icon: copyIcon),
            ],
          ),
          CustomButton(
            content: '닫기',
            onPressed: () =>
                toOtherPage(context: context, page: const GroupMain()),
          )
        ],
      ),
    );
  }
}
