import 'package:bin_got/pages/help_page.dart';
import 'package:bin_got/pages/notification_page.dart';
import 'package:bin_got/providers/user_info_provider.dart';
import 'package:bin_got/utilities/global_func.dart';
import 'package:bin_got/utilities/image_icon_utils.dart';
import 'package:bin_got/utilities/style_utils.dart';
import 'package:bin_got/utilities/type_def_utils.dart';
import 'package:bin_got/widgets/button.dart';
import 'package:bin_got/widgets/container.dart';
import 'package:bin_got/widgets/icon.dart';
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

//* 마이페이지 메인
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
      showErrorModal(context);
    });
  }

  //* 문의하기
  void sendEmail() async {
    String? emailBody;
    try {
      emailBody = await body();
      final Email email = Email(
        subject: '[Bin:goT] 문의사항',
        recipients: [''],
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
    return SingleChildScrollView(
      child: ColWithPadding(
        horizontal: 15,
        vertical: 10,
        mainAxisSize: MainAxisSize.max,
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          profile(context),
          eachSection(
            // flex: 2,
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
            // flex: 4,
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
                icon: Icons.question_answer_outlined,
                title: '문의하기',
                onTap: () {},
              ),
            ],
          ),
          eachSection(
            // flex: 4,
            title: '방침',
            options: [
              eachOption(
                icon: Icons.question_answer_outlined,
                title: '개인 정보 처리 방침',
                onTap: () {},
              ),
              eachOption(
                icon: Icons.question_answer_outlined,
                title: '라이선스',
                onTap: () {},
              ),
            ],
          ),
          eachSection(
            // flex: 2,
            title: '기타',
            hasDivider: false,
            options: [
              eachOption(
                icon: Icons.question_answer_outlined,
                title: '로그아웃',
                onTap: showAlert(
                  context,
                  title: '로그아웃 확인',
                  content: '로그아웃하시겠습니까?',
                  onPressed: logout,
                ),
                moveToOther: false,
              ),
            ],
          ),
        ],
      ),
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
    const explainList = ['100% 달성 횟수', '1위 횟수', '배지 개수'];
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
                            ? Center(
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
                                content: username,
                                fontSize: FontSize.largeSize,
                                color: whiteColor,
                                bold: true,
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
              // borderColor: greyColor,
              boxShadow: [defaultShadow],
              child: RowWithPadding(
                vertical: 10,
                horizontal: 10,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  for (int i = 0; i < 3; i += 1)
                    Column(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomIcon(
                          icon: iconList[i],
                          size: 40,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: CustomText(
                              content:
                                  cntList[i] != null ? '${cntList[i]} 개' : ''),
                        ),
                        CustomText(
                          content: explainList[i],
                          fontSize: FontSize.tinySize,
                        ),
                        const SizedBox(height: 10)
                      ],
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
    // required int flex,
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
        if (hasDivider)
          const Divider(
            thickness: 1,
            color: greyColor,
          )
      ],
    );
  }
}
