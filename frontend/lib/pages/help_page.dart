import 'package:bin_got/utilities/global_func.dart';
import 'package:bin_got/utilities/image_icon_utils.dart';
import 'package:bin_got/utilities/style_utils.dart';
import 'package:bin_got/utilities/type_def_utils.dart';
import 'package:bin_got/widgets/app_bar.dart';
import 'package:bin_got/widgets/button.dart';
import 'package:bin_got/widgets/container.dart';
import 'package:flutter/material.dart';

//? 도움말
class Help extends StatefulWidget {
  const Help({super.key});

  @override
  State<Help> createState() => _HelpState();
}

class _HelpState extends State<Help> {
  //* 변수
  StringList imagePathList =
      List.generate(8, (index) => 'assets/images/00${index + 1}.png');
  int index = 0;
  late int length;

  @override
  void initState() {
    super.initState();
    //* 변수 초기화
    length = imagePathList.length;
  }

  //* 이미지 변경
  void moveTo([toRight = false]) {
    if (toRight) {
      if (index < length - 1) {
        setState(() {
          index += 1;
        });
      }
    } else if (index > 0) {
      setState(() {
        index -= 1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final image = Image.asset(
      imagePathList[index],
      fit: BoxFit.fitHeight,
    );
    return Scaffold(
      appBar: const AppBarWithBack(title: '도움말'),
      body: Stack(
        children: [
          //* 도움말 이미지
          CustomBoxContainer(
            height: getHeight(context),
            onTap: showModal(
              context,
              page: InteractiveViewer(
                child: CustomBoxContainer(
                  onTap: () => toBack(context),
                  color: blackColor,
                  child: image,
                ),
              ),
            ),
            child: image,
          ),
          //* 이미지 이동 버튼
          Positioned(
            top: getHeight(context) / 2 - 60,
            child: CustomIconButton(
              onPressed: () => moveTo(false),
              icon: leftIcon,
              color: index > 0 ? whiteColor : greyColor.withOpacity(0.3),
              size: 70,
            ),
          ),
          Positioned(
            top: getHeight(context) / 2 - 60,
            left: getWidth(context) - 70,
            child: CustomIconButton(
              onPressed: () => moveTo(true),
              icon: rightIcon,
              color:
                  index < length - 1 ? whiteColor : greyColor.withOpacity(0.3),
              size: 70,
            ),
          ),
        ],
      ),
    );
  }
}
