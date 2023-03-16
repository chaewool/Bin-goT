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
  Future initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
  }

  @override
  void initState() {
    super.initState();
    initPrefs();
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
              halfLogo,
              Column(
                children: const [
                  CustomText(content: '당신을 채울', fontSize: FontSize.sloganSize),
                  SizedBox(height: 20),
                  CustomText(content: 'Bin:goT', fontSize: FontSize.sloganSize),
                ],
              ),
              GestureDetector(
                // onTap: () => login(context),
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
