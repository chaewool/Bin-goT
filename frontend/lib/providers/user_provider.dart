import 'package:bin_got/providers/api_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

class PersonalApi {
  final verifyTokenUrl = '$tokenUrl/verify/';
  final takeTokenUrl = '$tokenUrl/';
  final refreshTokenUrl = '$tokenUrl/refresh/';

  final checkNameUrl = '$usernameUrl/check/';
  final changeNameUrl = '$usernameUrl/update/';

  final groupListUrl = '$profileUrl/groups/';

  final badgeListUrl = '$badgeUrl/list/';
  final changeBadgeUrl = '$badgeUrl/update/';

  final notiUrl = '$accountUrl/notification/update/';

  final exitService = '$kakaoUrl/unlink/';

  // static Future<List<MyGroupModel>> getMyGroups() async {
  //   MyGroupList myGroupList = [];
  //   final response = await dio.get(groupListUrl);
  // }
}

void login(BuildContext context) async {
  try {
    await UserApi.instance.loginWithKakaoAccount();
  } catch (error) {
    if (error is PlatformException && error.code == 'CANCELED') {
      return;
    }
  }
  //* 카카오톡 설치 여부 확인
  // if (await isKakaoTalkInstalled()) {
  //   try {
  //     await UserApi.instance.loginWithKakaoTalk();
  //   } catch (error) {
  //     // 사용자가 카카오톡 설치 후 디바이스 권한 요청 화면에서 로그인을 취소한 경우,
  //     // 의도적인 로그인 취소로 보고 카카오계정으로 로그인 시도 없이 로그인 취소로 처리 (예: 뒤로 가기)
  //     if (error is PlatformException && error.code == 'CANCELED') {
  //       return;
  //     }
  //     //* 카카오톡에 연결된 카카오계정이 없는 경우, 카카오계정으로 로그인
  //     try {
  //       var accessToken = await UserApi.instance.loginWithKakaoAccount();
  //       print(accessToken);
  //     } catch (error) {
  //       showModal(context: context, page: errorModal)();
  //     }
  //   }
  // } else {
  //   try {
  //     var accessToken = await UserApi.instance.loginWithKakaoAccount();
  //     print(accessToken);
  //   } catch (error) {
  //     showModal(context: context, page: errorModal)();
  //   }
  // }
}
