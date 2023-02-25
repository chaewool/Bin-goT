import 'package:bin_got/pages/group_form_page.dart';
import 'package:bin_got/pages/group_main_page.dart';
import 'package:bin_got/pages/user_page.dart';
import 'package:bin_got/utilities/global_func.dart';
import 'package:bin_got/utilities/image_icon_utils.dart';
import 'package:bin_got/utilities/style_utils.dart';
import 'package:bin_got/utilities/type_def_utils.dart';
import 'package:bin_got/widgets/button.dart';
import 'package:bin_got/widgets/modal.dart';
import 'package:bin_got/widgets/text.dart';
import 'package:flutter/material.dart';

const double appBarHeight = 50;

//* appBar 기본 틀
class CustomAppBar extends StatelessWidget {
  final Widget? leadingChild;
  final WidgetList? actions;
  final String? title;
  const CustomAppBar({
    super.key,
    this.leadingChild,
    this.actions,
    this.title,
  });

  @override
  PreferredSizeWidget build(BuildContext context) {
    return AppBar(
        elevation: 0,
        backgroundColor: whiteColor,
        title: title != null
            ? Center(
                child:
                    CustomText(content: title!, fontSize: FontSize.largeSize))
            : const SizedBox(),
        leading: Padding(
          padding: const EdgeInsets.all(6),
          child: leadingChild,
        ),
        actions: actions);
  }
}

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
  Widget build(BuildContext context) {
    return CustomAppBar(
      leadingChild: halfLogo,
      actions: [
        isMainPage
            ? IconButtonInRow(onPressed: methodFunc1, icon: searchIcon)
            : const SizedBox(),
        isMainPage
            ? IconButtonInRow(onPressed: methodFunc2!, icon: myPageIcon)
            : IconButtonInRow(onPressed: methodFunc1, icon: createGroupIcon)
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
    this.isAdmin = false,
  });

  @override
  Widget build(BuildContext context) {
    return CustomAppBar(
      leadingChild: const ExitButton(isIconType: true),
      actions: onlyBack
          ? null
          : [
              isAdmin
                  ? IconButtonInRow(
                      icon: settingsIcon,
                      onPressed: () => toOtherPage(
                          context: context, page: const GroupAdmin()))
                  : const SizedBox(),
              isAdmin || isMember
                  ? IconButtonInRow(icon: shareIcon, onPressed: () {})
                  : const SizedBox(),
              isAdmin || isMember
                  ? IconButtonInRow(
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
    return CustomAppBar(
      leadingChild: const ExitButton(isIconType: true),
      actions: [
        IconButtonInRow(
            icon: editIcon,
            onPressed: () =>
                toOtherPage(context: context, page: const GroupFirstForm())),
        IconButtonInRow(
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

//* 빙고 상세
class BingoDetailAppBar extends StatelessWidget with PreferredSizeWidget {
  const BingoDetailAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomAppBar(
      leadingChild: CustomIconButton(
        onPressed: () => toBack(context: context),
        icon: backIcon,
      ),
      actions: [
        IconButtonInRow(
          onPressed: () {},
          icon: shareIcon,
        ),
        IconButtonInRow(
          onPressed: () {},
          icon: saveIcon,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(appBarHeight);
}

//* 마이 페이지
class MyPageAppBar extends StatelessWidget with PreferredSizeWidget {
  const MyPageAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomAppBar(
      actions: [
        IconButtonInRow(
          onPressed: () => showDialog(
            context: context,
            builder: (context) => const NotificationModal(),
          ),
          icon: bellIcon,
        ),
        IconButtonInRow(
            onPressed: () => toOtherPage(context: context, page: const Help()),
            icon: helpIcon),
        IconButtonInRow(onPressed: () {}, icon: exitIcon),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(appBarHeight);
}
