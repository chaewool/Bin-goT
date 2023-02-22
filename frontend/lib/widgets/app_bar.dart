import 'package:bin_got/pages/group_form_page.dart';
import 'package:bin_got/pages/group_main_page.dart';
import 'package:bin_got/utilities/image_icon_utils.dart';
import 'package:bin_got/utilities/style_utils.dart';
import 'package:bin_got/utilities/type_def_utils.dart';
import 'package:bin_got/widgets/button.dart';
import 'package:flutter/material.dart';

const double appBarHeight = 50;

// 재사용 가능하게 수정
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
            ? CustomIconButton(onPressed: methodFunc1, icon: searchIcon)
            : const SizedBox(),
        isMainPage
            ? CustomIconButton(onPressed: methodFunc2!, icon: myPageIcon)
            : CustomIconButton(onPressed: methodFunc1, icon: createGroupIcon)
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(appBarHeight);
}

//* group main app bar
class GroupAppBar extends StatelessWidget with PreferredSizeWidget {
  final bool onlyBack, isMember, isAdmin;
  const GroupAppBar({
    super.key,
    this.onlyBack = false,
    this.isMember = false,
    this.isAdmin = false,
  });
  final iconList = const [settingsIcon, shareIcon, exitIcon];
  @override
  Widget build(BuildContext context) {
    void toGroupAdmin() {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const GroupAdmin()));
    }

    final funcList = [toGroupAdmin, () {}, () {}];

    return AppBar(
      elevation: 0,
      backgroundColor: whiteColor,
      leading: const ExitButton(
        isIconType: true,
      ),
      actions: onlyBack
          ? null
          : [
              for (int i = 0; i < 3; i += 1)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: CustomIconButton(
                      icon: iconList[i], onPressed: funcList[i]),
                ),
              // const SizedBox(width: 20),
            ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(appBarHeight);
}

//* group main app bar
class AdminAppBar extends StatelessWidget with PreferredSizeWidget {
  const AdminAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    void toGroupForm() {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const GroupFirstForm()));
    }

    return AppBar(
      elevation: 0,
      backgroundColor: whiteColor,
      leading: const ExitButton(
        isIconType: true,
      ),
      actions: [
        CustomIconButton(onPressed: toGroupForm, icon: editIcon),
        CustomIconButton(onPressed: () {}, icon: deleteIcon),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(appBarHeight);
}
