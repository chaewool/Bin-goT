import 'package:bin_got/providers/user_provider.dart';
import 'package:bin_got/utilities/global_func.dart';
import 'package:bin_got/utilities/image_icon_utils.dart';
import 'package:bin_got/utilities/style_utils.dart';
import 'package:bin_got/widgets/text.dart';
import 'package:flutter/material.dart';

class Intro extends StatefulWidget {
  const Intro({super.key});

  @override
  State<Intro> createState() => _IntroState();
}

class _IntroState extends State<Intro> {
  var showLogo = false;
  var showExplain = false;
  var showTitle = false;

  void login() async {
    try {
      print(UserProvider.token());
      // final response = await UserProvider.login();
    } catch (error) {
      showAlert(
          context: context, title: '로그인 오류', content: '오류가 발생해 로그인에 실패했습니다.');
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        showLogo = true;
      });
    });
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        showExplain = true;
      });
    });
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        showTitle = true;
      });
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
              GestureDetector(
                onTap: login,
                // onTap: toOtherPage(context: context, page: const Main()),
                child: kakaoLogin,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
