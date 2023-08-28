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

class InputPassword extends StatefulWidget {
  final bool isPublic, needCheck, isSearchMode, admin;
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
    this.bingoId,
    this.size,
  });

  @override
  State<InputPassword> createState() => _InputPasswordState();
}

class _InputPasswordState extends State<InputPassword> {
  StringMap password = {'value': ''};
  Future<bool?> showLoginModal() => showModal(
        context,
        page: CustomAlert(
          title: '로그인 확인',
          content: '로그인이 필요합니다',
          onPressed: () => login(context),
        ),
      )();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      //* 알림을 통해 들어왔을 경우, 로그인 확인 (알림으로 들어왔을 경우, 가입된 경우 => 확인 X)
      if (widget.needCheck) {
        if (getToken(context) == null) {
          //* 로그인 팝업
          await showLoginModal();
        } else {
          try {
            //* 토큰 유효성 검사
            await verifyToken();
          } catch (error) {
            //* 로그인 팝업
            await showLoginModal();
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
        // ignore: use_build_context_synchronously
        toOtherPage(
          context,
          page: GroupDetail(
            groupId: widget.groupId,
            admin: widget.admin,
            // password: '',
            isPublic: widget.isPublic,
            initialIndex: widget.initialIndex,
            bingoId: widget.bingoId,
            size: widget.size,
            // data: data,
          ),
        )();
      }
    });
  }

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

  void verifyPassword(String? password) {
    print('password => $password');
    if (password == null || password == '') {
      showAlert(context, title: '유효하지 않은 비밀번호', content: '비밀번호를 입력해주세요')();
    } else {
      GroupProvider()
          .checkPassword(widget.groupId, password)
          .then((_) => toOtherPage(
                context,
                page: GroupDetail(
                  groupId: widget.groupId,
                  isPublic: widget.isPublic,
                  admin: widget.admin,
                  bingoId: widget.bingoId,
                  size: widget.size,
                  // password: password,
                ),
              ))
          .catchError((error) {
        print(error);
        return error;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        toBack(context);
        toBack(context);
        setPublic(context, null);
        return Future.value(false);
      },
      child: const CustomBoxContainer(),
    );
  }
}
