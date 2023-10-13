import 'package:bin_got/providers/root_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

//* api 요청, 토큰 갱신
class DioClass extends AuthProvider {
  static final _baseUrl = dotenv.env['baseUrl'];
  static const _refreshUrl = '/accounts/token/refresh/';
  //* dio
  final dio = Dio(BaseOptions(baseUrl: _baseUrl!));

  //* 토큰 유효성 검사
  Dio dioForVerify() {
    final dioWithAccess = Dio(
      BaseOptions(
        baseUrl: _baseUrl!,
        headers: {'Authorization': 'JWT $token'},
      ),
    );
    dioWithAccess.interceptors.add(
      InterceptorsWrapper(
        onError: (e, handler) async {
          //* access token 기한 만료 (401 오류)
          try {
            if (e.response?.statusCode == 401) {
              //* access, refresh 갱신
              dio.post(_refreshUrl, data: {'token': refresh}).then(
                  (tokenData) async {
                final access = tokenData.data['access_token'];
                final refresh = tokenData.data['refresh_token'];
                setStoreToken(access);
                setStoreRefresh(refresh);
                return handler.resolve(tokenData);
              }).catchError((error) {
                //* refresh token 기한 만료 시, 토큰 삭제
                deleteVar();
                return handler.next(error);
              });
            } else {
              //* 401 오류가 아닐 경우
              return handler.next(e);
            }
          } catch (error) {
            //* 오류 발생 시, 토큰 삭제
            deleteVar();
          }
        },
      ),
    );
    return dioWithAccess;
  }

  //* 토큰 포함 요청
  Dio dioWithToken() {
    final dioWithAccess = Dio(
      BaseOptions(
        baseUrl: _baseUrl!,
        headers: {'Authorization': 'JWT $token'},
      ),
    );
    dioWithAccess.interceptors.add(
      InterceptorsWrapper(
        onError: (e, handler) async {
          try {
            if (e.response?.statusCode == 401) {
              dio.post(_refreshUrl, data: {'token': refresh}).then(
                  (tokenData) async {
                //* access, refresh token 갱신
                final access = tokenData.data['access_token'];
                final refresh = tokenData.data['refresh_token'];
                setStoreToken(access);
                setStoreRefresh(refresh);
                //* 재요청
                e.requestOptions.headers['Authorization'] = 'JWT $access';
                final secondRes = await dio.fetch(e.requestOptions);
                return handler.resolve(secondRes);
              }).catchError((error) {
                deleteVar();
                return handler.next(error);
              });
            } else {
              return handler.next(e);
            }
          } catch (error) {
            deleteVar();
          }
        },
      ),
    );
    return dioWithAccess;
  }

  //* form data 포함한 요청
  Dio dioWithTokenForm() {
    final dioWithForm = Dio(
      BaseOptions(
        baseUrl: _baseUrl!,
        headers: {'Authorization': 'JWT $token'},
        contentType: 'multipart/form-data',
      ),
    );
    final tempDio = Dio(
      BaseOptions(
        baseUrl: _baseUrl!,
        headers: {'Authorization': 'JWT $token'},
      ),
    );
    dioWithForm.interceptors.add(
      InterceptorsWrapper(
        onError: (e, handler) async {
          if (e.response?.statusCode == 401) {
            try {
              //* refresh token
              tempDio.post(
                _refreshUrl,
                data: {'refresh': refresh},
              ).then((tokenData) async {
                //* access, refresh token 갱신
                final access = tokenData.data['access_token'];
                final refresh = tokenData.data['refresh_token'];
                setStoreToken(access);
                setStoreRefresh(refresh);
                e.requestOptions.headers['Authorization'] = 'JWT $access';
                //* 재요청
                final secondRes = await dio.fetch(e.requestOptions);
                return handler.resolve(secondRes);
              }).catchError((error) {
                deleteVar();
                return handler.next(error);
              });
            } catch (error) {
              deleteVar();
            }
          } else {
            return handler.next(e);
          }
        },
      ),
    );
    return dioWithForm;
  }
}

//* url
class UrlClass extends DioClass {
  //! account
  static const _accountUrl = '/accounts';
  static const _tokenUrl = '$_accountUrl/token';
  static const _kakaoUrl = '$_accountUrl/kakao';
  static const _usernameUrl = '$_accountUrl/username';
  static const _badgeUrl = '$_accountUrl/badge';

  //* main
  static const _mainGroupTabUrl = '$_accountUrl/main/groups';
  static const _mainBingoTabUrl = '$_accountUrl/main/boards';

  //* username
  static const _checkNameUrl = '$_usernameUrl/check/';
  static const _changeNameUrl = '$_usernameUrl/update/';

  //* my page
  static const _badgeListUrl = '$_badgeUrl/list/';
  static const _changeBadgeUrl = '$_badgeUrl/update/';
  static const _notificationsUrl = '$_accountUrl/notification/detail';
  static const _changenotiUrl = '$_accountUrl/notification/update/';
  static const _profileUrl = '$_accountUrl/profile/';

  //* login
  static const _serviceTokenUrl = '$_kakaoUrl/native/';
  static const _exitServiceUrl = '$_kakaoUrl/unlink/';

  //* token
  static const _verifyTokenUrl = '$_tokenUrl/verify/';

  //* fcm
  static const _saveFCMTokentUrl = '$_tokenUrl/fcm/';

  //! group
  static const _groupUrl = '/groups';

  //* search
  final String _searchGroupUrl = '$_groupUrl/search';

  //* CRUD
  final _createGroupUrl = '$_groupUrl/create/';
  String _groupDetailUrl(int groupId) => '$_groupUrl/$groupId/';
  String _editGroupUrl(int groupId) => '${_groupDetailUrl(groupId)}update/';
  String _deleteGroupUrl(int groupId) => '${_groupDetailUrl(groupId)}delete/';

  //* check password
  String _checkPasswordUrl(int groupId) => '${_groupDetailUrl(groupId)}/check/';

  //* member
  String _joinGroupUrl(int groupId) => '${_groupDetailUrl(groupId)}join/';
  String _grantMemberUrl(int groupId) => '${_groupDetailUrl(groupId)}grant/';
  String _exitGroupUrl(int groupId) => '${_groupDetailUrl(groupId)}resign/';
  String _groupRankUrl(int groupId) => '${_groupDetailUrl(groupId)}rank/';
  String _getMembersUrl(int groupId) => '${_groupDetailUrl(groupId)}admin/';

  //* chat & review
  String _groupChatListUrl(int groupId) =>
      '${_groupDetailUrl(groupId)}chat/list/';
  String _groupChatCreateUrl(int groupId) =>
      '${_groupDetailUrl(groupId)}chat/create/';
  String _groupReviewCreateUrl(int groupId) =>
      '${_groupDetailUrl(groupId)}review/create/';
  String _groupReviewCheckUrl(int groupId) =>
      '${_groupDetailUrl(groupId)}review/check/';

  //! bingo
  static const _bingoUrl = '/boards';
  //* CRUD
  String _bingoDetailUrl(int groupId, int bingoId) =>
      '${_groupDetailUrl(groupId)}$_bingoUrl/$bingoId/';
  String _editBingoUrl(int groupId, int bingoId) =>
      '${_bingoDetailUrl(groupId, bingoId)}update/';

  //! getter

  //* user
  String get serviceTokenUrl => _serviceTokenUrl;
  String get exitServiceUrl => _exitServiceUrl;
  String get verifyTokenUrl => _verifyTokenUrl;

  //* group
  String get searchGroupUrl => _searchGroupUrl;
  String get createGroupUrl => _createGroupUrl;
  String groupDetailUrl(int groupId) => _groupDetailUrl(groupId);
  String checkPasswordUrl(int groupId) => _checkPasswordUrl(groupId);
  String joinGroupUrl(int groupId) => _joinGroupUrl(groupId);
  String grantMemberUrl(int groupId) => _grantMemberUrl(groupId);
  String editGroupUrl(int groupId) => _editGroupUrl(groupId);
  String deleteGroupUrl(int groupId) => _deleteGroupUrl(groupId);
  String exitGroupUrl(int groupId) => _exitGroupUrl(groupId);
  String groupRankUrl(int groupId) => _groupRankUrl(groupId);
  String getMembersUrl(int groupId) => _getMembersUrl(groupId);
  String groupChatListUrl(int groupId) => _groupChatListUrl(groupId);
  String groupChatCreateUrl(int groupId) => _groupChatCreateUrl(groupId);
  String groupReviewCreateUrl(int groupId) => _groupReviewCreateUrl(groupId);
  String groupReviewCheckUrl(int groupId) => _groupReviewCheckUrl(groupId);

  //* bingo
  String bingoDetailUrl(int groupId, int bingoId) =>
      _bingoDetailUrl(groupId, bingoId);
  String editBingoUrl(int groupId, int bingoId) =>
      _editBingoUrl(groupId, bingoId);

  //* username
  String get checkNameUrl => _checkNameUrl;
  String get changeNameUrl => _changeNameUrl;

  //* main
  String get mainGroupTabUrl => _mainGroupTabUrl;
  String get mainBingoTabUrl => _mainBingoTabUrl;

  //* my page
  String get badgeListUrl => _badgeListUrl;
  String get changeBadgeUrl => _changeBadgeUrl;
  String get changenotiUrl => _changenotiUrl;
  String get profileUrl => _profileUrl;
  String get notificationsUrl => _notificationsUrl;

  //* fcm
  String get saveFCMTokentUrl => _saveFCMTokentUrl;
}
