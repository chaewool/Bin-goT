import 'package:bin_got/pages/group_form_page.dart';
import 'package:bin_got/utilities/global_func.dart';
import 'package:bin_got/utilities/image_icon_utils.dart';
import 'package:bin_got/utilities/style_utils.dart';
import 'package:bin_got/widgets/button.dart';
import 'package:bin_got/widgets/icon.dart';
import 'package:flutter/material.dart';

class BottomBar extends StatelessWidget {
  final bool isMember;
  const BottomBar({
    super.key,
    required this.isMember,
  });

  @override
  Widget build(BuildContext context) {
    return isMember
        ? BottomNavigationBar(
            showSelectedLabels: false,
            showUnselectedLabels: false,
            items: const [
                BottomNavigationBarItem(
                  icon: CustomIcon(
                    icon: homeIcon,
                    size: 40,
                    color: greyColor,
                  ),
                  label: 'home',
                ),
                BottomNavigationBarItem(
                  icon: CustomIcon(
                    icon: myPageIcon,
                    size: 40,
                    color: greyColor,
                  ),
                  label: 'myPage',
                ),
                BottomNavigationBarItem(
                  icon: CustomIcon(
                    icon: chatIcon,
                    size: 40,
                    color: greyColor,
                  ),
                  label: 'groupChat',
                ),
              ])
        : BottomAppBar(
            child: SizedBox(
              height: 50,
              child: CustomButton(
                buttonText: '가입 신청하기',
                methodFunc: () => showAlert(
                  context: context,
                  title: '가입 신청',
                  content: '가입 신청되었습니다.',
                  hasCancel: false,
                ),
              ),
            ),
          );
  }
}

class FormBottomBar extends StatelessWidget {
  final bool isFirstPage;
  const FormBottomBar({super.key, required this.isFirstPage});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
        color: Colors.grey,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CustomButton(
                methodFunc: () => isFirstPage
                    ? toBack(context: context)
                    : toOtherPage(
                        context: context,
                        page: const GroupFirstForm(),
                      ),
                buttonText: isFirstPage ? '취소' : '이전'),
            CustomButton(
                methodFunc: () => toOtherPage(
                    context: context,
                    page: isFirstPage
                        ? const GroupSecondForm()
                        : const GroupCreateCompleted()),
                buttonText: isFirstPage ? '다음' : '완료')
          ],
        ));
  }
}
