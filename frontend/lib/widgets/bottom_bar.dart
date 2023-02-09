import 'package:flutter/material.dart';

class bottomBar extends StatelessWidget {
  const bottomBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(items: const <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Icon(
          Icons.home,
          size: 30,
        ),
        label: 'home',
      ),
      BottomNavigationBarItem(
        icon: Icon(
          Icons.person,
          size: 30,
        ),
        label: 'myPage',
      ),
      BottomNavigationBarItem(
        icon: Icon(
          Icons.chat,
          size: 30,
        ),
        label: 'groupChat',
      ),
    ]);
  }
}
