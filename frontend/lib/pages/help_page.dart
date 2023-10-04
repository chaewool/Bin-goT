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
  StringList imagePathList = List.from(backgroundList);
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
    return Scaffold(
      appBar: const AppBarWithBack(title: '도움말'),
      body: Stack(
        children: [
          // CustomIconButton(
          //   onPressed: () => moveTo(false),
          //   icon: leftIcon,
          //   size: 40,
          //   color: index > 0 ? palePinkColor : greyColor,
          // ),
          //* 도움말 이미지
          CustomBoxContainer(
            height: getHeight(context),
            child: Image.asset(
              imagePathList[index],
              fit: BoxFit.fitHeight,
            ),
          ),
          //* 이미지 이동 버튼
          CustomBoxContainer(
            color: transparentColor,
            height: getHeight(context),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomIconButton(
                  onPressed: () => moveTo(false),
                  icon: leftIcon,
                  color: index > 0 ? greyColor : greyColor.withOpacity(0.3),
                  size: 70,
                ),
                CustomIconButton(
                  onPressed: () => moveTo(true),
                  icon: rightIcon,
                  color: index < length - 1
                      ? greyColor
                      : greyColor.withOpacity(0.3),
                  size: 70,
                ),
                // FloatingActionButton(
                //   heroTag: 'leftIcon',
                //   backgroundColor: transparentColor,
                //   onPressed: () => moveTo(false),
                //   child: CustomIcon(
                //     icon: leftIcon,
                //     color: index > 0 ? palePinkColor : greyColor,
                //   ),
                // ),
                // FloatingActionButton(
                //   heroTag: 'rightIcon',
                //   backgroundColor: transparentColor,
                //   onPressed: () => moveTo(true),
                //   child: CustomIcon(
                //     icon: rightIcon,
                //     color: index < length - 1 ? palePinkColor : greyColor,
                //   ),
                // ),
              ],
            ),
          ),

          // CustomIconButton(
          //   onPressed: () => moveTo(true),
          //   icon: rightIcon,
          //   size: 40,
          //   color: index < length - 1 ? palePinkColor : greyColor,
          // ),
        ],
      ),
    );
  }
}
