import 'package:bin_got/utilities/image_icon_utils.dart';
import 'package:bin_got/utilities/style_utils.dart';
import 'package:bin_got/widgets/icon.dart';
import 'package:bin_got/widgets/list.dart';
import 'package:bin_got/widgets/text.dart';
import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:flutter/material.dart';

class BingoTabBar extends StatelessWidget {
  const BingoTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    const List<IconData> iconList = [colorIcon, drawIcon, fontIcon, emojiIcon];
    return Container(
      decoration: const BoxDecoration(),
      child: ContainedTabBarView(
        tabs: [
          for (IconData icon in iconList) Tab(icon: CustomIcon(icon: icon))
        ],
        views: [
          Container(color: Colors.red),
          Container(color: Colors.green),
          Container(color: Colors.amber),
          Container(color: Colors.black),
        ],
        onChange: (index) => {},
      ),
    );
  }
}

//* 그룹 관리 탭
class GroupAdminTabBar extends StatelessWidget {
  const GroupAdminTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(),
      child: ContainedTabBarView(
        tabs: const [
          Tab(
            child: CustomText(content: '가입 신청', fontSize: FontSize.largeSize),
          ),
          CustomText(content: '참여자', fontSize: FontSize.largeSize),
        ],
        views: [
          SingleChildScrollView(
            child: Column(
              children: [
                for (int i = 0; i < 10; i += 1)
                  MemberList(
                    image: halfLogo,
                    isMember: false,
                    nickname: '조코링링링',
                  )
              ],
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                for (int i = 0; i < 7; i += 1)
                  MemberList(
                    image: halfLogo,
                    isMember: true,
                    nickname: '조코링링링',
                  )
              ],
            ),
          ),
        ],
        onChange: (index) => {},
      ),
    );
  }
}
