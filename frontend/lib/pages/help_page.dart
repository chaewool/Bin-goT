//* 도움말 페이지
import 'package:bin_got/providers/root_provider.dart';
import 'package:bin_got/providers/user_provider.dart';
import 'package:bin_got/utilities/global_func.dart';
import 'package:bin_got/utilities/type_def_utils.dart';
import 'package:bin_got/widgets/accordian.dart';
import 'package:bin_got/widgets/app_bar.dart';
import 'package:bin_got/widgets/button.dart';
import 'package:bin_got/widgets/modal.dart';
import 'package:bin_got/widgets/row_col.dart';
import 'package:bin_got/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Help extends StatelessWidget {
  const Help({super.key});

  @override
  Widget build(BuildContext context) {
    StringList questionList = [
      '그룹은 어떻게 만드나요?',
      '빙고는 어떻게 생성하나요?',
      '그룹 초대는 어떻게 하나요?',
    ];
    StringList answerList = ['이렇게 만듭니다', '저렇게 생성합니다', '그렇게 합니다'];

    void exitService() {
      UserProvider().exitService().then((_) {
        context.read<AuthProvider>().deleteVar();
        context.read<NotiProvider>().deleteVar();
        showAlert(
          context,
          title: '탈퇴 완료',
          content: '성공적으로 탈퇴되었습니다',
          onPressed: () => toIntroPage(context),
        )();
      });
    }

    return Scaffold(
      appBar: const AppBarWithBack(title: '도움말'),
      body: SingleChildScrollView(
          child: ColWithPadding(
        horizontal: 20,
        vertical: 10,
        children: [
          for (int i = 0; i < 3; i += 1)
            EachAccordion(
              question: CustomText(content: 'Q. ${questionList[i]}'),
              answer: CustomText(content: 'A. ${answerList[i]}'),
            ),
          CustomButton(
            onPressed: showModal(
              context,
              page: CustomModal(
                onPressed: exitService,
                children: const [CustomText(content: '정말 탈퇴하시겠어요?')],
              ),
            ),
            content: '회원 탈퇴',
          )
        ],
      )),
    );
  }
}
