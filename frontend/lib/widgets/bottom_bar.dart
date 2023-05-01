import 'package:bin_got/pages/group_chat_page.dart';
import 'package:bin_got/pages/main_page.dart';
import 'package:bin_got/pages/user_page.dart';
import 'package:bin_got/providers/group_provider.dart';
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
  final int groupId;
  final bool isMember;
  const BottomBar({
    super.key,
    required this.groupId,
    required this.isMember,
  });

  @override
  Widget build(BuildContext context) {
    const IconDataList bottomBarIcons = [homeIcon, myPageIcon, chatIcon];
    const WidgetList nextPages = [Main(), MyPage(), GroupChat()];
    void joinGroup() async {
      try {
        await GroupProvider().joinGroup(groupId);
        if (!context.mounted) return;
        showAlert(
          context,
          title: '가입 신청',
          content: '가입 신청되었습니다.',
          hasCancel: false,
        )();
      } catch (error) {
        showAlert(
          context,
          title: '가입 오류',
          content: '오류가 발생해 가입이 되지 않았습니다.',
          hasCancel: false,
        )();
      }
    }

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
                        context,
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
                onPressed: joinGroup,
              ),
            ),
          );
  }
}

//* 그룹 생성 페이지 하단 버튼
class FormBottomBar extends StatelessWidget {
  final ReturnVoid createOrUpdate;
  const FormBottomBar({super.key, required this.createOrUpdate});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.grey,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CustomButton(onPressed: toBack(context), content: '취소'),
          CustomButton(
            onPressed: createOrUpdate,
            content: '완료',
          )
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
          Flexible(
            flex: 5,
            child: CustomInput(
              filled: true,
              explain: '내용을 입력하세요',
              setValue: (p0) {},
            ),
          ),
          Flexible(child: CustomIconButton(onPressed: () {}, icon: sendIcon)),
        ],
      ),
    );
  }
}
