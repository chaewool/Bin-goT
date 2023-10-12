import 'package:bin_got/pages/help_page.dart';
import 'package:bin_got/pages/notification_page.dart';
import 'package:bin_got/providers/user_info_provider.dart';
import 'package:bin_got/providers/user_provider.dart';
import 'package:bin_got/utilities/global_func.dart';
import 'package:bin_got/utilities/image_icon_utils.dart';
import 'package:bin_got/utilities/style_utils.dart';
import 'package:bin_got/utilities/type_def_utils.dart';
import 'package:bin_got/widgets/button.dart';
import 'package:bin_got/widgets/container.dart';
import 'package:bin_got/widgets/icon.dart';
import 'package:bin_got/widgets/modal.dart';
import 'package:bin_got/widgets/row_col.dart';
import 'package:bin_got/widgets/switch_indicator.dart';
import 'package:bin_got/widgets/text.dart';
import 'package:bin_got/widgets/toast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:package_info_plus/package_info_plus.dart';

//? 설정
class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  String username = '';
  StringMap newName = {'value': ''};
  int badgeId = 0;
  List<int?> cntList = List.generate(3, (index) => null);

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
        cntList[0] = data.numberOfCompleted;
        cntList[1] = data.numberOfWon;
        cntList[2] = data.ownBadges;
      });
    }).catchError((error) {
      cntList[0] = 0;
      cntList[1] = 0;
      cntList[2] = 0;
    });
  }

  //* 문의하기
  void sendEmail() async {
    String? emailBody;
    try {
      emailBody = await body();
      final Email email = Email(
        subject: '[Bin:goT] 문의사항',
        recipients: ['celpegor216@gmail.com'],
        body: emailBody,
        isHTML: false,
      );
      await FlutterEmailSender.send(email);
    } catch (error) {
      showModal(
        context,
        page: CustomModal(
          title: '문의하기',
          cancelText: '양식 복사하기',
          hasConfirm: false,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 15,
              ),
              child: SingleChildScrollView(
                child: CustomBoxContainer(
                  color: greyColor.withOpacity(0.4),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: CustomText(
                      content: inquiryBody(),
                      fontSize: FontSize.smallSize,
                      height: 1.4,
                    ),
                  ),
                ),
              ),
            ),
          ],
          onCancelPressed: () {
            Clipboard.setData(
                ClipboardData(text: emailBody ?? inquiryForm(true)));
            toBack(context);
          },
        ),
      )();
    }
  }

  Padding modalMessage(String message) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 15,
      ),
      child: SingleChildScrollView(
        child: CustomBoxContainer(
          color: greyColor.withOpacity(0.4),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: CustomText(
              content: message,
              fontSize: FontSize.smallSize,
              height: 1.4,
            ),
          ),
        ),
      ),
    );
  }

  //* 문의하기 내부 내용
  String inquiryForm([bool needEmail = false]) {
    return '''
${needEmail ? '이메일 주소 : celpegor216@gmail.com' : ''}
\n\n\n카테고리 : 문의사항 / 오류신고 / 개선의견 / 기타\n
답변 받으실 이메일 : \n
문의 내용 : \n \n \n
''';
  }

  String inquiryBody() {
    return '''안녕하세요, Bin:goT 개발팀입니다.\n
저희 서비스에 관심을 가지고 사용해주셔서 감사합니다.\n \n
양식에 맞추어 celpegor216@gmail.com 으로
메일을 보내주시면 빠르게 검토하여 답변 드리겠습니다.
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
${inquiryBody()}
${inquiryForm()}

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

  void exitService() {
    UserProvider().exitService().then((_) {
      deleteVar(context);
      showAlert(
        context,
        title: '탈퇴 완료',
        content: '성공적으로 탈퇴되었습니다',
        onPressed: () => toOtherPageWithoutPath(context),
      )();
    }).catchError((_) {
      showAlert(
        context,
        title: '탈퇴 실패',
        content: '오류가 발생해 탈퇴에 실패했습니다',
      )();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          child: ColWithPadding(
            horizontal: 15,
            vertical: 10,
            mainAxisSize: MainAxisSize.max,
            children: [
              profile(context),
              eachSection(
                title: '설정',
                options: [
                  eachOption(
                    icon: bellIcon,
                    title: '알림 설정',
                    onTap: toOtherPage(
                      context,
                      page: const NotificationSettings(),
                    ),
                  )
                ],
              ),
              eachSection(
                title: '소통',
                options: [
                  eachOption(
                    icon: helpIcon,
                    title: '도움말',
                    onTap: toOtherPage(
                      context,
                      page: const Help(),
                    ),
                  ),
                  eachOption(
                    icon: talkIcon,
                    title: '문의하기',
                    onTap: sendEmail,
                  ),
                ],
              ),
              eachSection(
                title: '방침',
                options: [
                  eachOption(
                    icon: policyIcon,
                    title: '개인 정보 처리 방침',
                    onTap: showModal(
                      context,
                      page: PolicyModal(),
                    ),
                  ),
                  eachOption(
                    icon: licenseIcon,
                    title: '라이선스',
                    onTap: showModal(
                      context,
                      page: const LicenseModal(),
                    ),
                  ),
                ],
              ),
              eachSection(
                title: '기타',
                hasDivider: false,
                options: [
                  eachOption(
                    icon: tempExitIcon,
                    title: '로그아웃',
                    onTap: showAlert(
                      context,
                      title: '로그아웃 확인',
                      content: '로그아웃하시겠습니까?',
                      onPressed: logout,
                    ),
                    moveToOther: false,
                  ),
                  eachOption(
                    icon: exitIcon,
                    title: '회원 탈퇴',
                    onTap: showAlert(
                      context,
                      title: '탈퇴 확인',
                      content: '서비스에서 탈퇴하시겠습니까?',
                      onPressed: exitService,
                    ),
                    moveToOther: false,
                  ),
                ],
              ),
            ],
          ),
        ),
        if (watchAfterWork(context))
          CustomToast(content: watchToastString(context))
      ],
    );
  }

  Padding eachOption({
    required IconData icon,
    required String title,
    required ReturnVoid onTap,
    bool moveToOther = true,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      child: CustomBoxContainer(
        onTap: onTap,
        child: RowWithPadding(
          horizontal: 10,
          mainAxisAlignment: moveToOther
              ? MainAxisAlignment.spaceBetween
              : MainAxisAlignment.start,
          children: [
            RowWithPadding(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomIcon(icon: icon),
                const SizedBox(width: 10),
                CustomText(content: title),
              ],
            ),
            if (moveToOther) const CustomIcon(icon: rightIcon)
          ],
        ),
      ),
    );
  }

  Padding profile(BuildContext context) {
    const iconList = [
      checkIcon,
      Icons.format_list_numbered,
      Icons.badge_outlined,
    ];
    const explainList = ['모두 채운\n빙고판', '랭킹 1위\n', '획득 배지\n'];
    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 10, 5, 15),
      child: Column(
        children: [
          CustomBoxContainer(
            color: palePinkColor,
            boxShadow: [shadowWithOpacity],
            child: ColWithPadding(
              horizontal: 10,
              vertical: 10,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RowWithPadding(
                  vertical: 10,
                  horizontal: 15,
                  children: [
                    const SizedBox(height: 5),
                    Flexible(
                      child: CircleContainer(
                        color: whiteColor,
                        onTap: showModal(
                          context,
                          page: SelectBadgeModal(
                            presentBadge: badgeId,
                            onPressed: changeBadge,
                          ),
                        ),
                        child: badgeId != 0
                            ? Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: CachedNetworkImage(
                                  imageUrl:
                                      '${dotenv.env['fileUrl']}/badges/$badgeId',
                                  placeholder: (context, url) =>
                                      const SizedBox(width: 50, height: 50),
                                ),
                              )
                            : const SizedBox(),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Flexible(
                      flex: 4,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            flex: 5,
                            child: Center(
                              child: CustomText(
                                content: newName['value']!,
                                fontSize: FontSize.largeSize,
                                color: whiteColor,
                                bold: true,
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 2,
                            child: IconButtonInRow(
                              onPressed: showModal(context,
                                  page: ChangeNameModal(
                                    username: newName['value'],
                                    afterWork: (value) {
                                      setState(() {
                                        newName['value'] = value;
                                      });
                                    },
                                  )),
                              icon: editIcon,
                              color: whiteColor,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: CustomBoxContainer(
              boxShadow: [defaultShadow],
              child: RowWithPadding(
                vertical: 10,
                horizontal: 10,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  for (int i = 0; i < 3; i += 1)
                    Flexible(
                      child: Column(
                        children: [
                          CustomIcon(
                            icon: iconList[i],
                            size: 40,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: CustomText(
                                content: cntList[i] != null
                                    ? '${cntList[i]} ${i != 1 ? '개' : '회'}'
                                    : ''),
                          ),
                          CustomText(
                            content: explainList[i],
                            fontSize: FontSize.tinySize,
                            center: true,
                            height: 1.2,
                          ),
                          const SizedBox(height: 10)
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  ColWithPadding eachSection({
    required String title,
    required WidgetList options,
    bool hasDivider = true,
  }) {
    return ColWithPadding(
      vertical: 3,
      mainAxisAlignment: hasDivider
          ? MainAxisAlignment.spaceBetween
          : MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          content: title,
          fontSize: FontSize.tinySize,
          color: greyColor,
        ),
        const SizedBox(height: 5),
        ...options,
        if (hasDivider) const CustomDivider(vertical: 10),
      ],
    );
  }
}
