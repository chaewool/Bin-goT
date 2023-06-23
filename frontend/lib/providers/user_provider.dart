import 'package:bin_got/providers/api_provider.dart';
import 'package:bin_got/utilities/type_def_utils.dart';
import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

//* user
class UserProvider extends ApiProvider {
  //* public function
  FutureDynamicMap login() async => _login();
  FutureDynamicMap confirmToken() => _confirmToken();
  FutureDynamicMap exitService() => _exitService();

  //* private function
  //* login
  FutureDynamicMap _login() async {
    //* 카카오톡 설치 여부 확인
    print('in');
    if (await isKakaoTalkInstalled()) {
      print('installed');
      try {
        return _kakaoLogin(true);
      } catch (error) {
        try {
          return _kakaoLogin(false);
        } catch (error) {
          throw Error();
        }
      }
    }
    //* 카카오톡에 연결된 카카오계정이 없는 경우, 카카오계정으로 로그인
    try {
      return _kakaoLogin(false);
    } catch (error) {
      throw Error();
    }
  }

  //* verify token
  FutureDynamicMap _confirmToken() async {
    try {
      if (token == null || token == '') return {};
      print('토큰 유효성 검사');
      final data = await createApi(verifyTokenUrl, data: {'token': token});
      return {'token': token};
    } catch (error) {
      throw Error();
    }
  }

  //* exit
  FutureDynamicMap _exitService() async {
    try {
      await deleteApi(exitServiceUrl);
      return {};
    } catch (error) {
      throw Error();
    }
  }

  //* kakao login
  FutureDynamicMap _kakaoLogin(bool isKakaoTalkLogin) async {
    try {
      if (isKakaoTalkLogin) {
        await UserApi.instance.loginWithKakaoTalk();
      } else {
        await UserApi.instance.loginWithKakaoAccount();
      }
      User user = await UserApi.instance.me();
      final json = await dio.post(
        serviceTokenUrl,
        data: {'kakao_id': user.id},
      );
      // final data = ServiceTokenModel.fromJson(json);
      return json.data;
    } catch (error) {
      // 사용자가 카카오톡 설치 후 디바이스 권한 요청 화면에서 로그인을 취소한 경우,
      // 의도적인 로그인 취소로 보고 카카오계정으로 로그인 시도 없이 로그인 취소로 처리 (예: 뒤로 가기)
      if (error is PlatformException && error.code == 'CANCELED') {
        return {};
      }
      print('kakao login: $error');
      throw Error();
    }
  }
}
