import 'package:bin_got/pages/input_password_page.dart';
import 'package:bin_got/pages/main_page.dart';
import 'package:bin_got/providers/root_provider.dart';
import 'package:bin_got/providers/user_provider.dart';
import 'package:bin_got/utilities/global_func.dart';
import 'package:bin_got/utilities/image_icon_utils.dart';
import 'package:bin_got/utilities/style_utils.dart';
import 'package:bin_got/utilities/type_def_utils.dart';
import 'package:bin_got/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Intro extends StatefulWidget {
  final bool? isPublic;
  final int? groupId;
  const Intro({
    super.key,
    this.isPublic,
    this.groupId,
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
          saveFCMToken();
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

  void initNoti() async {
    await context.read<NotiProvider>().initNoti();
  }

  void afterFewSec(int millisec, ReturnVoid changeVar) {
    Future.delayed(Duration(milliseconds: millisec), () {
      setState(changeVar);
    });
  }

  @override
  void initState() {
    super.initState();
    afterFewSec(500, () {
      showLogo = true;
    });
    afterFewSec(1000, () {
      showExplain = true;
    });
    afterFewSec(1500, () {
      showTitle = true;
    });
    verifyToken();
    initNoti();
    afterFewSec(2000, () {
      if (!showLoginBtn) {
        toOtherPageWithoutPath(
          context,
          page: widget.groupId == null
              ? const Main()
              : InputPassword(
                  isPublic: widget.isPublic!,
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
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 100),
          child: Column(
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
      ),
    );
  }
}
