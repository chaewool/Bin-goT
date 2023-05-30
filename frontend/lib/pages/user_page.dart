import 'package:bin_got/pages/help_page.dart';
import 'package:bin_got/pages/intro_page.dart';
import 'package:bin_got/providers/root_provider.dart';
import 'package:bin_got/providers/user_info_provider.dart';
import 'package:bin_got/utilities/global_func.dart';
import 'package:bin_got/utilities/image_icon_utils.dart';
import 'package:bin_got/utilities/style_utils.dart';
import 'package:bin_got/utilities/type_def_utils.dart';
import 'package:bin_got/widgets/app_bar.dart';
import 'package:bin_got/widgets/button.dart';
import 'package:bin_got/widgets/container.dart';
import 'package:bin_got/widgets/input.dart';
import 'package:bin_got/widgets/modal.dart';
import 'package:bin_got/widgets/row_col.dart';
import 'package:bin_got/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

//* 마이페이지 메인
class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  late bool isEditMode;
  String username = '';
  String newName = '';
  int badgeId = 0;

  StringList notificationList = [
    '진행률/랭킹 알림',
    '남은 기간 알림',
    '채팅 알림',
    '인증 완료 알림',
  ];
  List<StringList> notificationOptions = [
    ['ON', 'OFF'],
    ['ON', 'OFF'],
    ['ON', 'OFF'],
    ['ON', 'OFF']
  ];
  List optionList = [];

  void changeEditMode() {
    print('pressed');
    setState(() {
      isEditMode = !isEditMode;
    });
  }

  void changeIdx(int i) {
    setState(() {
      final noti = context.read<NotiProvider>();
      optionList[i] = !optionList[i];
      switch (i) {
        case 0:
          return noti.setStoreRank(optionList[i]);
        case 1:
          return noti.setStoreDue(optionList[i]);
        default:
          return noti.setStoreChat(optionList[i]);
      }
    });
  }

  void logout() {
    context.read<AuthProvider>().deleteVar();
    context.read<NotiProvider>().deleteVar();
    toOtherPageWithoutPath(context, page: const Intro())();
  }

  void changeName() {
    if (username != newName) {
      UserInfoProvider().changeName(newName).then((_) {
        showAlert(context, title: '닉네임 변경 완료', content: '닉네임이 변경되었습니다.')();
        changeEditMode();
        setState(() {
          username = newName;
        });
      });
    }
  }

  void setName(String newVal) {
    setState(() {
      newName = newVal;
    });
  }

  @override
  void initState() {
    super.initState();
    UserInfoProvider().getProfile().then((data) {
      print('data: $data');
      setState(() {
        username = data.username;
        newName = data.username;
        badgeId = data.badgeId;
      });
    });
    isEditMode = false;
    final noti = context.read<NotiProvider>();
    optionList.add(noti.rankNoti);
    optionList.add(noti.dueNoti);
    optionList.add(noti.chatNoti);
    optionList.add(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const MyPageAppBar(),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(flex: 3, child: profile(context)),
          Flexible(
            flex: 8,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const CustomText(content: '알림 설정'),
                const SizedBox(height: 15),
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
                          content: notificationOptions[i]
                              [optionList[i] ? 0 : 1],
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
              onTap: showAlert(
                context,
                title: '로그아웃 확인',
                content: '로그아웃하시겠습니까?',
                onPressed: logout,
              ),
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
      horizontal: 15,
      children: [
        Flexible(
          child: CircleContainer(
            onTap: showModal(
              context,
              page: SelectBadgeModal(
                presentBadge: badgeId,
              ),
            ),
            child: badgeId != 0
                ? Center(
                    child: Image.network(
                      '${dotenv.env['fileUrl']}/badges/$badgeId',
                    ),
                  )
                : const SizedBox(),
          ),
        ),
        Flexible(
          flex: 5,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: isEditMode
                ? [
                    Flexible(
                      flex: 11,
                      child: Center(
                        child: CustomInput(
                          height: 35,
                          initialValue: newName,
                          setValue: setName,
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 3,
                      child: IconButtonInRow(
                        icon: confirmIcon,
                        color: greenColor,
                        onPressed: changeName,
                      ),
                    ),
                    Flexible(
                      flex: 3,
                      child: IconButtonInRow(
                        icon: closeIcon,
                        color: redColor,
                        onPressed: changeEditMode,
                      ),
                    ),
                  ]
                : [
                    Flexible(
                      flex: 6,
                      child: Center(
                        child: CustomText(
                          content: username,
                          fontSize: FontSize.titleSize,
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 2,
                      child: IconButtonInRow(
                        onPressed: changeEditMode,
                        icon: editIcon,
                      ),
                    ),
                  ],
          ),
        ),
      ],
    );
  }
}
