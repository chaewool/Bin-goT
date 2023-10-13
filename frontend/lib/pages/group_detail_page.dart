import 'package:bin_got/pages/group_admin_page.dart';
import 'package:bin_got/pages/group_chat_page.dart';
import 'package:bin_got/providers/bingo_provider.dart';
import 'package:bin_got/providers/group_provider.dart';
import 'package:bin_got/providers/root_provider.dart';
import 'package:bin_got/utilities/image_icon_utils.dart';
import 'package:bin_got/widgets/bingo_detail.dart';
import 'package:bin_got/widgets/group_rank.dart';
import 'package:bin_got/utilities/style_utils.dart';
import 'package:bin_got/utilities/type_def_utils.dart';
import 'package:bin_got/widgets/container.dart';
import 'package:bin_got/utilities/global_func.dart';
import 'package:bin_got/widgets/app_bar.dart';
import 'package:bin_got/widgets/bottom_bar.dart';
import 'package:bin_got/widgets/group_main.dart';
import 'package:bin_got/widgets/icon.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//? 빙고 상세, 그룹 메인, 그룹 순위
class GroupDetail extends StatefulWidget {
  final bool admin, isMember, chat, needBack;
  final int? bingoId, size, groupId;
  const GroupDetail({
    super.key,
    this.groupId,
    this.bingoId,
    this.size,
    this.needBack = false,
    required this.admin,
    required this.isMember,
    required this.chat,
  });

  @override
  State<GroupDetail> createState() => _GroupDetailState();
}

class _GroupDetailState extends State<GroupDetail> {
  //* 변수
  int bingoSize = 0;
  int bingoId = 0;
  WidgetList nextPages = [
    const BingoDetail(),
    const GroupMain(),
    const GroupRank(),
  ];
  final WidgetList appbarList = [
    const BingoDetailAppBar(),
    const GroupAppBar(),
    const GroupAppBar(),
  ];
  late final PageController pageController;

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

  //* 뒤로 가기
  FutureBool onBackAction() {
    context.read<GlobalBingoProvider>().initData();
    context.read<GlobalGroupProvider>().initData();
    toBack(context);
    if (getPrev(context)) {
      changePrev(context, false);
      toBack(context);
    }
    return Future.value(false);
  }

  @override
  void initState() {
    super.initState();
    //* 페이지 이동 시
    pageController = PageController(initialPage: readGroupIndex(context));
    pageController.addListener(
      () {
        final newIndex = pageController.page!.round();
        if (newIndex != readGroupIndex(context)) {
          setState(() {
            changeGroupIndex(context, newIndex);
          });

          switch (newIndex) {
            case 0:
              WidgetsBinding.instance.addPostFrameCallback((_) {
                applyBingoDetail();
              });
              break;
            case 2:
              WidgetsBinding.instance.addPostFrameCallback((_) {
                applyGroupRank();
              });
              break;
            default:
              break;
          }
        }
      },
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      //* 다른 페이지로 이동해야할 경우
      if (widget.admin) {
        toOtherPage(context, page: GroupAdmin(groupId: widget.groupId!))();
      } else if (widget.chat) {
        toOtherPage(context, page: const GroupChat())();
      }
    });
  }

  //* 종료
  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onBackAction,
      child: Scaffold(
        backgroundColor: whiteColor,
        resizeToAvoidBottomInset: true,
        body: Stack(
          children: [
            SizedBox(
              width: getWidth(context),
              height: getHeight(context) - 80,
              //* 화면
              child: PageView(
                controller: pageController,
                onPageChanged: (index) => changeGroupIndex(context, index),
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).padding.top),
                    child: nextPages[0],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).padding.top),
                        child: SingleChildScrollView(
                          child: nextPages[1],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).padding.top),
                    child: nextPages[2],
                  ),
                ],
              ),
            ),
            //* 앱 바
            CustomBoxContainer(
              color: transparentColor,
              width: getWidth(context),
              height: 80,
              child: appbarList[watchGroupIndex(context)],
            ),
            //* 채팅창 이동 버튼
            if (watchMemberState(context) != 0)
              Positioned(
                left: getWidth(context) - 80,
                top: getHeight(context) - 150,
                child: FloatingActionButton(
                  backgroundColor: palePinkColor.withOpacity(0.8),
                  onPressed: toOtherPage(context, page: const GroupChat()),
                  child: const CustomIcon(
                    icon: chatIcon,
                    color: whiteColor,
                  ),
                ),
              ),
          ],
        ),
        //* 하단 바
        bottomNavigationBar: GroupMainBottomBar(
          isMember: widget.isMember,
          size: context.watch<GlobalGroupProvider>().bingoSize ??
              context.watch<GlobalBingoProvider>().bingoSize,
          changeIndex: (index) {
            changeGroupIndex(context, index);
            pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 500),
              curve: Curves.ease,
            );
          },
        ),
      ),
    );
  }
}
