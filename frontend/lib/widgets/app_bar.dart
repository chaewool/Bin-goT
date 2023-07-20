import 'package:bin_got/pages/group_admin_page.dart';
import 'package:bin_got/pages/group_form_page.dart';
import 'package:bin_got/pages/main_page.dart';
import 'package:bin_got/pages/user_page.dart';
import 'package:bin_got/providers/group_provider.dart';
import 'package:bin_got/providers/root_provider.dart';
import 'package:bin_got/utilities/global_func.dart';
import 'package:bin_got/utilities/image_icon_utils.dart';
import 'package:bin_got/utilities/style_utils.dart';
import 'package:bin_got/utilities/type_def_utils.dart';
import 'package:bin_got/widgets/button.dart';
import 'package:bin_got/widgets/modal.dart';
import 'package:bin_got/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const double appBarHeight = 50;

//* appBar 기본 틀
class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  final Widget? leadingChild;
  final WidgetList? actions;
  final String? title;
  final double elevation;
  const CustomAppBar({
    super.key,
    this.leadingChild,
    this.actions,
    this.title,
    this.elevation = 0,
  });

  @override
  PreferredSizeWidget build(BuildContext context) {
    return AppBar(
      elevation: elevation,
      backgroundColor: whiteColor,
      title: title != null
          ? Center(
              child: CustomText(
                content: title!,
                fontSize: FontSize.largeSize,
              ),
            )
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
  final ReturnVoid? onPressed;
  const AppBarWithBack({
    super.key,
    this.actions,
    this.title,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return CustomAppBar(
      leadingChild: ExitButton(
        isIconType: true,
        onPressed: onPressed,
      ),
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
      elevation: 1,
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
    final start = DateTime.parse(getStart(context)!);
    final today = DateTime.now();
    void exitThisGroup() async {
      try {
        GroupProvider().exitThisGroup(groupId).then((_) {
          toOtherPage(context, page: const Main())();
          showAlert(
            context,
            title: '탈퇴 완료',
            content: '그룹에서 정상적으로 탈퇴되었습니다.',
            hasCancel: false,
          )();
        });
      } catch (error) {
        showAlert(
          context,
          title: '탈퇴 오류',
          content: '오류가 발생해 그룹에서 탈퇴되지 않았습니다.',
          hasCancel: false,
        )();
      }
    }

    return AppBarWithBack(
      onPressed: () {
        toBack(context);
        toBack(context);
      },
      actions: onlyBack
          ? null
          : [
              isAdmin
                  ? IconButtonInRow(
                      icon: settingsIcon,
                      onPressed: toOtherPage(
                        context,
                        page: GroupAdmin(
                          groupId: groupId,
                        ),
                      ),
                    )
                  : const SizedBox(),
              isMember && today.difference(start) > Duration.zero
                  ? IconButtonInRow(
                      icon: shareIcon,
                      onPressed: () => shareGroup(
                        groupId: groupId,
                        password: '',
                      ),
                    )
                  : const SizedBox(),
              isMember && !isAdmin && today.difference(start) > Duration.zero
                  ? IconButtonInRow(
                      icon: exitIcon,
                      onPressed: showAlert(
                        context,
                        title: '그룹 탈퇴 확인',
                        content: '정말 그룹을 탈퇴하시겠습니까?',
                        onPressed: exitThisGroup,
                      ),
                    )
                  : const SizedBox(),
            ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(appBarHeight);
}

//* group admin
class AdminAppBar extends StatelessWidget with PreferredSizeWidget {
  final int groupId;
  const AdminAppBar({
    super.key,
    required this.groupId,
  });

  @override
  Widget build(BuildContext context) {
    final start = DateTime.parse(getStart(context)!);
    final today = DateTime.now();
    void deleteGroup() async {
      try {
        GroupProvider().deleteOwnGroup(groupId).then((_) {
          toOtherPage(context, page: const Main())();
          showAlert(
            context,
            title: '삭제 완료',
            content: '그룹이 정상적으로 삭제되었습니다.',
            hasCancel: false,
          )();
        });
      } catch (error) {
        showAlert(
          context,
          title: '삭제 오류',
          content: '오류가 발생해 그룹이 삭제되지 않았습니다.',
          hasCancel: false,
        )();
      }
    }

    void onDeleteAction() {
      // if (DateTime.parse(start).difference(DateTime.now()).inDays <= 0) {
      //   showAlert(
      //     context,
      //     title: '그룹 삭제',
      //     content: '시작일이 지난 그룹은 삭제할 수 없습니다',
      //     hasCancel: false,
      //   )();
      // } else
      if (context.read<GlobalGroupProvider>().count! >= 2) {
        showAlert(
          context,
          title: '그룹 삭제',
          content: '그룹장 외의 그룹원이 존재할 경우, 그룹을 삭제할 수 없습니다.',
          hasCancel: false,
        )();
      } else {
        showAlert(
          context,
          title: '그룹 삭제',
          content: '그룹을 정말 삭제하시겠습니까?',
          onPressed: deleteGroup,
        )();
      }
    }

    void onEditAction() {
      // if (DateTime.parse(start).difference(DateTime.now()).inDays <= 0) {
      //   showAlert(
      //     context,
      //     title: '그룹 수정',
      //     content: '시작일이 지난 그룹은 수정할 수 없습니다',
      //     hasCancel: false,
      //   )();
      // } else {
      // }
      toOtherPage(
        context,
        page: GroupForm(groupId: groupId),
      )();
    }

    return AppBarWithBack(
      actions: today.difference(start) > Duration.zero
          ? [
              IconButtonInRow(icon: editIcon, onPressed: onEditAction),
              IconButtonInRow(icon: deleteIcon, onPressed: onDeleteAction),
            ]
          : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(appBarHeight);
}

//* 빙고 상세
class BingoDetailAppBar extends StatelessWidget with PreferredSizeWidget {
  final FutureBool Function() save;
  final int bingoId;
  const BingoDetailAppBar({
    super.key,
    required this.save,
    required this.bingoId,
  });

  @override
  Widget build(BuildContext context) {
    return AppBarWithBack(
      actions: [
        IconButtonInRow(
          onPressed: () => shareBingo(bingoId: bingoId),
          icon: shareIcon,
        ),
        IconButtonInRow(
          onPressed: save,
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
