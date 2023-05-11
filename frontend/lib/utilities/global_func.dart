import 'package:bin_got/providers/root_provider.dart';
import 'package:bin_got/utilities/image_icon_utils.dart';
import 'package:bin_got/utilities/style_utils.dart';
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
void toBack(BuildContext context) => Navigator.pop(context);

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

//* token
String? getToken(BuildContext context) => context.read<AuthProvider>().token;

void setToken(BuildContext context, String? newToken) =>
    context.read<AuthProvider>().setStoreToken(newToken);

void setTokens(BuildContext context, String? newToken, String? newRefresh) {
  final auth = context.read<AuthProvider>();
  auth.setStoreToken(newToken);
  auth.setStoreRefresh(newRefresh);
}

//* id
int? getId(BuildContext context) => context.read<AuthProvider>().id;

//* notifications
void setNoti(
  BuildContext context, {
  required bool rank,
  required int due,
  required bool chat,
}) {
  final noti = context.read<NotiProvider>();
  noti.setStoreRank(rank);
  noti.setStoreDue(due);
  noti.setStoreChat(chat);
}

//* group data
int? getGroupId(BuildContext context) =>
    context.read<GlobalGroupProvider>().groupId;

int? getBingoSize(BuildContext context) =>
    context.read<GlobalGroupProvider>().bingoSize;

// void setGroupData(BuildContext context) =>
//     context.read<GlobalGroupProvider>().setData();

//* bingo data

//* function
void changeBingoData(BuildContext context, int tabIndex, int i) =>
    context.read<GlobalBingoProvider>().changeData(tabIndex, i);

void setOption(BuildContext context, String key, dynamic value) =>
    context.read<GlobalBingoProvider>().setOption(key, value);

void setBingoData(BuildContext context, DynamicMap data) =>
    context.read<GlobalBingoProvider>().setData(data);

void setItem(BuildContext context, int index, DynamicMap item) =>
    context.read<GlobalBingoProvider>().setItem(index, item);

//* var
DynamicMap getBingoData(BuildContext context) =>
    context.read<GlobalBingoProvider>().data;

String? getTitle(BuildContext context) =>
    context.watch<GlobalBingoProvider>().title;

int? getBackground(BuildContext context) =>
    context.watch<GlobalBingoProvider>().background;

bool getHasBlackBox(BuildContext context) =>
    context.watch<GlobalBingoProvider>().hasBlackBox;

bool getHasRoundEdge(BuildContext context) =>
    context.watch<GlobalBingoProvider>().hasRoundEdge;

bool getHasBorder(BuildContext context) =>
    context.watch<GlobalBingoProvider>().hasBorder;

int? getGap(BuildContext context) => context.watch<GlobalBingoProvider>().gap;

int? getFont(BuildContext context) => context.watch<GlobalBingoProvider>().font;

int? getCheckIcon(BuildContext context) =>
    context.watch<GlobalBingoProvider>().checkIcon;

DynamicMapList getItems(BuildContext context) =>
    context.read<GlobalBingoProvider>().items;

String getStringFont(BuildContext context) => matchFont[getFont(context)!];

IconData getCheckIconData(BuildContext context) =>
    iconList[getCheckIcon(context)!];
