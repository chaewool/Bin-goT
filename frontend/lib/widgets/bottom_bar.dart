import 'package:bin_got/pages/bingo_form_page.dart';
import 'package:bin_got/utilities/global_func.dart';
import 'package:bin_got/utilities/image_icon_utils.dart';
import 'package:bin_got/utilities/style_utils.dart';
import 'package:bin_got/utilities/type_def_utils.dart';
import 'package:bin_got/widgets/button.dart';
import 'package:bin_got/widgets/container.dart';
import 'package:bin_got/widgets/icon.dart';
import 'package:bin_got/widgets/input.dart';
import 'package:bin_got/widgets/row_col.dart';
import 'package:flutter/material.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:image_picker/image_picker.dart';

//* snake bottom bar
class CustomSnakeBottomBar extends StatefulWidget {
  final int selectedIndex;
  final List<BottomNavigationBarItem> items;
  final void Function(int) changeIndex;
  const CustomSnakeBottomBar({
    super.key,
    required this.selectedIndex,
    required this.items,
    required this.changeIndex,
  });

  @override
  State<CustomSnakeBottomBar> createState() => _CustomSnakeBottomBarState();
}

class _CustomSnakeBottomBarState extends State<CustomSnakeBottomBar> {
  @override
  Widget build(BuildContext context) {
    print('index => ${widget.selectedIndex}');
    return SnakeNavigationBar.gradient(
      elevation: 0.8,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      snakeViewGradient: const LinearGradient(
        colors: [paleRedColor, palePinkColor],
      ),
      unselectedItemGradient: const LinearGradient(
        colors: [greyColor, greyColor],
      ),
      selectedItemGradient: const LinearGradient(
        colors: [whiteColor, whiteColor],
      ),
      currentIndex: widget.selectedIndex,
      onTap: widget.changeIndex,
      items: widget.items,
    );
  }
}

//* 메인 하단 바
// class MainBottomBar extends StatelessWidget {
//   const MainBottomBar({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     const WidgetList nextPages = [MyPage(), Main()];
//     final items = [
//       customBottomBarIcon(label: '설정 페이지', iconData: settingsIcon),
//       customBottomBarIcon(label: '메인 페이지', iconData: homeIcon),
//       customBottomBarIcon(label: '그룹 검색 바 띄우기', iconData: searchIcon),
//     ];
//     // void afterWork(int index) {
//     //   if (index != 2) {
//     //     changeSearchMode!();
//     //   } else {
//     //     toOtherPage(context, page: nextPages[index]);
//     //   }
//     // }

//     return CustomSnakeBottomBar(
//       // selectedIndex: selectedIndex,
//       // afterWork: afterWork,
//       items: items,
//       nextPages: nextPages,
//     );
//   }
// }

//* 그룹에서의 하단 바
class GroupMainBottomBar extends StatelessWidget {
  final int groupId, selectedIndex;
  final int? size, bingoId;
  final bool isMember;
  final bool needAuth;
  final void Function(int) changeIndex;
  const GroupMainBottomBar({
    super.key,
    required this.groupId,
    this.isMember = true,
    required this.needAuth,
    this.size,
    required this.selectedIndex,
    this.bingoId,
    required this.changeIndex,
  });

  @override
  Widget build(BuildContext context) {
    return isMember
        ? CustomSnakeBottomBar(
            items: [
              customBottomBarIcon(label: '빙고 상세 페이지', iconData: boardIcon),
              customBottomBarIcon(label: '그룹 메인 페이지', iconData: homeIcon),
              customBottomBarIcon(label: '그룹 채팅 페이지', iconData: chatIcon),
            ],
            selectedIndex: selectedIndex,
            changeIndex: changeIndex,
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
                color: blackColor,
                content: '빙고 만들고 가입${needAuth == true ? ' 신청' : ''}하기',
                textColor: whiteColor,
                onPressed: toOtherPage(
                  context,
                  page: BingoForm(
                    bingoSize: size!,
                    needAuth: needAuth,
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
      elevation: 0,
      color: whiteColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // CustomButton(onPressed: () => toBack(context), content: '취소'),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: CustomButton(
                color: paleOrangeColor,
                onPressed: createOrUpdate,
                content: '완료',
                fontSize: FontSize.textSize,
                textColor: whiteColor,
              ),
            ),
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
      color: greyColor,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
      child: RowWithPadding(
        vertical: 10,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Flexible(
            child: CustomIconButton(
              onPressed: widget.imagePicker,
              icon: addIcon,
              color: whiteColor,
            ),
          ),
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
