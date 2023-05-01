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
class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
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
              child: CustomText(
              content: title!,
              fontSize: FontSize.largeSize,
            ))
          : const SizedBox(),
      leading: Padding(
        padding: const EdgeInsets.all(6),
        child: leadingChild,
      ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(appBarHeight);
}

//* 뒤로 가기 버튼을 포함한 app bar
class AppBarWithBack extends StatelessWidget with PreferredSizeWidget {
  final WidgetList? actions;
  final String? title;
  const AppBarWithBack({
    super.key,
    this.actions,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return CustomAppBar(
      leadingChild: const ExitButton(isIconType: true),
      title: title,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(appBarHeight);
}

//* main, search
class MainBar extends StatelessWidget with PreferredSizeWidget {
  final ReturnVoid? onPressed;
  const MainBar({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return CustomAppBar(
      leadingChild: halfLogo,
      actions: [
        onPressed != null
            ? IconButtonInRow(onPressed: onPressed!, icon: searchIcon)
            : const SizedBox(),
        IconButtonInRow(
          icon: settingsIcon,
          onPressed: toOtherPage(context, page: const MyPage()),
        ),
        IconButtonInRow(
          onPressed: toOtherPage(
            context,
            page: const GroupForm(),
          ),
          icon: createGroupIcon,
        )
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(appBarHeight);
}

//* group main
class GroupAppBar extends StatelessWidget with PreferredSizeWidget {
  final bool onlyBack, isMember, isAdmin;
  final int groupId;
  const GroupAppBar({
    super.key,
    this.onlyBack = false,
    this.isMember = false,
    this.isAdmin = false,
    required this.groupId,
  });

  @override
  Widget build(BuildContext context) {
    return AppBarWithBack(
      actions: onlyBack
          ? null
          : [
              isAdmin
                  ? IconButtonInRow(
                      icon: settingsIcon,
                      onPressed: toOtherPage(context,
                          page: GroupAdmin(
                            groupId: groupId,
                          )))
                  : const SizedBox(),
              isAdmin || isMember
                  ? IconButtonInRow(icon: shareIcon, onPressed: () {})
                  : const SizedBox(),
              isAdmin || isMember
                  ? IconButtonInRow(
                      icon: exitIcon,
                      onPressed: showAlert(context,
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
    void onDeleteAction() {}
    return AppBarWithBack(
      actions: [
        IconButtonInRow(
            icon: editIcon,
            onPressed: toOtherPage(context, page: const GroupForm())),
        IconButtonInRow(
            icon: deleteIcon,
            onPressed: showAlert(
              context,
              title: '그룹 삭제',
              content: '그룹을 정말 삭제하시겠습니까?',
              onPressed: onDeleteAction,
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
    return AppBarWithBack(
      actions: [
        IconButtonInRow(
          onPressed: () {},
          icon: shareIcon,
        ),
        IconButtonInRow(
          onPressed: () {},
          icon: saveIcon,
        ),
        const SizedBox(
          width: 20,
        )
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
    return AppBarWithBack(
      actions: [
        IconButtonInRow(
          onPressed: showModal(
            context,
            page: const NotificationModal(),
          ),
          icon: bellIcon,
        ),
        // IconButtonInRow(
        //     onPressed: toOtherPage(context, page: const Help()),
        //     icon: helpIcon),
        // IconButtonInRow(
        //   onPressed: showAlert(context,
        //       title: '로그아웃 확인', content: '로그아웃하시겠습니까?', onPressed: () {}),
        //   icon: exitIcon,
        // ),
        const SizedBox(width: 10)
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(appBarHeight);
}
