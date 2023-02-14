import 'package:bin_got/utilities/type_def.dart';
import 'package:bin_got/widgets/button.dart';
import 'package:bin_got/widgets/check_box.dart';
import 'package:bin_got/widgets/input.dart';
import 'package:bin_got/widgets/select_box.dart';
import 'package:flutter/material.dart';

class GroupFirstForm extends StatelessWidget {
  const GroupFirstForm({super.key});

  @override
  Widget build(BuildContext context) {
    const StringList bingoSize = ['N * N', '2 * 2', '3 * 3', '4 * 4', '5 * 5'];
    const StringList joinMethod = ['그룹장의 승인 필요', '자동 가입'];
    void toNextPage() {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const GroupSecondForm()));
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
        child: Column(
          children: [
            const InputText(explain: '그룹명을 입력하세요'),
            const InputNumber(explain: '참여인원'),
            const InputDate(explain: '시작일'),
            const InputDate(explain: '종료일'),
            const SelectBox(selectList: bingoSize),
            const SelectBox(selectList: joinMethod),
            const CustomCheckBox(label: '공개 여부'),
            const InputText(explain: '그룹 가입 시 비밀번호'),
            CustomButton(methodFunc: () {}, buttonText: '취소'),
            CustomButton(methodFunc: toNextPage, buttonText: '다음')
          ],
        ),
      ),
      // bottomNavigationBar:
      //     topBar(context: context, isMainPage: false, methodFunc1: () {}),
    );
  }
}

class GroupSecondForm extends StatelessWidget {
  const GroupSecondForm({super.key});

  @override
  Widget build(BuildContext context) {
    void toBeforePage() {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const GroupSecondForm()));
    }

    void toCompletePage() {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const GroupCreateCompleted()));
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
        child: Column(
          children: [
            const InputText(explain: '그룹 설명을 입력하세요'),
            const InputText(explain: '그룹 규칙을 입력하세요'),
            const InputText(explain: '그룹 이미지를 선택하세요'),
            CustomButton(methodFunc: toBeforePage, buttonText: '이전'),
            CustomButton(methodFunc: toCompletePage, buttonText: '완료')
          ],
        ),
      ),
      // bottomNavigationBar:
      //     topBar(context: context, isMainPage: false, methodFunc1: () {}),
    );
  }
}

class GroupCreateCompleted extends StatelessWidget {
  const GroupCreateCompleted({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('그룹 생성'),
          const Text('친구 초대'),
          Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            child: const Text('초대 내용'),
          ),
          IconButton(onPressed: () {}, icon: const Icon(Icons.copy))
        ],
      ),
    );
  }
}
