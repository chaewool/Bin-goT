import 'package:bin_got/pages/help_page.dart';
import 'package:bin_got/providers/root_provider.dart';
import 'package:bin_got/providers/user_info_provider.dart';
import 'package:bin_got/utilities/global_func.dart';
import 'package:bin_got/utilities/image_icon_utils.dart';
import 'package:bin_got/utilities/style_utils.dart';
import 'package:bin_got/utilities/type_def_utils.dart';
import 'package:bin_got/widgets/app_bar.dart';
import 'package:bin_got/widgets/button.dart';
import 'package:bin_got/widgets/container.dart';
import 'package:bin_got/widgets/modal.dart';
import 'package:bin_got/widgets/row_col.dart';
import 'package:bin_got/widgets/text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

//* 마이페이지 메인
class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  String username = '';
  StringMap newName = {'value': ''};
  int badgeId = 0;
  bool canEditNoti = false;

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
  List initialOption = [];

  void changeNoti(bool newVal) {
    setState(() {
      canEditNoti = newVal;
    });
  }

  void changeIdx(int i) {
    if (canEditNoti) {
      setState(() {
        optionList[i] = !optionList[i];
      });
    }

    // switch (i) {
    //   case 0:
    //     return context.read<NotiProvider>().setStoreRank(optionList[i]);
    //   case 1:
    //     return context.read<NotiProvider>().setStoreDue(optionList[i]);
    //   case 2:
    //     return context.read<NotiProvider>().setStoreChat(optionList[i]);
    //   default:
    //     return context.read<NotiProvider>().setStoreComplete(optionList[i]);
    // }
  }

  void cancelChange() {
    optionList = List.from(initialOption);
    changeNoti(false);
  }

  void applyNoti() {
    UserInfoProvider().changeNoti({
      'noti_rank': optionList[0],
      'noti_chat': optionList[1],
      'noti_due': optionList[2],
      'noti_check': optionList[3],
    }).then((_) {
      changeNoti(false);
      context.read<NotiProvider>().setStoreRank(optionList[0]);
      context.read<NotiProvider>().setStoreDue(optionList[1]);
      context.read<NotiProvider>().setStoreChat(optionList[2]);
      context.read<NotiProvider>().setStoreComplete(optionList[3]);
      initialOption = List.from(optionList);
    });
  }

  void logout() {
    deleteVar(context);
    toOtherPageWithoutPath(context);
  }

  @override
  void initState() {
    super.initState();
    UserInfoProvider().getProfile().then((data) {
      setState(() {
        username = data.username;
        newName['value'] = data.username;
        badgeId = data.badgeId;
      });
    }).catchError((error) {
      showErrorModal(context);
    });
    optionList.add(context.read<NotiProvider>().rankNoti);
    optionList.add(context.read<NotiProvider>().dueNoti);
    optionList.add(context.read<NotiProvider>().chatNoti);
    optionList.add(context.read<NotiProvider>().completeNoti);
    initialOption = List.from(optionList);
  }

  //* 문의하기
  void sendEmail() async {
    String? emailBody;
    try {
      emailBody = await body();
      final Email email = Email(
        subject: '[화장실을 찾아서] 문의사항',
        recipients: ['team.4ilet@gmail.com'],
        body: emailBody,
        isHTML: false,
      );
      await FlutterEmailSender.send(email);
    } catch (error) {
      showModal(
        context,
        page: CustomAlert(
          title: '문의하기',
          content: emailBody ?? inquiryBody(),
          onPressed: () => Clipboard.setData(
              ClipboardData(text: emailBody ?? inquiryBody())),
        ),
      );
    }
  }

  //* 문의하기 내부 내용

  String inquiryBody() {
    return '''안녕하세요, Bin:goT 개발팀입니다.\n
저희 서비스에 관심을 보내주셔서 감사합니다.\n
아래 양식에 맞추어 (이메일)에
문의사항을 보내 주시면 빠르게 검토하여 답변 드리겠습니다.\n
카테고리 : 오류 / 기능 제안 / 기타\n
답변 받으실 이메일 : \n
문의 내용 : \n
''';
  }

  Future<String> body() async {
    try {
      WidgetsFlutterBinding.ensureInitialized();
      DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
      final deviceInfo = await deviceInfoPlugin.deviceInfo;
      final info = deviceInfo.data;
      final version = info['version'];
      final manufacturer = info['manufacturer'];
      final model = info['model'];
      final device = info['device'];

      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String appVersion = packageInfo.version;
      return '''
안녕하세요, Bin:goT 개발팀입니다.\n
저희 서비스에 관심을 보내주셔서 감사합니다.\n
아래 양식에 맞추어 문의사항을 작성해 주시면 빠르게 검토하여 답변 드리겠습니다.\n
카테고리 : 오류 / 기능 제안 / 기타\n
답변 받으실 이메일 : \n
문의 내용 : \n
OS 버전: Android ${version['release']} (SDK ${version['sdkInt']})
사용 기종 : $manufacturer $model $device \n
사용 버전 : $appVersion \n
''';
    } catch (error) {
      throw Error();
    }
  }

  void changeBadge(int newId) {
    setState(() {
      badgeId = newId;
    });
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 60),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const CustomText(content: '알림 설정'),
                      canEditNoti
                          ? Row(
                              children: [
                                IconButtonInRow(
                                  icon: confirmIcon,
                                  color: greenColor,
                                  onPressed: applyNoti,
                                ),
                                IconButtonInRow(
                                  icon: closeIcon,
                                  color: redColor,
                                  onPressed: cancelChange,
                                ),

                                // CustomButton(
                                //   content: '적용',
                                //   onPressed: changeNoti,
                                // ),
                                // CustomButton(
                                //   content: '취소',
                                //   onPressed: () {
                                //     setState(() {
                                //       applyNoti = false;
                                //     });
                                //   },
                                // ),
                              ],
                            )
                          : IconButtonInRow(
                              onPressed: () => changeNoti(true),
                              icon: editIcon,
                              size: 25,
                            ),
                      // CustomButton(
                      //     content: '수정',
                      //     onPressed: () {
                      //       setState(() {
                      //         applyNoti = true;
                      //       });
                      //     },
                      //   ),
                    ],
                  ),
                ),
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
              onTap: toOtherPage(
                context,
                page: const Help(),
              ),
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
            ),
          )
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
                  presentBadge: badgeId, onPressed: changeBadge),
            ),
            child: badgeId != 0
                ? Center(
                    child: CachedNetworkImage(
                      imageUrl: '${dotenv.env['fileUrl']}/badges/$badgeId',
                      placeholder: (context, url) =>
                          const SizedBox(width: 50, height: 50),
                    ),
                  )
                : const SizedBox(),
          ),
        ),
        Flexible(
          flex: 4,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:
                // isEditMode
                //     ? [
                //         Flexible(
                //           flex: 11,
                //           child: Center(
                //             child: CustomInput(
                //               height: 35,
                //               initialValue: newName['value'],
                //               setValue: setName,
                //             ),
                //           ),
                //         ),
                //         Flexible(
                //           flex: 3,
                //           child: IconButtonInRow(
                //             icon: confirmIcon,
                //             color: greenColor,
                //             onPressed: changeName,
                //           ),
                //         ),
                //         Flexible(
                //           flex: 3,
                //           child: IconButtonInRow(
                //             icon: closeIcon,
                //             color: redColor,
                //             onPressed: changeEditMode,
                //           ),
                //         ),
                //       ]
                //     :
                [
              Flexible(
                flex: 5,
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
                  onPressed: showModal(
                    context,
                    page: const ChangeNameModal(),
                  ),
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
