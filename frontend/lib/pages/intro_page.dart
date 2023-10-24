import 'package:bin_got/fcm_settings.dart';
import 'package:bin_got/pages/main_page.dart';
import 'package:bin_got/providers/root_provider.dart';
import 'package:bin_got/providers/user_provider.dart';
import 'package:bin_got/utilities/global_func.dart';
import 'package:bin_got/utilities/image_icon_utils.dart';
import 'package:bin_got/utilities/style_utils.dart';
import 'package:bin_got/utilities/type_def_utils.dart';
import 'package:bin_got/widgets/row_col.dart';
import 'package:bin_got/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//? 인트로 (토큰 확인, 자동 로그인)
class Intro extends StatefulWidget {
  const Intro({
    super.key,
  });

  @override
  State<Intro> createState() => _IntroState();
}

class _IntroState extends State<Intro> {
  //* 변수
  BoolList showList = List.generate(3, (_) => false);
  bool showLoginBtn = false;
  WidgetList appInfo = [
    halfLogo,
    const Padding(
      padding: EdgeInsets.only(top: 40, bottom: 20),
      child: CustomText(
        content: '당신을 채울',
        fontSize: FontSize.sloganSize,
      ),
    ),
    const CustomText(
      content: 'Bin:goT',
      fontSize: FontSize.sloganSize,
    ),
  ];

  //* 토큰 만료 여부 확인
  void verifyToken() async {
    try {
      await context.read<AuthProvider>().initVar();
      UserProvider().confirmToken().then((result) async {
        if (result.isEmpty) {
          FCM().saveFCMToken();
        } else {
          throw Error();
        }
      }).catchError((error) {
        setState(() {
          showLoginBtn = true;
        });
      });
    } catch (error) {
      setState(() {
        showLoginBtn = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    //* 투명도 조절 애니메이션 관련
    for (int i = 0; i < 3; i += 1) {
      afterFewSec(() {
        setState(() {
          showList[i] = true;
        });
      }, 500 * i + 500);
    }
    //* 토큰 만료 여부 검사
    verifyToken();
    //* 메인 페이지로 이동
    afterFewSec(() {
      if (!showLoginBtn) {
        toOtherPageWithoutPath(context, page: const Main());
      }
    }, 2000);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          ColWithPadding(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              //* 앱 정보
              for (int i = 0; i < 3; i += 1)
                AnimatedOpacity(
                  opacity: showList[i] ? 1 : 0,
                  duration: const Duration(milliseconds: 1000),
                  child: Center(child: appInfo[i]),
                ),
              const SizedBox(height: 100)
            ],
          ),
          //* 로그인 버튼
          if (showLoginBtn)
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () => login(context),
                  child: AnimatedOpacity(
                    opacity: showLoginBtn ? 1 : 0,
                    duration: const Duration(milliseconds: 1000),
                    child: Center(child: kakaoLogin),
                  ),
                ),
                const SizedBox(height: 60),
              ],
            )
        ],
      ),
    );
  }
}
