import 'package:bin_got/models/user_model.dart';
import 'package:bin_got/providers/api_provider.dart';
import 'package:bin_got/utilities/type_def_utils.dart';
import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

class UserProvider {
  //* basic
  static const _accountUrl = '/accounts';
  static const _tokenUrl = '$_accountUrl/token';
  static const _usernameUrl = '$_accountUrl/username';
  static const _profileUrl = '$_accountUrl/profile';
  static const _badgeUrl = '$_accountUrl/badge';
  static const _kakaoUrl = '$_accountUrl/kakao';

  //* token
  static const _verifyTokenUrl = '$_tokenUrl/verify/';
  static const _takeTokenUrl = '$_tokenUrl/';
  static const _refreshTokenUrl = '$_tokenUrl/refresh/';

  //* username
  static const _checkNameUrl = '$_usernameUrl/check/';
  static const _changeNameUrl = '$_usernameUrl/update/';

  //* profile
  static const _groupListUrl = '$_profileUrl/groups/';

  //* badge
  static const _badgeListUrl = '$_badgeUrl/list/';
  static const _changeBadgeUrl = '$_badgeUrl/update/';

  //* notification
  static const _notiUrl = '$_accountUrl/notification/update/';

  //* kakao login
  static const _serviceToken = '$_kakaoUrl/native/';
  static const _exitService = '$_kakaoUrl/unlink/';

  static void _kakaoLoginWithAccount() async {
    try {
      var kakaoToken = await UserApi.instance.loginWithKakaoAccount();
      ApiProvider.createApi(_serviceToken,
          data: {'access_token': kakaoToken.accessToken});
    } catch (error) {
      // 사용자가 카카오톡 설치 후 디바이스 권한 요청 화면에서 로그인을 취소한 경우,
      // 의도적인 로그인 취소로 보고 카카오계정으로 로그인 시도 없이 로그인 취소로 처리 (예: 뒤로 가기)
      if (error is PlatformException && error.code == 'CANCELED') {
        return;
      }
      throw Error();
    }
  }

  static Future<bool> login() async {
    //* 카카오톡 설치 여부 확인
    if (await isKakaoTalkInstalled()) {
      try {
        //* 카카오톡에 연결된 카카오계정이 없는 경우, 카카오계정으로 로그인
        var kakaoToken = await UserApi.instance.loginWithKakaoTalk();
        await ApiProvider.createApi(_serviceToken,
            data: {'access_token': kakaoToken.accessToken});
        return true;
      } catch (error) {
        throw Error();
        // _kakaoLoginWithAccount();
      }
    } else {
      _kakaoLoginWithAccount();
      return false;
    }
  }

  static void tokenRefresh() async {
    try {
      dio.post(_refreshTokenUrl, data: {'refresh': ''});
    } catch (error) {}
  }

  static void confirmToken() async {
    try {
      //* 성공 실패 여부에 따라 분기 나누기
      dio.post(_verifyTokenUrl, data: {'token': ''});
    } catch (error) {}
  }

  static void checkName() async {
    try {
      ApiProvider.createApi(_checkNameUrl, data: {'username': ''});
    } catch (error) {
      throw Error();
    }
  }

  static void changeName() async {
    try {
      ApiProvider.createApi(_changeNameUrl, data: {'username': ''});
    } catch (error) {
      throw Error();
    }
  }

  static Future<MyGroupList> getMyGroups() async {
    try {
      final response = await dio.get(_groupListUrl);
      if (response.statusCode == 200) {
        if (response.data.isNotEmpty) {
          MyGroupList myGroupList = response.data.map<MyGroupModel>((json) {
            MyGroupModel.fromJson(json);
          }).toList();
          return myGroupList;
        }
        return [];
      }
      throw Error();
    } catch (error) {
      throw Error();
    }
  }

  static void logout() {}

  // static Future<MyGroupList> getMyBingos() async {
  //   try {
  //     final response = await dio.get(groupListUrl);
  //     if (response.statusCode == 200) {
  //       MyGroupList myGroupList = response.data.map<MyGroupModel>((json) {
  //         MyGroupModel.fromJson(json);
  //       }).toList();
  //       return myGroupList;
  //     }
  //     throw Error();
  //   } catch (error) {
  //     throw Error();
  //   }
  // }
}
