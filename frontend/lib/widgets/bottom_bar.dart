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
import 'package:bin_got/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

//* custom bottom bar

class CustomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final List<IconData> items;
  // final List<BottomNavigationBarItem> items;
  // final bool isGroup;
  final void Function(int) changeIndex;
  const CustomNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.items,
    required this.changeIndex,
    // this.isGroup = true,
  });

  @override
  Widget build(BuildContext context) {
    return
        // BottomNavigationBar(
        //   items: items,
        //   backgroundColor: whiteColor,
        //   selectedItemColor: whiteColor,
        //   unselectedItemColor: greyColor,
        //   selectedIconTheme: IconThemeData(),
        //   currentIndex: selectedIndex,
        //   onTap: changeIndex,
        //   showSelectedLabels: false,
        //   showUnselectedLabels: false,
        // );
        CustomBoxContainer(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            for (int i = 0; i < 3; i += 1)
              GestureDetector(
                onTap: () => changeIndex(i),
                child: CircleContainer(
                  radius: 26,
                  border: false,
                  gradient: selectedIndex == i
                      ? const LinearGradient(
                          colors: [paleRedColor, palePinkColor],
                        )
                      : null,
                  child: CustomIcon(
                    icon: items[i],
                    color: selectedIndex == i ? whiteColor : greyColor,
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}

//* snake bottom bar
// class CustomSnakeBottomBar extends StatefulWidget {
//   final int selectedIndex;
//   final List<BottomNavigationBarItem> items;
//   final void Function(int) changeIndex;
//   const CustomSnakeBottomBar({
//     super.key,
//     required this.selectedIndex,
//     required this.items,
//     required this.changeIndex,
//   });

//   @override
//   State<CustomSnakeBottomBar> createState() => _CustomSnakeBottomBarState();
// }

// class _CustomSnakeBottomBarState extends State<CustomSnakeBottomBar> {
//   @override
//   Widget build(BuildContext context) {
//     return SnakeNavigationBar.gradient(
//       snakeShape: SnakeShape.indicator,
//       elevation: 0.8,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(25),
//           topRight: Radius.circular(25),
//         ),
//       ),
//       snakeViewGradient: const LinearGradient(
//         colors: [paleRedColor, palePinkColor],
//       ),
//       unselectedItemGradient: const LinearGradient(
//         colors: [greyColor, greyColor],
//       ),
//       selectedItemGradient: const LinearGradient(
//         colors: [whiteColor, whiteColor],
//       ),
//       currentIndex: widget.selectedIndex,
//       onTap: widget.changeIndex,
//       items: widget.items,
//     );
//   }
// }

//* 그룹에서의 하단 바
class GroupMainBottomBar extends StatelessWidget {
  final int? size, bingoId;
  final bool isMember;
  final void Function(int)? changeIndex;
  const GroupMainBottomBar({
    super.key,
    this.isMember = true,
    this.size,
    this.bingoId,
    this.changeIndex,
  });

  @override
  Widget build(BuildContext context) {
    return isMember
        ? CustomNavigationBar(
            changeIndex: changeIndex!,
            items: const [
              boardIcon,
              homeIcon,
              rankIcon
              // customBottomBarIcon(label: '빙고 상세 페이지', iconData: boardIcon),
              // customBottomBarIcon(label: '그룹 메인 페이지', iconData: homeIcon),
              // customBottomBarIcon(label: '그룹 내 순위 페이지', iconData: rankIcon),
            ],
            selectedIndex: watchGroupIndex(context),
          )
        : BottomAppBar(
            child: GestureDetector(
              onTap: () {
                final bingoId = getBingoId(context);
                if (bingoId != null && bingoId != 0) {
                  setBingoId(context, 0);
                }
                jumpToOtherPage(
                  context,
                  page: BingoForm(
                    bingoSize: size ?? 0,
                    beforeJoin: true,
                    needAuth: getNeedAuth(context) ?? true,
                  ),
                )();
              },
              child: CustomBoxContainer(
                hasRoundEdge: false,
                height: 50,
                color: paleRedColor,
                child: Center(
                  child: CustomText(
                    content:
                        '빙고 만들고 가입${getNeedAuth(context) == true ? ' 신청' : ''}하기',
                    color: whiteColor,
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
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: CustomButton(
                color: paleRedColor,
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
      width: getWidth(context),
      height: 80,
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
