import 'package:bin_got/providers/user_info_provider.dart';
import 'package:bin_got/utilities/global_func.dart';
import 'package:bin_got/utilities/style_utils.dart';
import 'package:bin_got/utilities/type_def_utils.dart';
import 'package:bin_got/widgets/app_bar.dart';
import 'package:bin_got/widgets/row_col.dart';
import 'package:bin_got/widgets/switch_indicator.dart';
import 'package:bin_got/widgets/text.dart';
import 'package:flutter/material.dart';

class NotificationSettings extends StatefulWidget {
  const NotificationSettings({super.key});

  @override
  State<NotificationSettings> createState() => _NotificationSettingsState();
}

class _NotificationSettingsState extends State<NotificationSettings> {
  BoolList optionList = List.generate(4, (index) => false);
  StringList notificationList = [
    '진행률/랭킹 알림',
    '남은 기간 알림',
    '채팅 알림',
    '인증 완료 알림',
  ];

  @override
  void initState() {
    super.initState();
    UserInfoProvider().getNoti().then((data) {
      setState(() {
        optionList[0] = data.rank;
        optionList[1] = data.due;
        optionList[2] = data.chat;
        optionList[3] = data.check;
      });
    }).catchError((error) {
      showErrorModal(context);
    });
  }

  void changeIdx(int i, bool value) {
    setState(() {
      optionList[i] = value;
    });
  }

  void applyNoti() async {
    await UserInfoProvider().changeNoti({
      'noti_rank': optionList[0],
      'noti_due': optionList[1],
      'noti_chat': optionList[2],
      'noti_check': optionList[3],
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        applyNoti();
        toBack(context);
        return Future.value(false);
      },
      child: Scaffold(
        backgroundColor: whiteColor,
        appBar: AppBarWithBack(
          onPressedBack: () {
            applyNoti();
            toBack(context);
          },
        ),
        body: ColWithPadding(children: [
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
                  child: CustomSwitch(
                    value: optionList[i],
                    onChanged: (value) => changeIdx(i, value),
                  ),
                ),
                const Flexible(flex: 2, child: SizedBox()),
              ],
            ),
        ]),
      ),
    );
  }
}
