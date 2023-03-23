import 'package:bin_got/models/user_model.dart';
import 'package:bin_got/providers/api_provider.dart';
import 'package:bin_got/utilities/type_def_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

const verifyTokenUrl = '$tokenUrl/verify/';
const takeTokenUrl = '$tokenUrl/';
const refreshTokenUrl = '$tokenUrl/refresh/';

const checkNameUrl = '$usernameUrl/check/';
const changeNameUrl = '$usernameUrl/update/';

const groupListUrl = '$profileUrl/groups/';

const badgeListUrl = '$badgeUrl/list/';
const changeBadgeUrl = '$badgeUrl/update/';

const notiUrl = '$accountUrl/notification/update/';

const exitService = '$kakaoUrl/unlink/';

class UserProvider {
  static void login(BuildContext context) async {
    try {
      final kakaoToken = await UserApi.instance.loginWithKakaoAccount();
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

  static Future<MyGroupList> getMyGroups() async {
    try {
      final response = await dio.get(groupListUrl);
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
