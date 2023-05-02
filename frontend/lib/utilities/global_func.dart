import 'package:bin_got/providers/root_provider.dart';
import 'package:bin_got/utilities/type_def_utils.dart';
import 'package:bin_got/widgets/modal.dart';
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk_share/kakao_flutter_sdk_share.dart';
import 'package:provider/provider.dart';

//* 함수

//* 공유 템플릿
TextTemplate defaultText({
  required int groupId,
  String? password,
}) {
  return TextTemplate(
    text: 'ㅇㅇㅇ 그룹에서\n당신을 기다리고 있어요\nBin:goT에서\n같이 계획을 공유해보세요',
    link: Link(
      webUrl: Uri.parse(''),
      mobileWebUrl: Uri.parse(''),
    ),
  );
}

//* 공유
void shareToFriends({required int groupId, String? password}) async {
  bool isKakaoTalkSharingAvailable =
      await ShareClient.instance.isKakaoTalkSharingAvailable();

  if (isKakaoTalkSharingAvailable) {
    try {
      Uri uri = await ShareClient.instance.shareDefault(
          template: defaultText(
        groupId: groupId,
        password: password,
      ));
      await ShareClient.instance.launchKakaoTalk(uri);
      print('카카오톡 공유 완료');
    } catch (error) {
      print('카카오톡 공유 실패 $error');
    }
  } else {
    try {
      Uri shareUrl = await WebSharerClient.instance.makeDefaultUrl(
          template: defaultText(
        groupId: groupId,
        password: password,
      ));
      await launchBrowserTab(shareUrl, popupOpen: true);
    } catch (error) {
      print('카카오톡 공유 실패 $error');
    }
  }
}

//* 페이지 이동
ReturnVoid toOtherPage(BuildContext context, {required Widget page}) {
  return () =>
      Navigator.push(context, MaterialPageRoute(builder: (context) => page));
}

//* 뒤로 가기
ReturnVoid toBack(BuildContext context) {
  return () => Navigator.pop(context);
}

//* alert 띄우기
ReturnVoid showAlert(
  BuildContext context, {
  required String title,
  required String content,
  ReturnVoid? onPressed,
  bool hasCancel = true,
}) {
  return () => showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => CustomAlert(
            title: title,
            content: content,
            onPressed: onPressed,
            hasCancel: hasCancel,
          ));
}

//* modal 띄우기
ReturnVoid showModal(BuildContext context, {required Widget page}) {
  return () => showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => page,
      );
}

//*
String? getToken(BuildContext context) => context.read<AuthProvider>().token;

void setToken(BuildContext context, String? newToken) =>
    context.read<AuthProvider>().setStoreToken(newToken);

void setTokens(BuildContext context, String? newToken, String? newRefresh) {
  final auth = context.read<AuthProvider>();
  auth.setStoreToken(newToken);
  auth.setStoreRefresh(newRefresh);
}

void setNoti(BuildContext context, {bool? rank, bool? due, bool? chat}) {
  final noti = context.read<NotiProvider>();
  noti.setStoreRank(rank);
  noti.setStoreDue(due);
  noti.setStoreChat(chat);
}
