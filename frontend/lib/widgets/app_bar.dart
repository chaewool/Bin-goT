import 'package:bin_got/pages/group_form_page.dart';
import 'package:bin_got/pages/group_main_page.dart';
import 'package:bin_got/utilities/global_func.dart';
import 'package:bin_got/utilities/image_icon_utils.dart';
import 'package:bin_got/utilities/style_utils.dart';
import 'package:bin_got/utilities/type_def_utils.dart';
import 'package:bin_got/widgets/button.dart';
import 'package:bin_got/widgets/icon.dart';
import 'package:bin_got/widgets/text.dart';
import 'package:flutter/material.dart';

const double appBarHeight = 50;

//* main, search
class TopBar extends StatelessWidget with PreferredSizeWidget {
  final bool isMainPage;
  final ReturnVoid methodFunc1;
  final ReturnVoid? methodFunc2;
  const TopBar({
    super.key,
    required this.isMainPage,
    required this.methodFunc1,
    this.methodFunc2,
  });

  @override
  PreferredSizeWidget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: whiteColor,
      leading: Padding(
        padding: const EdgeInsets.all(6),
        child: halfLogo,
      ),
      actions: [
        isMainPage
            ? IconInRow(onPressed: methodFunc1, icon: searchIcon)
            : const SizedBox(),
        isMainPage
            ? IconInRow(onPressed: methodFunc2!, icon: myPageIcon)
            : IconInRow(onPressed: methodFunc1, icon: createGroupIcon)
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(appBarHeight);
}

//* group main
class GroupAppBar extends StatelessWidget with PreferredSizeWidget {
  final bool onlyBack, isMember, isAdmin;
  const GroupAppBar({
    super.key,
    this.onlyBack = false,
    this.isMember = false,
    this.isAdmin = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: whiteColor,
      leading: const ExitButton(isIconType: true),
      actions: onlyBack
          ? null
          : [
              isAdmin
                  ? IconInRow(
                      icon: settingsIcon,
                      onPressed: () => toOtherPage(
                          context: context, page: const GroupAdmin()))
                  : const SizedBox(),
              isAdmin || isMember
                  ? IconInRow(icon: shareIcon, onPressed: () {})
                  : const SizedBox(),
              isAdmin || isMember
                  ? IconInRow(
                      icon: exitIcon,
                      onPressed: () => showAlert(
                          context: context,
                          title: '그룹 탈퇴 확인',
                          content: '정말 그룹을 탈퇴하시겠습니까?',
                          onPressed: () {}))
                  : const SizedBox(),
            ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(appBarHeight);
}

//* group admin
class AdminAppBar extends StatelessWidget with PreferredSizeWidget {
  const AdminAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: whiteColor,
      leading: const ExitButton(isIconType: true),
      title: const Center(
          child: CustomText(content: '그룹 관리', fontSize: FontSize.largeSize)),
      actions: [
        IconInRow(
            icon: editIcon,
            onPressed: () =>
                toOtherPage(context: context, page: const GroupFirstForm())),
        IconInRow(
            icon: deleteIcon,
            onPressed: () => showAlert(
                  context: context,
                  title: '그룹 삭제',
                  content: '그룹을 정말 삭제하시겠습니까?',
                  onPressed: () {},
                )),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(appBarHeight);
}

class BingoDetailAppBar extends StatelessWidget with PreferredSizeWidget {
  const BingoDetailAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      leading: IconButton(
        onPressed: () => toBack(context: context),
        icon: const Icon(Icons.arrow_back_rounded),
        iconSize: 30,
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.share),
          iconSize: 30,
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.save),
          iconSize: 30,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(appBarHeight);
}
