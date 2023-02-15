import 'package:bin_got/pages/group_form_page.dart';
import 'package:bin_got/pages/main_page.dart';
import 'package:bin_got/widgets/button.dart';
import 'package:flutter/material.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 40),
            label: 'home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, size: 40),
            label: 'myPage',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat, size: 40),
            label: 'groupChat',
          ),
        ]);
  }
}

class FormBottomBar extends StatelessWidget {
  final bool isFirstPage;
  const FormBottomBar({super.key, required this.isFirstPage});

  @override
  Widget build(BuildContext context) {
    void toNextPage() {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const GroupSecondForm()));
    }

    void toMainPage() {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const Main()));
    }

    void toBeforePage() {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const GroupFirstForm()));
    }

    void toCompletePage() {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const GroupCreateCompleted()));
    }

    return BottomAppBar(
        color: Colors.grey,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CustomButton(
                methodFunc: isFirstPage ? toMainPage : toBeforePage,
                buttonText: isFirstPage ? '취소' : '이전'),
            CustomButton(
                methodFunc: isFirstPage ? toNextPage : toCompletePage,
                buttonText: isFirstPage ? '다음' : '완료')
          ],
        ));
  }
}
