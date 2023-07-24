import 'package:bin_got/pages/intro_page.dart';
import 'package:bin_got/pages/main_page.dart';
import 'package:bin_got/providers/root_provider.dart';
import 'package:bin_got/providers/user_provider.dart';
import 'package:bin_got/utilities/image_icon_utils.dart';
import 'package:bin_got/utilities/style_utils.dart';
import 'package:bin_got/utilities/type_def_utils.dart';
import 'package:bin_got/widgets/modal.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kakao_flutter_sdk_share/kakao_flutter_sdk_share.dart';
import 'package:provider/provider.dart';

//* 함수

//* 공유 템플릿
TextTemplate defaultText({
  required int id,
  required bool isGroup,
  String? password,
}) {
  return TextTemplate(
    text: isGroup
        ? 'ㅇㅇㅇ 그룹에서\n당신을 기다리고 있어요\nBin:goT에서\n같이 계획을 공유해보세요'
        : 'ㅇㅇㅇ 님이 빙고판을 공유했어요! 자세히 살펴보세요.',
    link: Link(
      mobileWebUrl: Uri.parse(''),
    ),
  );
}

//* 공유
void shareGroup({required int groupId, String? password}) async {
  bool isKakaoTalkSharingAvailable =
      await ShareClient.instance.isKakaoTalkSharingAvailable();

  if (isKakaoTalkSharingAvailable) {
    try {
      Uri uri = await ShareClient.instance.shareDefault(
        template: defaultText(
          isGroup: true,
          id: groupId,
          password: password,
        ),
      );
      await ShareClient.instance.launchKakaoTalk(uri);
      print('카카오톡 공유 완료');
    } catch (error) {
      print('카카오톡 공유 실패 $error');
    }
  } else {
    try {
      Uri shareUrl = await WebSharerClient.instance.makeDefaultUrl(
        template: defaultText(
          isGroup: true,
          id: groupId,
          password: password,
        ),
      );
      await launchBrowserTab(shareUrl, popupOpen: true);
    } catch (error) {
      print('카카오톡 공유 실패 $error');
    }
  }
}

void shareBingo({required int bingoId}) async {
  bool isKakaoTalkSharingAvailable =
      await ShareClient.instance.isKakaoTalkSharingAvailable();

  if (isKakaoTalkSharingAvailable) {
    try {
      Uri uri = await ShareClient.instance.shareDefault(
        template: defaultText(
          id: bingoId,
          isGroup: false,
        ),
      );
      await ShareClient.instance.launchKakaoTalk(uri);
      print('카카오톡 공유 완료');
    } catch (error) {
      print('카카오톡 공유 실패 $error');
    }
  } else {
    try {
      Uri shareUrl = await WebSharerClient.instance.makeDefaultUrl(
        template: defaultText(
          id: bingoId,
          isGroup: false,
        ),
      );
      await launchBrowserTab(shareUrl, popupOpen: true);
    } catch (error) {
      print('카카오톡 공유 실패 $error');
    }
  }
}

Future<String> buildDynamicLink(bool isPublic, int groupId) async {
  String uriPrefix = dotenv.env['dynamicLinkPrefix']!;

  final DynamicLinkParameters parameters = DynamicLinkParameters(
    uriPrefix: uriPrefix,
    link: Uri.parse('https://groups?isPublic=$isPublic&groupId=$groupId'),
    androidParameters:
        AndroidParameters(packageName: dotenv.env['packageName']!),
  );
  final dynamicLink =
      await FirebaseDynamicLinks.instance.buildShortLink(parameters);
  return dynamicLink.shortUrl.toString();
}

//* 페이지 이동
ReturnVoid toOtherPage(BuildContext context, {required Widget page}) {
  return () =>
      Navigator.push(context, MaterialPageRoute(builder: (context) => page));
}

//* 인트로 페이지 이동 (기록 X)
Future<bool?> toOtherPageWithoutPath(BuildContext context, {Widget? page}) {
  return Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => page ?? const Intro()),
    (router) => false,
  );
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
Future<bool?> Function() showModal(BuildContext context,
    {required Widget page}) {
  return () => showDialog<bool>(
        barrierDismissible: false,
        context: context,
        builder: (context) => page,
      );
}

//* login
void login(BuildContext context) async {
  try {
    UserProvider().login().then((data) {
      setTokens(context, data['access_token'], data['refresh_token']);
      setNoti(
        context,
        rank: data['noti_rank'],
        due: data['noti_due'],
        chat: data['noti_chat'],
        complete: data['noti_check'],
      );
      context.read<AuthProvider>().setStoreId(data['id']);
      if (data['is_login']) {
        toOtherPage(context, page: const Main())();
      } else {
        showModal(context, page: const ChangeNameModal())();
      }
    }).catchError((error) {
      showAlert(context, title: '로그인 오류', content: '오류가 발생해 로그인에 실패했습니다.')();
    });
  } catch (error) {
    showAlert(context, title: '로그인 오류', content: '오류가 발생해 로그인에 실패했습니다.')();
  }
}

void showLoginModal(BuildContext context) => showAlert(
      context,
      title: '토큰 만료',
      content: '토큰이 만료되었습니다. 재로그인하시겠습니까?',
      onPressed: () => login(context),
    )();

void showErrorModal(BuildContext context) => showAlert(
      context,
      title: '오류 발생',
      content: '오류가 발생했습니다.',
      hasCancel: false,
    )();

//* token
String? getToken(BuildContext context) => context.read<AuthProvider>().token;

void setToken(BuildContext context, String newToken) =>
    context.read<AuthProvider>().setStoreToken(newToken);

void setTokens(BuildContext context, String newToken, String newRefresh) {
  context.read<AuthProvider>().setStoreToken(newToken);
  context.read<AuthProvider>().setStoreRefresh(newRefresh);
}

void deleteVar(BuildContext context) {
  context.read<AuthProvider>().deleteVar();
  context.read<NotiProvider>().deleteVar();
}

//* id
int? getId(BuildContext context) => context.read<AuthProvider>().id;

//* notifications
void setNoti(
  BuildContext context, {
  required bool rank,
  required bool due,
  required bool chat,
  required bool complete,
}) {
  context.read<NotiProvider>().setStoreRank(rank);
  context.read<NotiProvider>().setStoreDue(due);
  context.read<NotiProvider>().setStoreChat(chat);
  context.read<NotiProvider>().setStoreComplete(complete);
}

//* size
double getWidth(BuildContext context) => MediaQuery.of(context).size.width;
double getHeight(BuildContext context) => MediaQuery.of(context).size.height;

//* exit app
FutureBool exitApp(BuildContext context) =>
    context.read<NotiProvider>().changePressed();

//* 뒤로 가기 버튼 눌림 여부
bool watchPressed(BuildContext context) =>
    context.watch<NotiProvider>().beforeExit;

//* scroll
int? getTotal(BuildContext context, int mode) {
  switch (mode) {
    case 0:
      return context.read<GlobalScrollProvider>().lastPage;
    case 1:
      return context.read<GlobalGroupProvider>().lastPage;
    default:
      return context.read<GlobalBingoProvider>().lastPage;
  }
}

// void setTotal(BuildContext context,
//     {required int mode, required int newTotal}) {
//   switch (mode) {
//     case 0:
//       return context.read<GlobalScrollProvider>().setTotal(newTotal);
//     case 1:
//       return context.read<GlobalGroupProvider>().setTotalPage(newTotal);
//     default:
//       return context.read<GlobalBingoProvider>().setTotalPage(newTotal);
//   }
// }

bool readLoading(BuildContext context) =>
    context.read<GlobalScrollProvider>().loading;

bool getLoading(BuildContext context) =>
    context.watch<GlobalScrollProvider>().loading;

void setLoading(BuildContext context, bool value) =>
    context.read<GlobalScrollProvider>().setLoading(value);

int getPage(BuildContext context, int mode) {
  switch (mode) {
    case 0:
      return context.read<GlobalScrollProvider>().page;
    case 1:
      return context.read<GlobalGroupProvider>().page;
    default:
      return context.read<GlobalBingoProvider>().page;
  }
}

void increasePage(BuildContext context, int mode) {
  switch (mode) {
    case 0:
      return context.read<GlobalScrollProvider>().increasePage();
    case 1:
      return context.read<GlobalGroupProvider>().increasePage();
    default:
      return context.read<GlobalBingoProvider>().increasePage();
  }
}

void initPage(BuildContext context, int mode) {
  switch (mode) {
    case 0:
      return context.read<GlobalScrollProvider>().initPage();
    case 1:
      return context.read<GlobalGroupProvider>().initPage();
    default:
      return context.read<GlobalBingoProvider>().initPage();
  }
}

bool getWorking(BuildContext context) =>
    context.read<GlobalScrollProvider>().working;

void setWorking(BuildContext context, bool value) =>
    context.read<GlobalScrollProvider>().setWorking(value);

bool getAdditional(BuildContext context) =>
    context.read<GlobalScrollProvider>().additional;

void setAdditional(BuildContext context, bool value) =>
    context.read<GlobalScrollProvider>().setAdditional(value);

void initLoadingData(BuildContext context, int mode) {
  setLoading(context, true);
  initPage(context, mode);
  setAdditional(context, false);
  setWorking(context, false);
}

//* group data
int? getGroupId(BuildContext context) =>
    context.read<GlobalGroupProvider>().groupId;

int? getBingoSize(BuildContext context) =>
    context.read<GlobalGroupProvider>().bingoSize;

String? getStart(BuildContext context) =>
    context.read<GlobalGroupProvider>().start;

void setStart(BuildContext context, String newStart) =>
    context.read<GlobalGroupProvider>().setStart(newStart);

void setGroupData(BuildContext context, dynamic newVal) =>
    context.read<GlobalGroupProvider>().setData(newVal);

void setGroupId(BuildContext context, int newVal) =>
    context.read<GlobalGroupProvider>().setGroupId(newVal);

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

List getItems(BuildContext context) =>
    context.read<GlobalBingoProvider>().items;

String? getItemTitle(BuildContext context, int index) =>
    context.watch<GlobalBingoProvider>().item(index)['title'];

DynamicMap readItem(BuildContext context, int index) =>
    context.read<GlobalBingoProvider>().item(index);

String getStringFont(BuildContext context) => matchFont[getFont(context)!];

IconData getCheckIconData(BuildContext context) =>
    iconList[getCheckIcon(context)!];
