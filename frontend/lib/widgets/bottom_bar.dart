import 'package:bin_got/pages/group_chat.dart';
import 'package:bin_got/pages/group_form_page.dart';
import 'package:bin_got/pages/main_page.dart';
import 'package:bin_got/pages/user_page.dart';
import 'package:bin_got/utilities/global_func.dart';
import 'package:bin_got/utilities/image_icon_utils.dart';
import 'package:bin_got/utilities/style_utils.dart';
import 'package:bin_got/utilities/type_def_utils.dart';
import 'package:bin_got/widgets/box_container.dart';
import 'package:bin_got/widgets/button.dart';
import 'package:bin_got/widgets/input.dart';
import 'package:flutter/material.dart';

//* 그룹에서의 하단 바
class BottomBar extends StatelessWidget {
  final bool isMember;
  const BottomBar({
    super.key,
    required this.isMember,
  });

  @override
  Widget build(BuildContext context) {
    const IconDataList bottomBarIcons = [homeIcon, myPageIcon, chatIcon];
    const WidgetList nextPages = [Main(), MyPage(), GroupChat()];
    return isMember
        ? BottomNavigationBar(
            showSelectedLabels: false,
            showUnselectedLabels: false,
            items: [
              for (int i = 0; i < 3; i += 1)
                BottomNavigationBarItem(
                  icon: Center(
                    child: CustomIconButton(
                      onPressed: toOtherPage(
                        context: context,
                        page: nextPages[i],
                      ),
                      icon: bottomBarIcons[i],
                      size: 40,
                      color: greyColor,
                    ),
                  ),
                  label: 'home',
                ),
            ],
          )
        : BottomAppBar(
            child: SizedBox(
              height: 50,
              child: CustomButton(
                content: '가입 신청하기',
                onPressed: showAlert(
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

//* 그룹 생성 페이지 하단 버튼
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
              onPressed: isFirstPage
                  ? toBack(context: context)
                  : toOtherPage(
                      context: context,
                      page: const GroupFirstForm(),
                    ),
              content: isFirstPage ? '취소' : '이전'),
          CustomButton(
              onPressed: toOtherPage(
                  context: context,
                  page: isFirstPage
                      ? const GroupSecondForm()
                      : const GroupCreateCompleted()),
              content: isFirstPage ? '다음' : '완료')
        ],
      ),
    );
  }
}

//* 그룹 채팅 입력 하단 바
class GroupChatBottomBar extends StatelessWidget {
  const GroupChatBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomBoxContainer(
      hasRoundEdge: false,
      color: greyColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Flexible(child: CustomIconButton(onPressed: () {}, icon: addIcon)),
          const Flexible(
            flex: 5,
            child: CustomInput(
              filled: true,
              explain: '내용을 입력하세요',
            ),
          ),
          Flexible(child: CustomIconButton(onPressed: () {}, icon: sendIcon)),
        ],
      ),
    );
  }
}
