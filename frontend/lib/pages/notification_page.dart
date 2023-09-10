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
  // List initialOption = [];
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
      print('${data.rank}, ${data.due}, ${data.chat}, ${data.check}');
      // initialOption = List.from(optionList);
    }).catchError((error) {
      print(error);
    });
  }

  void changeIdx(int i, bool value) {
    setState(() {
      optionList[i] = value;
    });
  }

  // void cancelChange() {
  //   optionList = List.from(initialOption);
  // }

  void applyNoti() {
    print('${{
      'noti_rank': optionList[0],
      'noti_due': optionList[1],
      'noti_chat': optionList[2],
      'noti_check': optionList[3],
    }}');
    UserInfoProvider().changeNoti({
      'noti_rank': optionList[0],
      'noti_due': optionList[1],
      'noti_chat': optionList[2],
      'noti_check': optionList[3],
    }).then((_) {
      print('apply');
      // initialOption = List.from(optionList);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBarWithBack(
        onPressedBack: () {
          toBack(context);
          applyNoti();
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
    );
  }
}