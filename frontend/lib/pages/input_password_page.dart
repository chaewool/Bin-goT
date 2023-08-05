import 'package:bin_got/pages/group_main_page.dart';
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
  final bool isPublic, needCheck, isSearchMode;
  final int groupId;
  const InputPassword({
    super.key,
    required this.isPublic,
    required this.groupId,
    this.needCheck = false,
    this.isSearchMode = true,
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

      if (!widget.isPublic && widget.isSearchMode) {
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
        print('public==========');
        GroupProvider().readGroupDetail(widget.groupId, '').then((data) {
          print('1-------');
          setGroupData(context, data);
          print('2-------');
          setGroupId(context, widget.groupId);
          print('3-------');
          setPublic(context, widget.isPublic);
          print('4-------');
          toOtherPage(
            context,
            page: GroupMain(
              groupId: widget.groupId,
              data: data,
            ),
          )();
        }).catchError((error) {
          print(error);
          showAlert(
            context,
            title: '오류 발생',
            content: '오류가 발생해 그룹 정보를 받아올 수 없습니다',
            hasCancel: false,
            onPressed: () {
              toBack(context);
              toBack(context);
            },
          )();
        });
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
      GroupProvider().readGroupDetail(widget.groupId, password).then((data) {
        print(data);
        toBack(context);
        setGroupData(context, data);
        setGroupId(context, widget.groupId);
        setPublic(context, widget.isPublic);
        toOtherPage(
          context,
          page: GroupMain(
            groupId: widget.groupId,
            data: data,
          ),
        )();
      }).catchError((error) {
        print(error);
        showAlert(
          context,
          title: '오류 발생',
          content: '오류가 발생해 요청 작업을 처리하지 못했습니다',
        )();
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
