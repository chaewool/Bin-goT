import 'package:bin_got/pages/main_page.dart';
import 'package:bin_got/utilities/global_func.dart';
import 'package:bin_got/utilities/image_icon_utils.dart';
import 'package:bin_got/utilities/style_utils.dart';
import 'package:bin_got/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Intro extends StatefulWidget {
  const Intro({super.key});

  @override
  State<Intro> createState() => _IntroState();
}

class _IntroState extends State<Intro> {
  late SharedPreferences prefs;
  var showLogo = false;
  var showExplain = false;
  var showTitle = false;

  Future initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
  }

  @override
  void initState() {
    super.initState();
    initPrefs();
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
                // onTap: () => UserProvider.login(context),
                onTap: toOtherPage(context: context, page: const Main()),
                child: kakaoLogin,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
