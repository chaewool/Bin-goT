import 'package:bin_got/models/group_model.dart';
import 'package:bin_got/pages/bingo_detail_page.dart';
import 'package:bin_got/pages/bingo_form_page.dart';
import 'package:bin_got/pages/group_rank_page.dart';
import 'package:bin_got/providers/group_provider.dart';
import 'package:bin_got/providers/root_provider.dart';
import 'package:bin_got/providers/user_provider.dart';
import 'package:bin_got/utilities/global_func.dart';
import 'package:bin_got/utilities/style_utils.dart';
import 'package:bin_got/widgets/app_bar.dart';
import 'package:bin_got/widgets/bottom_bar.dart';
import 'package:bin_got/widgets/container.dart';
import 'package:bin_got/widgets/button.dart';
import 'package:bin_got/widgets/modal.dart';
import 'package:bin_got/widgets/row_col.dart';
import 'package:bin_got/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

class GroupMain extends StatefulWidget {
  final int groupId;
  final bool isPublic;
  final String password;
  const GroupMain({
    super.key,
    required this.groupId,
    required this.isPublic,
    this.password = '',
  });

  @override
  State<GroupMain> createState() => _GroupMainState();
}

class _GroupMainState extends State<GroupMain> {
  @override
  void initState() {
    super.initState();
    if (getToken(context) != null) {
      verifyToken();
    } else {
      showModal(context,
          page: const CustomAlert(title: '로그인 확인', content: '로그인이 필요합니다'))();
    }

    if (!widget.isPublic) {
      showModal(context, page: const InputModal(title: '비밀번호 입력'))();
    }
  }

  int memberState = 0;
  int size = 3;
  bool needAuth = true;

  void verifyToken() async {
    try {
      await context.read<AuthProvider>().initVar();
      final result = await UserProvider().confirmToken();
      if (result.isNotEmpty) {
        if (!mounted) return;
        setToken(context, result['token']);
      } else {
        if (!mounted) return;
        throw Error();
      }
    } catch (error) {
      showModal(context,
          page: const CustomAlert(
            title: '로그인 확인',
            content: '로그인이 필요합니다',
          ))();
      // setState(() {
      // });
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: GroupAppBar(
          groupId: widget.groupId,
          isMember: memberState != 0,
          isAdmin: memberState == 2,
        ),
      ),
      body: SingleChildScrollView(
          child: FutureBuilder(
        future: GroupProvider().readGroupDetail(
          widget.groupId,
          widget.password,
        ),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final GroupDetailModel data = snapshot.data!;
            if (memberState != data.memberState) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() {
                  memberState = data.memberState;
                });
              });
            }
            if (needAuth != data.needAuth) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() {
                  needAuth = data.needAuth;
                });
              });
            }
            if (size != data.bingoSize) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() {
                  size = data.bingoSize;
                });
              });
            }

            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.read<GlobalGroupProvider>().setData(data);
              context.read<GlobalGroupProvider>().setGroupId(widget.groupId);
              // setState(() {
              //   needAuth = data.needAuth;
              // });
            });
            // setMemberState(data.memberState);
            return ColWithPadding(
              vertical: 30,
              horizontal: 30,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                data.hasImage
                    ? Image.network(
                        '${dotenv.env['fileUrl']}/groups/${widget.groupId}')
                    : const SizedBox(),
                groupHeader(data),
                const SizedBox(height: 20),
                data.memberState != 0
                    ? CustomButton(
                        onPressed: toOtherPage(
                          context,
                          page: data.bingoId != 0
                              ? BingoDetail(bingoId: data.bingoId!)
                              : BingoForm(
                                  bingoSize: data.bingoSize,
                                  needAuth: data.needAuth,
                                ),
                        ),
                        content: data.bingoId != 0 ? '내 빙고 보기' : '내 빙고 만들기',
                      )
                    : const SizedBox(),
                ShowContentBox(
                    contentTitle: '설명', content: data.description ?? ''),
                ShowContentBox(contentTitle: '규칙', content: data.rule ?? ''),
                // groupRankTop3(context, data),
              ],
            );
          }
          return const Center(child: CustomText(content: '정보를 불러오는 중입니다'));
        },
      )),
      bottomNavigationBar: BottomBar(
        isMember: memberState != 0,
        groupId: widget.groupId,
        needAuth: needAuth,
        size: size,
      ),
    );
  }

  Padding groupRankTop3(BuildContext context, GroupDetailModel data) {
    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RowWithPadding(
            vertical: 10,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const CustomText(content: '랭킹'),
              TextButton(
                onPressed: memberState != 0
                    ? toOtherPage(
                        context,
                        page: GroupRank(
                          groupId: widget.groupId,
                          isMember: memberState != 0,
                        ),
                      )
                    : null,
                child: const CustomText(
                  content: '전체보기',
                  fontSize: FontSize.smallSize,
                ),
              )
            ],
          ),
          // for (int i = 0; i < 3; i += 1)
          //   RankListItem(
          //     rank: i + 1,
          //     rankListItem: data.rank,
          //     isMember: memberState != 0,
          //   ),
        ],
      ),
    );
  }

  Column groupHeader(GroupDetailModel data) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(content: data.groupName, fontSize: FontSize.titleSize),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: CustomText(content: '참여 인원 ${data.count}/${data.headCount}'),
        ),
        CustomText(content: '${data.start} ~ ${data.end}'),
      ],
    );
  }
}
