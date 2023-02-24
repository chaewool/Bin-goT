import 'package:bin_got/utilities/image_icon_utils.dart';
import 'package:bin_got/utilities/style_utils.dart';
import 'package:bin_got/widgets/button.dart';
import 'package:bin_got/widgets/tab_bar.dart';
import 'package:bin_got/widgets/text.dart';
import 'package:flutter/material.dart';

class MyPage extends StatelessWidget {
  final String nickname;
  const MyPage({super.key, this.nickname = '조코링링링'});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: greenColor),
                width: 40,
                height: 40,
              ),
              Row(
                children: [
                  CustomText(content: nickname, fontSize: FontSize.titleSize),
                  CustomIconButton(
                    onPressed: () {},
                    icon: editIcon,
                    size: 20,
                  )
                ],
              ),
            ],
          ),
          const Expanded(child: MyPageTabBar())
        ],
      ),
    );
  }
}
