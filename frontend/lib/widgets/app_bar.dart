import 'dart:io';

import 'package:bin_got/pages/group_admin_page.dart';
import 'package:bin_got/pages/group_form_page.dart';
import 'package:bin_got/pages/main_page.dart';
import 'package:bin_got/providers/group_provider.dart';
import 'package:bin_got/providers/root_provider.dart';
import 'package:bin_got/utilities/global_func.dart';
import 'package:bin_got/utilities/image_icon_utils.dart';
import 'package:bin_got/utilities/style_utils.dart';
import 'package:bin_got/utilities/type_def_utils.dart';
import 'package:bin_got/widgets/button.dart';
import 'package:bin_got/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

//? 상단 바 (앱 바)

const double appBarHeight = 50;

//* appBar 기본 틀
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? leadingChild;
  final WidgetList? actions;
  final String? title;
  final double elevation;
  final bool transparent;
  const CustomAppBar({
    super.key,
    this.leadingChild,
    this.actions,
    this.title,
    this.elevation = 0.0,
    this.transparent = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: elevation,
      backgroundColor: transparent ? transparentColor : whiteColor,
      title: title != null
          ? Padding(
              padding: const EdgeInsets.all(6),
              child: CustomText(
                content: title!,
                fontSize: FontSize.largeSize,
              ),
            )
          : null,
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
class AppBarWithBack extends StatelessWidget implements PreferredSizeWidget {
  final WidgetList? actions;
  final String? title;
  final ReturnVoid? onPressedBack;
  final bool transparent;
  const AppBarWithBack({
    super.key,
    this.actions,
    this.title,
    this.onPressedBack,
    this.transparent = false,
  });

  @override
  Widget build(BuildContext context) {
    return CustomAppBar(
      transparent: transparent,
      leadingChild: ExitButton(
        isIconType: true,
        onPressed: onPressedBack,
      ),
      title: title,
      actions: [
        ...?actions,
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(appBarHeight);
}

//* group main
class GroupAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool enableAdmin;
  const GroupAppBar({
    super.key,
    this.enableAdmin = true,
  });

  @override
  Widget build(BuildContext context) {
    final groupId = getGroupId(context)!;

    void exitThisGroup() async {
      try {
        GroupProvider().exitThisGroup(groupId).then((_) {
          toOtherPage(context, page: const Main())();
          showAlert(
            context,
            title: '탈퇴 완료',
            content: '그룹에서 정상적으로 탈퇴되었습니다.',
          )();
        });
      } catch (error) {
        showAlert(
          context,
          title: '탈퇴 오류',
          content: '오류가 발생해 그룹에서 탈퇴되지 않았습니다.',
        )();
      }
    }

    return AppBarWithBack(
      transparent: true,
      onPressedBack: () => onBackAction(context),
      actions: enableAdmin
          ? [
              if (watchMemberState(context) == 2)
                IconButtonInRow(
                  icon: settingsIcon,
                  onPressed: toOtherPageWithAnimation(
                    context,
                    page: GroupAdmin(groupId: groupId),
                  ),
                ),
              if ((watchMemberState(context) != 0) &&
                  alreadyStarted(context) == false)
                IconButtonInRow(
                  icon: shareIcon,
                  onPressed: () => shareGroup(
                    groupId: groupId,
                    groupName: getGroupName(context),
                  ),
                ),
              if (watchMemberState(context) == 1 &&
                  alreadyStarted(context) == false)
                IconButtonInRow(
                  icon: tempExitIcon,
                  onPressed: showAlert(
                    context,
                    title: '그룹 탈퇴 확인',
                    content: '정말 그룹을 탈퇴하시겠습니까?',
                    onPressed: exitThisGroup,
                    hasCancel: true,
                  ),
                ),
              const SizedBox(width: 10),
            ]
          : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(appBarHeight);
}

//* group admin
class AdminAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int groupId;
  const AdminAppBar({
    super.key,
    required this.groupId,
  });

  @override
  Widget build(BuildContext context) {
    void deleteGroup() async {
      try {
        GroupProvider().deleteOwnGroup(groupId).then((_) {
          toOtherPage(context, page: const Main())();
          showAlert(
            context,
            title: '삭제 완료',
            content: '그룹이 정상적으로 삭제되었습니다.',
          )();
        });
      } catch (error) {
        showAlert(
          context,
          title: '삭제 오류',
          content: '오류가 발생해 그룹이 삭제되지 않았습니다.',
        )();
      }
    }

    void onDeleteAction() {
      if (context.read<GlobalGroupProvider>().count! >= 2) {
        showAlert(
          context,
          title: '그룹 삭제',
          content: '그룹장 외의 그룹원이 존재할 경우, 그룹을 삭제할 수 없습니다.',
        )();
      } else {
        showAlert(
          context,
          title: '그룹 삭제',
          content: '그룹을 정말 삭제하시겠습니까?',
          onPressed: deleteGroup,
          hasCancel: true,
        )();
      }
    }

    void onEditAction() {
      toOtherPageWithAnimation(
        context,
        page: GroupForm(
          groupId: groupId,
          hasImg: context.read<GlobalGroupProvider>().hasImage,
        ),
      )();
    }

    return AppBarWithBack(
      actions: onGoing(context) != true
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
class BingoDetailAppBar extends StatelessWidget implements PreferredSizeWidget {
  const BingoDetailAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    FutureBool saveBingo() {
      imagePicker(context, elseFunc: () {
        context.read<GlobalBingoProvider>().bingoToImage().then((_) {
          setToastString(context, '빙고판 이미지가 저장되었습니다.');
          showToast(context);
        }).catchError((_) {
          showErrorModal(context, '저장 실패', '빙고판 저장에 실패했습니다.');
        });
      });
      return Future.value(true);
    }

    void shareBingo() async {
      File file = await context.read<GlobalBingoProvider>().bingoToXFile();

      Share.shareXFiles(
        [XFile(file.path)],
        // ignore: use_build_context_synchronously
        text: context.read<GlobalBingoProvider>().title,
      ).then((value) => file.delete());
    }

    return AppBarWithBack(
      onPressedBack: () => onBackAction(context),
      transparent: true,
      actions: myBingoId(context) == null ||
              getBingoId(context) == myBingoId(context)
          ? [
              IconButtonInRow(
                onPressed: shareBingo,
                icon: shareIcon,
              ),
              IconButtonInRow(
                onPressed: saveBingo,
                icon: saveIcon,
              ),
              const SizedBox(width: 10)
            ]
          : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(appBarHeight);
}
