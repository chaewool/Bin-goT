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
  final bool isPublic;
  final int groupId;
  const InputPassword({
    super.key,
    required this.isPublic,
    required this.groupId,
  });

  @override
  State<InputPassword> createState() => _InputPasswordState();
}

class _InputPasswordState extends State<InputPassword> {
  StringMap password = {'value': ''};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (getToken(context) != null) {
        verifyToken();
      } else {
        showModal(
          context,
          page: const CustomAlert(
            title: '로그인 확인',
            content: '로그인이 필요합니다',
          ),
        )();
      }
      if (!widget.isPublic) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return WillPopScope(
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
            );
          },
        );
      } else {
        GroupProvider().readGroupDetail(widget.groupId, '').then((data) {
          setGroupData(context, data);
          setGroupId(context, widget.groupId);
          print('group id : ${widget.groupId}');
          toOtherPage(
            context,
            page: GroupMain(
              groupId: widget.groupId,
              data: data,
            ),
          )();
        });
      }
    });
  }

  void verifyToken() async {
    try {
      await context.read<AuthProvider>().initVar();
      UserProvider().confirmToken().then((result) {
        if (result.isNotEmpty) {
          setToken(context, result['token']);
        } else {
          showModal(
            context,
            page: const CustomAlert(
              title: '로그인 확인',
              content: '로그인이 필요합니다',
            ),
          )();
        }
      });
    } catch (error) {
      showModal(
        context,
        page: const CustomAlert(
          title: '로그인 확인',
          content: '로그인이 필요합니다',
        ),
      )();
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
        return Future.value(false);
      },
      child: const CustomBoxContainer(),
    );
  }
}
