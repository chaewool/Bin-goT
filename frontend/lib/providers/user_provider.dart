import 'package:bin_got/models/user_model.dart';
import 'package:bin_got/providers/api_provider.dart';
import 'package:bin_got/utilities/type_def_utils.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

//* user
class UserProvider extends ApiProvider {
  //* public function
  FutureBool login() async => _login();
  FutureVoid logout() async => _logout();

  FutureVoid confirmToken(String token) async => _confirmToken(token);
  FutureVoid exitService(String token) async => _exitService();

  //* private function
  //* login
  FutureBool _login() async {
    //* 카카오톡 설치 여부 확인
    if (await isKakaoTalkInstalled()) {
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
    }
    //* 카카오톡에 연결된 카카오계정이 없는 경우, 카카오계정으로 로그인
    try {
      _kakaoLogin(false);
      return true;
    } catch (error) {
      throw Error();
    }
  }

  //* verify token
  void _confirmToken(String token) async {
    try {
      print('토큰 유효성 검사');
      final data = await createApi(verifyTokenUrl, data: {'token': token});
      if (data.isNotEmpty) {
        tokenRefresh();
      }
    } catch (error) {
      tokenRefresh();
    }
  }

  //* logout
  void _logout() {
    try {
      const storage2 = FlutterSecureStorage();
      storage2.deleteAll();
    } catch (error) {
      throw Error();
    }
  }

  //* exit
  void _exitService() {
    try {
      deleteApi(exitServiceUrl);
    } catch (error) {
      throw Error();
    }
  }

  //* kakao login
  void _kakaoLogin(bool isKakaoTalkLogin) async {
    try {
      if (isKakaoTalkLogin) {
        await UserApi.instance.loginWithKakaoTalk();
      } else {
        await UserApi.instance.loginWithKakaoAccount();
      }
      User user = await UserApi.instance.me();
      final json = await createApi(
        serviceTokenUrl,
        data: {'kakao_id': user.id},
      );
      final data = ServiceTokenModel.fromJson(json);
      dio.options.headers['Authorization'] = 'JWT ${data.accessToken}';
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
}
