import 'package:bin_got/utilities/image_icon_utils.dart';
import 'package:bin_got/utilities/type_def_utils.dart';
import 'package:flutter/material.dart';

// 재사용 가능하게 수정
//
AppBar topBar(
    {required BuildContext context,
    required bool isMainPage,
    required ReturnVoid methodFunc1,
    ReturnVoid? methodFunc2}) {
  return AppBar(
    elevation: 0,
    backgroundColor: Colors.white,
    leading: Padding(
      padding: const EdgeInsets.all(6),
      child: halfLogo,
    ),
    actions: [
      isMainPage
          ? IconButton(onPressed: methodFunc1, icon: searchIcon)
          : const SizedBox(),
      isMainPage
          ? IconButton(onPressed: methodFunc2, icon: myPageIcon)
          : IconButton(onPressed: methodFunc1, icon: createGroupIcon)
    ],
  );
}
