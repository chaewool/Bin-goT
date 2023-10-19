import 'package:bin_got/pages/group_detail_page.dart';
import 'package:bin_got/providers/group_provider.dart';
import 'package:bin_got/providers/root_provider.dart';
import 'package:bin_got/providers/user_provider.dart';
import 'package:bin_got/utilities/global_func.dart';
import 'package:bin_got/utilities/type_def_utils.dart';
import 'package:bin_got/widgets/container.dart';
import 'package:bin_got/widgets/modal.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//? 비밀번호 입력 여부 판단
class InputPassword extends StatefulWidget {
  final bool isPublic, needCheck, isSearchMode, admin, chat;
  final int groupId, initialIndex;
  final int? bingoId, size;
  const InputPassword({
    super.key,
    required this.isPublic,
    required this.groupId,
    this.initialIndex = 1,
    this.needCheck = false,
    this.isSearchMode = false,
    this.admin = false,
    this.chat = false,
    this.bingoId,
    this.size,
  });

  @override
  State<InputPassword> createState() => _InputPasswordState();
}

class _InputPasswordState extends State<InputPassword> {
  //* 변수
  StringMap password = {'value': ''};

  //* 로그인 확인 모달
  Future<bool?> showLoginModal() => showModal(
        context,
        page: CustomAlert(
          title: '로그인 확인',
          content: '로그인이 필요합니다',
          onPressed: () => login(context),
        ),
      )();

  //* 페이지 이동
  void toNextPage([member = true]) {
    setGroupId(context, widget.groupId);
    if (widget.bingoId != null) {
      setBingoId(context, widget.bingoId!);
    }
    if (widget.size != null) {
      setBingoSize(context, widget.size!);
    }
    // changeGroupIndex(context, widget.isSearchMode ? 0 : widget.initialIndex);
    jumpToOtherPage(
      context,
      page: GroupDetail(
        groupId: widget.groupId,
        admin: widget.admin,
        chat: widget.chat,
        bingoId: widget.bingoId,
        size: widget.size,
        isMember: member ? !widget.isSearchMode : false,
        initialIndex: widget.isSearchMode ? 0 : widget.initialIndex,
      ),
    )();
  }

  //* 비밀번호 확인
  void verifyPassword(String? password) {
    if (password == null || password == '') {
      showAlert(context, title: '유효하지 않은 비밀번호', content: '비밀번호를 입력해주세요')();
    } else {
      GroupProvider().checkPassword(widget.groupId, password).then((_) {
        toNextPage(false);
      }).catchError((error) {
        showAlert(context, title: '비밀번호 오류', content: '비밀번호가 맞지 않습니다.')();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    print('input password');
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      //* 알림을 통해 들어왔을 경우, 로그인 확인 (알림으로 들어왔을 경우, 가입된 경우 => 확인 X)
      if (widget.needCheck) {
        if (getToken(context) == null) {
          //* 로그인 팝업
          showLoginModal().then((_) {
            toNextPage();
          }).catchError((_) {
            showAlert(context,
                title: '로그인 오류', content: '오류가 발생해 로그인에 실패했습니다.')();
          });
        } else {
          try {
            //* 토큰 유효성 검사
            await verifyToken().then((_) {
              toNextPage();
            }).catchError((_) {
              throw Error();
            });
          } catch (error) {
            //* 로그인 팝업
            showLoginModal().then((_) {
              toNextPage();
            }).catchError((_) {
              showAlert(context,
                  title: '로그인 오류', content: '오류가 발생해 로그인에 실패했습니다.')();
            });
          }
        }
      }
      //* 공개 그룹이 아니고 검색을 통해 들어왔을 때
      else if (!widget.isPublic && widget.isSearchMode) {
        // ignore: use_build_context_synchronously
        showModal(
          context,
          page: WillPopScope(
            onWillPop: () {
              toBack(context);
              toBack(context);
              return Future.value(false);
            },
            child: InputModal(
              title: '비밀번호 입력',
              type: '비밀번호',
              setValue: (value) => password['value'] = value.trim(),
              onPressed: () => verifyPassword(password['value']),
              onCancelPressed: () {
                toBack(context);
                toBack(context);
              },
            ),
          ),
        )();
      } else {
        print('to next page');
        toNextPage();
      }
    });
  }

  //* 토큰 만료 여부 확인
  FutureBool verifyToken() async {
    try {
      await context.read<AuthProvider>().initVar();
      final answer = UserProvider().confirmToken().then((_) {
        return Future.value(true);
      }).catchError((error) {
        throw Error();
      });
      return answer;
    } catch (error) {
      showLoginModal();
      return Future.value(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        toBack(context);
        toBack(context);
        return Future.value(false);
      },
      child: CustomBoxContainer(
        width: getWidth(context),
        height: getHeight(context),
      ),
    );
  }
}
