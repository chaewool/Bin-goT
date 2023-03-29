import 'package:bin_got/models/user_model.dart';
import 'package:bin_got/providers/api_provider.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

class UserProvider {
  static const storage = FlutterSecureStorage();
  //* basic
  static const _accountUrl = '/accounts';
  static const _tokenUrl = '$_accountUrl/token';
  static const _kakaoUrl = '$_accountUrl/kakao';

  //* token
  static const _verifyTokenUrl = '$_tokenUrl/verify/';
  static const _refreshTokenUrl = '$_tokenUrl/refresh/';

  //* kakao login
  static const _serviceTokenUrl = '$_kakaoUrl/native/';
  static const _exitServiceUrl = '$_kakaoUrl/unlink/';

  //* set
  static void _setToken(String token) {
    storage.write(key: 'token', value: token);
    storage.write(key: 'isLoggedIn', value: 'true');
  }

  static void _setRefresh(String refresh) =>
      storage.write(key: 'refresh', value: refresh);

  static void _setNoti(bool rank, bool due, bool chat) => storage.write(
        key: 'notification',
        value: {'rank': rank, 'due': due, 'chat': chat}.toString(),
      );
  //* get
  static Future<String?> token() {
    return storage.read(key: 'token');
  }

  static Future<String?> refresh() => storage.read(key: 'refresh');

  static void _setVar(ServiceTokenModel data) async {
    _setToken(data.accessToken);
    _setRefresh(data.refreshToken);
    _setNoti(data.notiRank, data.notiDue, data.notiChat);
  }

  static void _kakaoLogin(bool isKakaoTalkLogin) async {
    try {
      if (isKakaoTalkLogin) {
        await UserApi.instance.loginWithKakaoTalk();
      } else {
        await UserApi.instance.loginWithKakaoAccount();
      }
      User user = await UserApi.instance.me();
      final json = await ApiProvider.createApi(
        _serviceTokenUrl,
        data: {'kakao_id': user.id},
      );
      final data = ServiceTokenModel.fromJson(json);
      dio.options.headers['Authorization'] = 'JWT ${data.accessToken}';
      _setVar(data);
    } catch (error) {
      // 사용자가 카카오톡 설치 후 디바이스 권한 요청 화면에서 로그인을 취소한 경우,
      // 의도적인 로그인 취소로 보고 카카오계정으로 로그인 시도 없이 로그인 취소로 처리 (예: 뒤로 가기)
      if (error is PlatformException && error.code == 'CANCELED') {
        return;
      }
      print(error);
      throw Error();
    }
  }

  static Future<bool> login() async {
    //* 카카오톡 설치 여부 확인
    if (await isKakaoTalkInstalled()) {
      print('카카오톡 설치');
      try {
        _kakaoLogin(true);
        return true;
      } catch (error) {
        try {
          _kakaoLogin(false);
          return true;
        } catch (error) {
          throw Error();
        }
      }
      //* 카카오톡에 연결된 카카오계정이 없는 경우, 카카오계정으로 로그인
    } else {
      try {
        _kakaoLogin(false);
        return true;
      } catch (error) {
        throw Error();
      }
    }
  }

  static void tokenRefresh() async {
    try {
      final data = await ApiProvider.createApi(_refreshTokenUrl,
          data: {'refresh': refresh()});
      _setRefresh(data['refresh_token']);
      _setToken(data['access_token']);
    } catch (error) {
      throw Error();
    }
  }

  static void confirmToken(String token) async {
    try {
      ApiProvider.createApi(_verifyTokenUrl, data: {'token': token});
    } catch (error) {
      try {
        tokenRefresh();
      } catch (error) {
        throw Error();
      }
    }
  }

  static void logout() {
    try {
      storage.deleteAll();
    } catch (error) {
      throw Error();
    }
  }

  static void exitService() {
    try {
      ApiProvider.deleteApi(_exitServiceUrl);
    } catch (error) {
      throw Error();
    }
  }
}
