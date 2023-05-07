import 'package:bin_got/pages/bingo_form_page.dart';
import 'package:bin_got/pages/group_chat_page.dart';
import 'package:bin_got/pages/main_page.dart';
import 'package:bin_got/pages/user_page.dart';
import 'package:bin_got/providers/root_provider.dart';
import 'package:bin_got/utilities/global_func.dart';
import 'package:bin_got/utilities/image_icon_utils.dart';
import 'package:bin_got/utilities/style_utils.dart';
import 'package:bin_got/utilities/type_def_utils.dart';
import 'package:bin_got/widgets/box_container.dart';
import 'package:bin_got/widgets/button.dart';
import 'package:bin_got/widgets/input.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//* 그룹에서의 하단 바
class BottomBar extends StatelessWidget {
  final int groupId;
  final bool isMember;
  final bool? needAuth;
  const BottomBar({
    super.key,
    required this.groupId,
    required this.isMember,
    this.needAuth,
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
                content: '빙고 만들고 가입${needAuth == true ? ' 신청' : ''}하기',
                onPressed: toOtherPage(
                  context,
                  page: BingoForm(
                    bingoSize: context.read<GlobalGroupProvider>().bingoSize!,
                    needAuth: needAuth!,
                  ),
                ),
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
