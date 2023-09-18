import 'package:bin_got/dl_settings.dart';
import 'package:bin_got/fcm_settings.dart';
import 'package:bin_got/models/group_model.dart';
import 'package:bin_got/pages/intro_page.dart';
import 'package:bin_got/pages/main_page.dart';
import 'package:bin_got/providers/root_provider.dart';
import 'package:bin_got/providers/user_provider.dart';
import 'package:bin_got/utilities/image_icon_utils.dart';
import 'package:bin_got/utilities/style_utils.dart';
import 'package:bin_got/utilities/type_def_utils.dart';
import 'package:bin_got/widgets/modal.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kakao_flutter_sdk_share/kakao_flutter_sdk_share.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

//* 함수

//* 지연
void afterFewSec(int millisec, ReturnVoid afterFunc) =>
    Future.delayed(Duration(milliseconds: millisec), afterFunc);

//* 이미지
void imagePicker(
  BuildContext context, {
  ReturnVoid? elseFunc,
  void Function(XFile?)? thenFunc,
}) async {
  Permission.storage.request().then((value) {
    if (value == PermissionStatus.denied ||
        value == PermissionStatus.permanentlyDenied) {
      showAlert(
        context,
        title: '미디어 접근 권한 거부',
        content: '미디어 접근 권한이 없습니다. 설정에서 접근 권한을 수정하시겠습니까?',
        hasCancel: true,
        onPressed: () {
          openAppSettings();
          toBack(context);
        },
      )();
    } else {
      if (elseFunc != null) {
        elseFunc();
      } else {
        final ImagePicker picker = ImagePicker();
        picker
            .pickImage(
          source: ImageSource.gallery,
          imageQuality: 70,
        )
            .then((localImage) {
          if (thenFunc != null) {
            thenFunc(localImage);
          }
        }).catchError((error) {
          showErrorModal(context);
        });
      }
    }
  });
}

//* 공유 템플릿
TextTemplate defaultText({
  required int id,
  // required bool isGroup,
  // String? password,
  required String groupName,
  required String url,
}) {
  print(url);
  return TextTemplate(
    text: '$groupName 그룹에서\n당신을 기다리고 있어요\n그룹에 참여하여\n같이 빈 곳을 채워보세요 :)\n',
    buttonTitle: '앱으로 이동하기/앱 설치하기',
    link: Link(
      mobileWebUrl: Uri.parse(url),
    ),
  );
}

//* 공유
void shareGroup({
  required int groupId,
  required groupName,
}) async {
  bool isKakaoTalkSharingAvailable =
      await ShareClient.instance.isKakaoTalkSharingAvailable();

  String url = await DynamicLink().buildDynamicLink(groupId);

  if (isKakaoTalkSharingAvailable) {
    try {
      Uri uri = await ShareClient.instance.shareDefault(
        template: defaultText(
          id: groupId,
          // password: password,
          groupName: groupName,
          url: url,
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
          id: groupId,
          groupName: groupName,
          // password: password,
          url: url,
        ),
      );
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

//* 인트로 페이지 이동 (기록 X)
Future<bool?> toOtherPageWithoutPath(BuildContext context, {Widget? page}) {
  return Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => page ?? const Intro()),
    (router) => false,
  );
}

ReturnVoid jumpToOtherPage(BuildContext context, {required Widget page}) {
  return () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => page,
        ),
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
      context.read<AuthProvider>().setStoreId(data['id']);
      FCM().saveFCMToken();
      if (data['is_login']) {
        toOtherPage(context, page: const Main())();
      } else {
        showModal(context, page: const ChangeNameModal())().then((value) {
          toOtherPage(context, page: const Main())();
        });
      }
    }).catchError((error) {
      showAlert(context, title: '로그인 오류', content: '오류가 발생해 로그인에 실패했습니다.')();
    });
  } catch (error) {
    showAlert(context, title: '로그인 오류', content: '오류가 발생해 로그인에 실패했습니다.')();
  }
}

//* modal
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

//* date
String returnDate(GroupChatModel data) => data.createdAt.split(' ')[0];

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
  // context.read<NotiProvider>().deleteVar();
}

//* id
int? getId(BuildContext context) => context.read<AuthProvider>().id;

//* notifications

//* size
double getWidth(BuildContext context) => MediaQuery.of(context).size.width;
double getHeight(BuildContext context) => MediaQuery.of(context).size.height;

//* exit app
FutureBool exitApp(BuildContext context) =>
    context.read<NotiProvider>().changePressed();

//* 뒤로 가기 버튼 눌림 여부
bool watchPressed(BuildContext context) =>
    context.watch<NotiProvider>().beforeExit;

//* toast
void showToast(BuildContext context) =>
    context.read<NotiProvider>().showToast();

bool watchAfterWork(BuildContext context) =>
    context.watch<NotiProvider>().afterWork;

//* spinner
void showSpinner(BuildContext context, bool showState) =>
    context.read<NotiProvider>().showSpinner(showState);

bool watchSpinner(BuildContext context) =>
    context.watch<NotiProvider>().spinnerState;

//* scroll

bool getLoading(BuildContext context) =>
    context.read<GlobalScrollProvider>().loading;

bool watchLoading(BuildContext context) =>
    context.watch<GlobalScrollProvider>().loading;

void setLoading(BuildContext context, bool value) =>
    context.read<GlobalScrollProvider>().setLoading(value);

int getLastId(BuildContext context, int mode) {
  switch (mode) {
    case 0:
      return context.read<GlobalScrollProvider>().lastId!;
    case 1:
      return context.read<GlobalGroupProvider>().lastId!;
    default:
      return context.read<GlobalBingoProvider>().lastId!;
  }
}

void setLastId(BuildContext context, int mode, int lastId) {
  switch (mode) {
    case 0:
      return context.read<GlobalScrollProvider>().setLastId(lastId);
    case 1:
      return context.read<GlobalGroupProvider>().setLastId(lastId);
    default:
      return context.read<GlobalBingoProvider>().setLastId(lastId);
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
  setLastId(context, mode, 0);
  // initPage(context, mode);
  setAdditional(context, false);
  setWorking(context, false);
}

//* group data
int? myBingoId(BuildContext context) =>
    context.read<GlobalGroupProvider>().bingoId;

int groupSelectedIndex(BuildContext context) =>
    context.watch<GlobalGroupProvider>().selectedIndex;

int? watchMemberState(BuildContext context) =>
    context.watch<GlobalGroupProvider>().memberState;

int? getMemberState(BuildContext context) =>
    context.read<GlobalGroupProvider>().memberState;

int? getGroupId(BuildContext context) =>
    context.read<GlobalGroupProvider>().groupId;

int? getBingoSize(BuildContext context) =>
    context.read<GlobalGroupProvider>().bingoSize;

String? getStart(BuildContext context) =>
    context.read<GlobalGroupProvider>().start;

bool? getPublic(BuildContext context) =>
    context.read<GlobalGroupProvider>().isPublic;

bool? getNeedAuth(BuildContext context) =>
    context.read<GlobalGroupProvider>().needAuth;

bool? alreadyStarted(BuildContext context) =>
    context.read<GlobalGroupProvider>().alreadyStarted;

bool watchPrev(BuildContext context) =>
    context.watch<GlobalGroupProvider>().prev;

String? getGroupName(BuildContext context) =>
    context.read<GlobalGroupProvider>().groupName;

GroupChatList getChats(BuildContext context) =>
    context.read<GlobalGroupProvider>().chats;

GroupChatList watchChats(BuildContext context) =>
    context.watch<GlobalGroupProvider>().chats;

void setStart(BuildContext context, String newStart) =>
    context.read<GlobalGroupProvider>().setStart(newStart);

void setGroupData(BuildContext context, dynamic newVal) =>
    context.read<GlobalGroupProvider>().setData(newVal);

void setGroupId(BuildContext context, int newVal) =>
    context.read<GlobalGroupProvider>().setGroupId(newVal);

void setPublic(BuildContext context, bool? newVal) =>
    context.read<GlobalGroupProvider>().setPublic(newVal);

void changeGroupIndex(BuildContext context, int index) =>
    context.read<GlobalGroupProvider>().changeIndex(index);

void changePrev(BuildContext context, bool value) =>
    context.read<GlobalGroupProvider>().toPrevPage(value);

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

void initFinished(BuildContext context, int size) =>
    context.read<GlobalBingoProvider>().initFinished(size);

void setFinished(BuildContext context, int index, bool value) =>
    context.read<GlobalBingoProvider>().setFinished(index, value);

void setBingoId(BuildContext context, int id) =>
    context.read<GlobalBingoProvider>().setBingoId(id);

void setBingoSize(BuildContext context, int size) =>
    context.read<GlobalBingoProvider>().setBingoSize(size);

// void setIsMine(BuildContext context, bool isMine) =>
//     context.read<GlobalBingoProvider>().setIsMine(isMine);

void initBingoData(BuildContext context) =>
    context.read<GlobalBingoProvider>().initData();

//* var
int? getBingoId(BuildContext context) =>
    context.read<GlobalBingoProvider>().bingoId;
int? watchBingoId(BuildContext context) =>
    context.watch<GlobalBingoProvider>().bingoId;

DynamicMap getBingoData(BuildContext context) =>
    context.read<GlobalBingoProvider>().data;

String? watchTitle(BuildContext context) =>
    context.watch<GlobalBingoProvider>().title;

int? watchBackground(BuildContext context) =>
    context.watch<GlobalBingoProvider>().background;

bool watchHasBlackBox(BuildContext context) =>
    context.watch<GlobalBingoProvider>().hasBlackBox;

bool watchHasRoundEdge(BuildContext context) =>
    context.watch<GlobalBingoProvider>().hasRoundEdge;

bool watchHasBorder(BuildContext context) =>
    context.watch<GlobalBingoProvider>().hasBorder;

BoolList? watchFinished(BuildContext context) =>
    context.watch<GlobalBingoProvider>().finished;

int? watchGap(BuildContext context) => context.watch<GlobalBingoProvider>().gap;

int? watchFont(BuildContext context) =>
    context.watch<GlobalBingoProvider>().font;

int? watchCheckIcon(BuildContext context) =>
    context.watch<GlobalBingoProvider>().checkIcon;

List getItems(BuildContext context) =>
    context.read<GlobalBingoProvider>().items;

String? watchItemTitle(BuildContext context, int index) =>
    context.watch<GlobalBingoProvider>().item(index)['title'];

DynamicMap readItem(BuildContext context, int index) =>
    context.read<GlobalBingoProvider>().item(index);

String getStringFont(BuildContext context) => matchFont[watchFont(context)!];

IconData getCheckIconData(BuildContext context) =>
    iconList[watchCheckIcon(context)!];

// bool? getIsMine(BuildContext context) =>
//     context.read<GlobalBingoProvider>().isMine;
