import 'package:bin_got/fcm_settings.dart';
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
  const Intro({
    super.key,
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
    afterFewSec(() {
      setState(() {
        showLogo = true;
      });
    }, 500);
    afterFewSec(() {
      setState(() {
        showExplain = true;
      });
    });
    afterFewSec(() {
      setState(() {
        showTitle = true;
      });
    }, 1500);
    verifyToken();
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
