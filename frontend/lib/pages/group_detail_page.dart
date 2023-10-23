import 'package:bin_got/pages/group_admin_page.dart';
import 'package:bin_got/pages/group_chat_page.dart';
import 'package:bin_got/providers/bingo_provider.dart';
import 'package:bin_got/providers/group_provider.dart';
import 'package:bin_got/providers/root_provider.dart';
import 'package:bin_got/utilities/image_icon_utils.dart';
import 'package:bin_got/widgets/bingo_detail.dart';
import 'package:bin_got/widgets/button.dart';
import 'package:bin_got/widgets/group_rank.dart';
import 'package:bin_got/utilities/style_utils.dart';
import 'package:bin_got/utilities/type_def_utils.dart';
import 'package:bin_got/widgets/container.dart';
import 'package:bin_got/utilities/global_func.dart';
import 'package:bin_got/widgets/app_bar.dart';
import 'package:bin_got/widgets/bottom_bar.dart';
import 'package:bin_got/widgets/group_main.dart';
import 'package:bin_got/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//? 빙고 상세, 그룹 메인, 그룹 순위
class GroupDetail extends StatefulWidget {
  final bool admin, isMember, chat, needBack;
  final int? bingoId, size, groupId;
  final int initialIndex;
  const GroupDetail({
    super.key,
    this.groupId,
    this.bingoId,
    this.size,
    this.needBack = false,
    required this.admin,
    required this.isMember,
    required this.chat,
    required this.initialIndex,
  });

  @override
  State<GroupDetail> createState() => _GroupDetailState();
}

class _GroupDetailState extends State<GroupDetail> {
  //* 변수
  int bingoSize = 0;
  int bingoId = 0;
  double paddingTop = 0;
  double bottomBarHeight = 70;
  late PageController pageController;
  final WidgetList appbarList = [
    const BingoDetailAppBar(),
    const GroupAppBar(),
    const GroupAppBar(enableAdmin: false),
  ];

  //* 빙고 정보 불러오기
  void readBingoDetail() {
    BingoProvider()
        .readBingoDetail(
      getGroupId(context)!,
      bingoId,
    )
        .then((data) {
      setBingoData(context, data);
      final length = bingoSize * bingoSize;
      initFinished(context, length);
      for (int i = 0; i < length; i += 1) {
        setFinished(context, i, data['items'][i]['finished']);
      }
      setLoading(context, false);
    }).catchError((_) {
      showErrorModal(context, '빙고 정보 불러오기 오류', '빙고 정보를 불러오는 데 실패했습니다.');
    });
  }

  //* 빙고 정보 적용
  void applyBingoDetail() {
    setState(() {
      bingoSize = context.read<GlobalBingoProvider>().bingoSize ??
          context.read<GlobalGroupProvider>().bingoSize!;
      bingoId = getBingoId(context) ?? myBingoId(context)!;
    });

    context.read<GlobalBingoProvider>().initKey();
    setLoading(context, true);
    readBingoDetail();
  }

  //* 그룹 순위 적용
  void applyGroupRank() {
    setLoading(context, true);
    GroupProvider().groupRank(getGroupId(context)!).then((data) {
      if (data.isNotEmpty) {
        setState(() {
          context.read<GlobalGroupProvider>().setRank(data);
          context.read<GlobalGroupProvider>().setEnable(false);
        });
      }
      setLoading(context, false);
    });
  }

  void onPageChanged(int index) {
    if (widget.isMember && index != readGroupIndex(context)) {
      changeGroupIndex(context, index);
      pageController.jumpToPage(index);

      switch (index) {
        case 0:
          applyBingoDetail();
          break;
        case 2:
          applyGroupRank();
          break;
        default:
          break;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    //* 페이지 이동 시
    pageController = PageController(initialPage: widget.initialIndex);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.isMember) {
        setState(() {
          paddingTop = getStatusBarHeight(context);
        });
        int index = readGroupIndex(context);
        switch (index) {
          case 0:
            applyBingoDetail();
            break;
          case 2:
            applyGroupRank();
            break;
          default:
            break;
        }
        //* 다른 페이지로 이동해야할 경우
        if (widget.admin) {
          toOtherPageWithAnimation(context,
              page: GroupAdmin(groupId: widget.groupId!))();
        } else if (widget.chat) {
          toOtherPageWithAnimation(context, page: const GroupChat())();
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => onBackAction(context),
      child: Scaffold(
        backgroundColor: whiteColor,
        resizeToAvoidBottomInset: true,
        body: Stack(
          children: [
            SizedBox(
              width: getWidth(context),
              height: getHeight(context),
              //* 화면
              child: Padding(
                padding: EdgeInsets.only(bottom: bottomBarHeight),
                child: PageView(
                  physics: const NeverScrollableScrollPhysics(),
                  // controller: getPageController(context),
                  controller: pageController,
                  children: [
                    if (widget.isMember)
                      Padding(
                        padding: EdgeInsets.only(top: paddingTop),
                        child: const BingoDetail(),
                      ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: paddingTop),
                          child: SingleChildScrollView(
                            child: GroupMain(changeIndex: onPageChanged),
                          ),
                        ),
                      ],
                    ),
                    if (widget.isMember)
                      Padding(
                        padding: EdgeInsets.only(top: paddingTop),
                        child: GroupRank(changeIndex: onPageChanged),
                      ),
                  ],
                ),
              ),
            ),
            //* 앱 바
            CustomBoxContainer(
              color: transparentColor,
              width: getWidth(context),
              height: 80,
              child: widget.isMember
                  ? appbarList[watchGroupIndex(context)]
                  : AppBarWithBack(
                      onPressedBack: () => onBackAction(context),
                      transparent: true,
                    ),
            ),
            //* 하단 바
            Positioned(
              top: getHeight(context) - bottomBarHeight,
              child: GroupMainBottomBar(
                bottomBarHeight: bottomBarHeight,
                isMember: widget.isMember,
                size: context.watch<GlobalGroupProvider>().bingoSize ??
                    context.watch<GlobalBingoProvider>().bingoSize,
                changeIndex: onPageChanged,
              ),
            ),
            //* 채팅창 이동 버튼
            if (watchMemberState(context) != 0)
              const CustomFloatingButton(
                page: GroupChat(),
                icon: chatIcon,
              ),
            //* 토스트
            if (watchAfterWork(context))
              CustomToast(content: watchToastString(context))
          ],
        ),
      ),
    );
  }
}
