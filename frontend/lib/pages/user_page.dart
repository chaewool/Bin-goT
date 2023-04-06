import 'package:bin_got/utilities/global_func.dart';
import 'package:bin_got/utilities/image_icon_utils.dart';
import 'package:bin_got/utilities/style_utils.dart';
import 'package:bin_got/utilities/type_def_utils.dart';
import 'package:bin_got/widgets/accordian.dart';
import 'package:bin_got/widgets/app_bar.dart';
import 'package:bin_got/widgets/button.dart';
import 'package:bin_got/widgets/input.dart';
import 'package:bin_got/widgets/modal.dart';
import 'package:bin_got/widgets/badge.dart';
import 'package:bin_got/widgets/row_col.dart';
import 'package:bin_got/widgets/text.dart';
import 'package:flutter/material.dart';

//* 마이페이지 메인
class MyPage extends StatefulWidget {
  final String nickname;
  const MyPage({super.key, this.nickname = '조코링링링'});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  late bool isEditMode;
  void changeEditMode() {
    setState(() {
      isEditMode = !isEditMode;
    });
  }

  StringList notificationList = [
    '진행률/랭킹 알림',
    '남은 기간 알림',
    '채팅 알림',
    '인증 완료 알림',
  ];
  List<StringList> notificationOptions = [
    ['ON', 'OFF'],
    ['세 달', '한 달', '일주일', '3일'],
    ['ON', 'OFF'],
    ['ON', 'OFF']
  ];
  IntList idxList = [0, 0, 0, 0];
  void changeIdx(int i) {
    if (i != 1) {
      setState(() {
        idxList[i] = 1 - idxList[i];
      });
    } else if (idxList[i] < 3) {
      setState(() {
        idxList[i] += 1;
      });
    } else {
      setState(() {
        idxList[i] = 0;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    isEditMode = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyPageAppBar(),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(flex: 3, child: profile(context)),
          Flexible(
            flex: 7,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const CustomText(content: '알림 설정'),
                for (int i = 0; i < 4; i += 1)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Flexible(flex: 2, child: SizedBox()),
                      Flexible(
                        flex: 4,
                        child: CustomText(
                          content: notificationList[i],
                          fontSize: FontSize.smallSize,
                        ),
                      ),
                      Flexible(
                        flex: 2,
                        child: CustomButton(
                          content: notificationOptions[i][idxList[i]],
                          onPressed: () => changeIdx(i),
                        ),
                      ),
                      const Flexible(flex: 2, child: SizedBox()),
                    ],
                  ),
              ],
            ),
          ),
          Flexible(
            flex: 2,
            child: CustomTextButton(
              content: '도움말',
              onTap: toOtherPage(context, page: const Help()),
            ),
          ),
          Flexible(
            flex: 2,
            child: CustomTextButton(
              content: '문의하기',
              onTap: () {},
            ),
          ),
          Flexible(
            flex: 2,
            child: CustomTextButton(
              content: '개인 정보 처리 방침',
              onTap: () {},
            ),
          ),
          Flexible(
            flex: 2,
            child: CustomTextButton(
              content: '라이선스',
              onTap: () {},
            ),
          ),
          Flexible(
            flex: 2,
            child: CustomTextButton(
              content: '로그아웃',
              onTap: showAlert(context,
                  title: '로그아웃 확인', content: '로그아웃하시겠습니까?', onPressed: () {}),
            ),
          ),
          const Flexible(
              child: SizedBox(
            height: 10,
          ))
        ],
      ),
    );
  }

  RowWithPadding profile(BuildContext context) {
    return RowWithPadding(
      vertical: 20,
      horizontal: 40,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomBadge(onTap: showModal(context, page: const SelectBadgeModal())),
        Row(
          children: isEditMode
              ? [
                  const CustomInput(
                    width: 150,
                    height: 30,
                  ),
                  IconButtonInRow(
                    icon: confirmIcon,
                    onPressed: () {},
                    size: 20,
                  ),
                  IconButtonInRow(
                    icon: closeIcon,
                    onPressed: changeEditMode,
                    size: 20,
                  ),
                ]
              : [
                  SizedBox(
                    width: 150,
                    height: 40,
                    child: Center(
                      child: CustomText(
                          content: widget.nickname,
                          fontSize: FontSize.titleSize),
                    ),
                  ),
                  IconButtonInRow(
                    onPressed: changeEditMode,
                    icon: editIcon,
                    size: 20,
                  )
                ],
        ),
      ],
    );
  }
}

//* 도움말 페이지
class Help extends StatelessWidget {
  const Help({super.key});

  @override
  Widget build(BuildContext context) {
    StringList questionList = [
      '그룹은 어떻게 만드나요?',
      '빙고는 어떻게 생성하나요?',
      '그룹 초대는 어떻게 하나요?'
    ];
    StringList answerList = ['이렇게 만듭니다', '저렇게 생성합니다', '그렇게 합니다'];
    return Scaffold(
      appBar: const AppBarWithBack(title: '도움말'),
      body: SingleChildScrollView(
          child: ColWithPadding(
        horizontal: 20,
        vertical: 10,
        children: [
          for (int i = 0; i < 3; i += 1)
            EachAccordion(
              question: 'Q. ${questionList[i]}',
              answer: 'A. ${answerList[i]}',
            ),
        ],
      )),
    );
  }
}
