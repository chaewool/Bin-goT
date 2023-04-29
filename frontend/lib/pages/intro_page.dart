import 'package:bin_got/pages/group_create_completed.dart';
import 'package:bin_got/pages/main_page.dart';
import 'package:bin_got/providers/root_provider.dart';
import 'package:bin_got/providers/user_provider.dart';
import 'package:bin_got/utilities/global_func.dart';
import 'package:bin_got/utilities/image_icon_utils.dart';
import 'package:bin_got/utilities/style_utils.dart';
import 'package:bin_got/utilities/type_def_utils.dart';
import 'package:bin_got/widgets/modal.dart';
import 'package:bin_got/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Intro extends StatefulWidget {
  const Intro({super.key});

  @override
  State<Intro> createState() => _IntroState();
}

class _IntroState extends State<Intro> {
  var showLogo = false;
  var showExplain = false;
  var showTitle = false;
  var showLoginBtn = false;

  void login() async {
    try {
      final data = await UserProvider().login();
      print('data: $data');
      if (!mounted) return;
      setTokens(context, data['access_token'], data['refresh_token']);
      setNoti(
        context,
        rank: data['noti_rank'],
        due: data['noti_due'],
        chat: data['noti_chat'],
      );
      if (data['is_login']) {
        toOtherPage(context, page: const Main())();
      } else {
        showModal(context, page: const InputModal(title: '닉네임 설정'));
      }
    } catch (error) {
      showAlert(context, title: '로그인 오류', content: '오류가 발생해 로그인에 실패했습니다.');
    }
  }

  void verifyToken() async {
    try {
      await context.read<AuthProvider>().initVar();
      final result = await UserProvider().confirmToken();
      if (result.isNotEmpty) {
        if (!mounted) return;
        setToken(context, result['token']);
      } else {
        showLoginBtn = true;
      }
    } catch (error) {
      setState(() {
        showLoginBtn = true;
      });
      return;
    }
  }

  void afterFewSec(int sec, ReturnVoid changeVar) {
    Future.delayed(Duration(seconds: sec), () {
      setState(changeVar);
    });
  }

  @override
  void initState() {
    super.initState();

    afterFewSec(1, () {
      showLogo = true;
    });
    afterFewSec(2, () {
      showExplain = true;
    });
    afterFewSec(3, () {
      showTitle = true;
    });
    verifyToken();
    afterFewSec(4, () {
      if (!showLoginBtn) {
        toOtherPage(context,
            page: const GroupCreateCompleted(
              groupId: 3,
            ))();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 100),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              showLogo ? halfLogo : const SizedBox(),
              Column(
                children: [
                  showExplain
                      ? const CustomText(
                          content: '당신을 채울', fontSize: FontSize.sloganSize)
                      : const SizedBox(),
                  const SizedBox(height: 20),
                  showTitle
                      ? const CustomText(
                          content: 'Bin:goT', fontSize: FontSize.sloganSize)
                      : const SizedBox(),
                ],
              ),
              showLoginBtn
                  ? GestureDetector(
                      onTap: login,
                      child: kakaoLogin,
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
