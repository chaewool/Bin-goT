import 'package:bin_got/pages/bingo_detail_page.dart';
import 'package:bin_got/pages/bingo_form_page.dart';
import 'package:bin_got/pages/group_chat_page.dart';
import 'package:bin_got/pages/group_form_page.dart';
import 'package:bin_got/pages/input_password_page.dart';
import 'package:bin_got/pages/main_page.dart';
import 'package:bin_got/pages/user_page.dart';
import 'package:bin_got/utilities/global_func.dart';
import 'package:bin_got/utilities/image_icon_utils.dart';
import 'package:bin_got/utilities/style_utils.dart';
import 'package:bin_got/utilities/type_def_utils.dart';
import 'package:bin_got/widgets/button.dart';
import 'package:bin_got/widgets/container.dart';
import 'package:bin_got/widgets/icon.dart';
import 'package:bin_got/widgets/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:image_picker/image_picker.dart';

//* snake bottom bar
class CustomSnakeBottomBar extends StatelessWidget {
  final int selectedIndex;
  final List<BottomNavigationBarItem> items;
  final WidgetList nextPages;
  const CustomSnakeBottomBar({
    super.key,
    required this.selectedIndex,
    required this.items,
    required this.nextPages,
  });

  @override
  Widget build(BuildContext context) {
    return SnakeNavigationBar.color(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      snakeViewColor: paleRedColor,
      unselectedItemColor: greyColor,
      selectedItemColor: whiteColor,
      currentIndex: selectedIndex,
      onTap: (index) {
        if (index != selectedIndex) {
          toOtherPage(context, page: nextPages[index])();
        }
      },
      items: items,
    );
  }
}

//* 메인 하단 바
class MainBottomBar extends StatelessWidget {
  final int selectedIndex;

  const MainBottomBar({
    super.key,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    const WidgetList nextPages = [Main(), MyPage(), GroupForm()];
    final items = [
      customBottomBarIcon(
        label: '메인 페이지',
        assetPath: 'assets/logos/bin_got_logo_1x.png',
      ),
      customBottomBarIcon(label: '설정 페이지', iconData: settingsIcon),
      customBottomBarIcon(label: '그룹 생성 페이지', iconData: addIcon),
    ];
    return CustomSnakeBottomBar(
      selectedIndex: selectedIndex,
      items: items,
      nextPages: nextPages,
    );
  }
}

//* 그룹에서의 하단 바
class GroupMainBottomBar extends StatelessWidget {
  final int groupId, selectedIndex;
  final int? size, bingoId;
  final bool isMember;
  final bool? needAuth;
  const GroupMainBottomBar({
    super.key,
    required this.groupId,
    this.isMember = true,
    this.needAuth,
    this.size,
    required this.selectedIndex,
    this.bingoId,
  });

  @override
  Widget build(BuildContext context) {
    // const IconDataList bottomBarIcons = [homeIcon, myPageIcon, chatIcon];
    final WidgetList nextPages = [
      InputPassword(isPublic: true, groupId: groupId),
      BingoDetail(bingoId: bingoId!),
      GroupChat(bingoId: bingoId!)
    ];
    final items = [
      customBottomBarIcon(label: '그룹 메인 페이지', iconData: homeIcon),
      customBottomBarIcon(label: '빙고 상세 페이지', iconData: myPageIcon),
      customBottomBarIcon(label: '그룹 채팅 페이지', iconData: chatIcon),
    ];

    return isMember
        ? CustomSnakeBottomBar(
            items: items,
            selectedIndex: selectedIndex,
            nextPages: nextPages,
          )
        // BottomNavigationBar(
        //     showSelectedLabels: false,
        //     showUnselectedLabels: false,
        //     items: [
        //       for (int i = 0; i < 3; i += 1)
        //         BottomNavigationBarItem(
        //           icon: Center(
        //             child: CustomIconButton(
        //               onPressed: toOtherPage(
        //                 context,
        //                 page: nextPages[i],
        //               ),
        //               icon: bottomBarIcons[i],
        //               size: 40,
        //               color: greyColor,
        //             ),
        //           ),
        //           label: 'home',
        //         ),
        //     ],
        //   )
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
  final void Function(StringMap, XFile?) addChat;
  final XFile? selectedImage;
  final ReturnVoid imagePicker;
  const GroupChatBottomBar({
    super.key,
    required this.addChat,
    required this.selectedImage,
    required this.imagePicker,
  });

  @override
  State<GroupChatBottomBar> createState() => _GroupChatBottomBarState();
}

class _GroupChatBottomBarState extends State<GroupChatBottomBar> {
  @override
  Widget build(BuildContext context) {
    StringMap data = {'content': ''};

    void addChat() {
      widget.addChat(data, widget.selectedImage);
      setState(() {
        data['content'] = '';
      });
    }

    return CustomBoxContainer(
      color: blackColor,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Flexible(
              child: CustomIconButton(
            onPressed: widget.imagePicker,
            icon: addIcon,
            color: whiteColor,
          )),
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
            child: Padding(
              padding: const EdgeInsets.only(right: 10),
              child: CustomIconButton(
                onPressed: addChat,
                icon: sendIcon,
                color: whiteColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
