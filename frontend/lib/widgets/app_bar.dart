import 'package:bin_got/pages/my_page.dart';
import 'package:bin_got/utilities/image_icon.dart';
import 'package:flutter/material.dart';

// 재사용 가능하게 수정
//
AppBar topBar(BuildContext context) {
  return AppBar(
    elevation: 0,
    backgroundColor: Colors.white,
    leading: Padding(
      padding: const EdgeInsets.all(6),
      child: halfLogo,
    ),
    actions: [
      IconButton(onPressed: () {}, icon: searchIcon),
      IconButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const MyPage()));
          },
          icon: myPageIcon)
    ],
  );
}
