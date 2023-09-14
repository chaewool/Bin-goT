import 'package:bin_got/fcm_settings.dart';
import 'package:bin_got/pages/input_password_page.dart';
import 'package:bin_got/pages/main_page.dart';
import 'package:bin_got/providers/root_provider.dart';
import 'package:bin_got/providers/user_provider.dart';
import 'package:bin_got/utilities/global_func.dart';
import 'package:bin_got/utilities/image_icon_utils.dart';
import 'package:bin_got/utilities/style_utils.dart';
import 'package:bin_got/widgets/row_col.dart';
import 'package:bin_got/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Intro extends StatefulWidget {
  // final bool? isPublic;
  final int? groupId;
  final int initialIndex;
  const Intro({
    super.key,
    // this.isPublic,
    this.groupId,
    this.initialIndex = 1,
  });

  @override
  State<Intro> createState() => _IntroState();
}

class _IntroState extends State<Intro> {
  var showLogo = false;
  var showExplain = false;
  var showTitle = false;
  var showLoginBtn = false;

  void verifyToken() async {
    try {
      await context.read<AuthProvider>().initVar();
      UserProvider().confirmToken().then((result) async {
        print('intro => $result');
        if (result.isEmpty) {
          FCM().saveFCMToken();
        } else {
          throw Error();
        }
      }).catchError((error) {
        print('intro error => $error');
        setState(() {
          showLoginBtn = true;
        });
      });
    } catch (error) {
      print('오류 오류 => $error');
      setState(() {
        showLoginBtn = true;
      });
    }
  }

  // void initNoti() async {
  //   await context.read<NotiProvider>().initNoti();
  // }

  @override
  void initState() {
    super.initState();
    afterFewSec(500, () {
      setState(() {
        showLogo = true;
      });
    });
    afterFewSec(1000, () {
      setState(() {
        showExplain = true;
      });
    });
    afterFewSec(1500, () {
      setState(() {
        showTitle = true;
      });
    });
    verifyToken();
    // initNoti();
    afterFewSec(2000, () {
      if (!showLoginBtn) {
        toOtherPageWithoutPath(
          context,
          page: widget.groupId == null
              ? Main(initialPage: widget.initialIndex)
              : InputPassword(
                  isPublic: true,
                  groupId: widget.groupId!,
                ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SizedBox(
        height: getHeight(context),
        width: getWidth(context),
        child: ColWithPadding(
          vertical: 100,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            if (showLogo) halfLogo,
            Column(
              children: [
                if (showExplain)
                  const CustomText(
                    content: '당신을 채울',
                    fontSize: FontSize.sloganSize,
                  ),
                const SizedBox(height: 20),
                if (showTitle)
                  const CustomText(
                    content: 'Bin:goT',
                    fontSize: FontSize.sloganSize,
                  ),
              ],
            ),
            if (showLoginBtn)
              GestureDetector(
                onTap: () => login(context),
                child: kakaoLogin,
              )
          ],
        ),
      ),
    );
  }
}
