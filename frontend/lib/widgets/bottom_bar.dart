import 'package:bin_got/pages/bingo_form_page.dart';
import 'package:bin_got/pages/group_chat_page.dart';
import 'package:bin_got/pages/main_page.dart';
import 'package:bin_got/pages/user_page.dart';
import 'package:bin_got/utilities/global_func.dart';
import 'package:bin_got/utilities/image_icon_utils.dart';
import 'package:bin_got/utilities/style_utils.dart';
import 'package:bin_got/utilities/type_def_utils.dart';
import 'package:bin_got/widgets/container.dart';
import 'package:bin_got/widgets/button.dart';
import 'package:bin_got/widgets/input.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

//* 그룹에서의 하단 바
class BottomBar extends StatelessWidget {
  final int groupId;
  final int? size;
  final bool isMember;
  final bool? needAuth;
  const BottomBar({
    super.key,
    required this.groupId,
    required this.isMember,
    this.needAuth,
    this.size,
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
                    bingoSize: size!,
                    needAuth: needAuth!,
                    beforeJoin: true,
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
      color: greyColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CustomButton(onPressed: () => toBack(context), content: '취소'),
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
class GroupChatBottomBar extends StatefulWidget {
  final int groupId;
  final void Function(String?, XFile?) addChat;
  const GroupChatBottomBar({
    super.key,
    required this.groupId,
    required this.addChat,
  });

  @override
  State<GroupChatBottomBar> createState() => _GroupChatBottomBarState();
}

class _GroupChatBottomBarState extends State<GroupChatBottomBar> {
  @override
  Widget build(BuildContext context) {
    XFile? selectedImage;
    StringMap data = {'content': ''};

    void imagePicker() async {
      final ImagePicker picker = ImagePicker();
      final localImage = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 50,
      );
      selectedImage = localImage;
    }

    return CustomBoxContainer(
      hasRoundEdge: false,
      color: greyColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Flexible(
              child: CustomIconButton(onPressed: imagePicker, icon: addIcon)),
          Flexible(
            flex: 5,
            child: CustomInput(
              filled: true,
              explain: '내용을 입력하세요',
              setValue: (value) {
                data['content'] = value.trim();
              },
            ),
          ),
          Flexible(
            child: CustomIconButton(
              onPressed: () => widget.addChat(data['content'], selectedImage),
              icon: sendIcon,
            ),
          ),
        ],
      ),
    );
  }
}
