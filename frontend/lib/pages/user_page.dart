import 'package:bin_got/utilities/global_func.dart';
import 'package:bin_got/utilities/image_icon_utils.dart';
import 'package:bin_got/utilities/style_utils.dart';
import 'package:bin_got/widgets/app_bar.dart';
import 'package:bin_got/widgets/button.dart';
import 'package:bin_got/widgets/input.dart';
import 'package:bin_got/widgets/modal.dart';
import 'package:bin_got/widgets/my_page_widgets.dart';
import 'package:bin_got/widgets/tab_bar.dart';
import 'package:bin_got/widgets/text.dart';
import 'package:flutter/material.dart';

class MyPage extends StatefulWidget {
  final String nickname;
  const MyPage({super.key, this.nickname = '조코링링링'});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  late bool isEditMode;
  void changeEditMode() {
    setState(() {
      isEditMode = !isEditMode;
    });
  }

  @override
  void initState() {
    super.initState();
    isEditMode = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyPageAppBar(),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomBadge(
                    onTap: showModal(
                        context: context, page: const SelectBadgeModal())),
                Row(
                  children: isEditMode
                      ? [
                          const CustomInput(
                            width: 150,
                            height: 30,
                          ),
                          IconButtonInRow(
                            icon: confirmIcon,
                            onPressed: () {},
                            size: 20,
                          ),
                          IconButtonInRow(
                            icon: closeIcon,
                            onPressed: changeEditMode,
                            size: 20,
                          ),
                        ]
                      : [
                          SizedBox(
                            width: 150,
                            height: 40,
                            child: Center(
                              child: CustomText(
                                  content: widget.nickname,
                                  fontSize: FontSize.titleSize),
                            ),
                          ),
                          IconButtonInRow(
                            onPressed: changeEditMode,
                            icon: editIcon,
                            size: 20,
                          )
                        ],
                ),
              ],
            ),
          ),
          const Expanded(child: MyPageTabBar())
        ],
      ),
    );
  }
}

class Help extends StatelessWidget {
  const Help({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GroupAppBar(onlyBack: true),
      body: SingleChildScrollView(
          child: Column(
        children: const [],
      )),
    );
  }
}
