import 'package:bin_got/utilities/type_def_utils.dart';
import 'package:bin_got/widgets/bottom_bar.dart';
import 'package:bin_got/widgets/check_box.dart';
import 'package:bin_got/widgets/input.dart';
import 'package:bin_got/widgets/select_box.dart';
import 'package:flutter/material.dart';

//* 그룹 생성/수정 첫 번째 페이지
class GroupFirstForm extends StatelessWidget {
  const GroupFirstForm({super.key});

  @override
  Widget build(BuildContext context) {
    const StringList bingoSize = ['N * N', '2 * 2', '3 * 3', '4 * 4', '5 * 5'];
    const StringList joinMethod = ['그룹장의 승인 필요', '자동 가입'];

    return Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
            child: Column(
              children: const [
                InputText(explain: '그룹명을 입력하세요'),
                InputNumber(explain: '참여인원'),
                InputDate(explain: '시작일'),
                InputDate(explain: '종료일'),
                SelectBox(selectList: bingoSize),
                SelectBox(selectList: joinMethod),
                CustomCheckBox(label: '공개 여부'),
                InputText(explain: '그룹 가입 시 비밀번호'),
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
            children: const [
              InputText(explain: '그룹 설명을 입력하세요', needMore: true),
              InputText(explain: '그룹 규칙을 입력하세요', needMore: true),
              InputText(explain: '그룹 이미지를 선택하세요', needMore: true),
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
