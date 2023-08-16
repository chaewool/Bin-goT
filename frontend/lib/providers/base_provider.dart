import 'package:bin_got/providers/root_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

//* dio
class DioClass extends AuthProvider {
  static final _baseUrl = dotenv.env['baseUrl'];
  static const _refreshUrl = '/accounts/token/refresh/';
  //* dio
  final dio = Dio(BaseOptions(baseUrl: _baseUrl!));

  //* verify token
  Dio dioForVerify() {
    print('verify Token => $token');
    final dioWithAccess = Dio(
      BaseOptions(
        baseUrl: _baseUrl!,
        headers: {'Authorization': 'JWT $token'},
      ),
    );
    dioWithAccess.interceptors.add(
      InterceptorsWrapper(
        onError: (e, handler) async {
          print('----------');
          print('error message : $e ${e.response?.data}');
          print('token => $token');
          //* access token 만료 (401 오류)
          print('verify token ---------');
          try {
            if (e.response?.statusCode == 401) {
              print('access => 401 Error => 갱신 시도');
              //* access, refresh 갱신
              dio.post(_refreshUrl, data: {'token': refresh}).then(
                  (tokenData) async {
                // print('tokenData => $tokenData');
                final access = tokenData.data['access_token'];
                final refresh = tokenData.data['refresh_token'];
                print('accessToken => $access');
                setStoreToken(access);
                setStoreRefresh(refresh);
                return handler.resolve(tokenData);
              }).catchError((error) {
                print('Error : $error');
                deleteVar();
                return handler.next(error);
              });
            } else {
              print('not 401 error => $e');
              return handler.next(e);
            }
          } catch (error) {
            print('not try : $error');
            deleteVar();
          }
        },
      ),
    );
    return dioWithAccess;
  }

  //* with access token
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
            print('----------');
            print('error message : $e ${e.response?.data}');
            print('token => $token');
            if (e.response?.statusCode == 401) {
              print('access => 401 Error => 갱신 시도');
              //* refresh token
              dio.post(_refreshUrl, data: {'token': refresh}).then(
                  (tokenData) async {
                print('tokenData: $tokenData');
                final access = tokenData.data['access_token'];
                final refresh = tokenData.data['refresh_token'];
                print('accessToken => $access');
                setStoreToken(access);
                setStoreRefresh(refresh);
                e.requestOptions.headers['Authorization'] = 'JWT $access';
                final secondRes = await dio.fetch(e.requestOptions);
                // print('secondRes : $secondRes');
                return handler.resolve(secondRes);
              }).catchError((error) {
                print('Error : $error');
                deleteVar();
                return handler.next(error);
              });
              //* 재요청
            } else {
              print('not 401 error => $e');
              return handler.next(e);
            }
          } catch (error) {
            print('not try : $error');
            deleteVar();
          }
        },
      ),
    );
    return dioWithAccess;
  }

  //* content type == form data
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
          print('----------');
          print('error message : $e ${e.response!.data}');
          print('token => $token');
          if (e.response?.statusCode == 401) {
            print('access => 401 Error => 갱신 시도');
            try {
              //* refresh token
              tempDio.post(
                _refreshUrl,
                data: {'refresh': refresh},
              ).then((tokenData) async {
                // print('tokenData: $tokenData');
                final access = tokenData.data['access'];
                setStoreToken(access);
                e.requestOptions.headers['Authorization'] = 'JWT $access';
                final secondRes = await dio.fetch(e.requestOptions);
                // print('secondRes : $secondRes');
                return handler.resolve(secondRes);
              }).catchError((error) {
                print('Error : $error');
                deleteVar();
                // handler.next(error);
                return handler.next(error);
              });
              //* 재요청
            } catch (error) {
              print('not try : $error');
              deleteVar();
            }
          } else {
            print('not 401 error => $e');
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
  static const _notiUrl = '$_accountUrl/notification/update/';
  static const _profileUrl = '$_accountUrl/profile/';

  //* login
  static const _serviceTokenUrl = '$_kakaoUrl/native/';
  static const _exitServiceUrl = '$_kakaoUrl/unlink/';

  //* token
  static const _verifyTokenUrl = '$_tokenUrl/verify/';
  static const _refreshTokenUrl = '$_tokenUrl/refresh/';

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
  final _createBingoUrl = '$_bingoUrl/create/';
  String _bingoDetailUrl(int bingoId) => '$_bingoUrl/$bingoId/';
  String _editBingoUrl(int groupId) => '${_bingoDetailUrl(groupId)}update/';
  String _deleteBingoUrl(int groupId) => '${_bingoDetailUrl(groupId)}delete/';

  //! getter

  //* user
  String get serviceTokenUrl => _serviceTokenUrl;
  String get exitServiceUrl => _exitServiceUrl;
  String get verifyTokenUrl => _verifyTokenUrl;
  String get refreshTokenUrl => _refreshTokenUrl;

  //* group
  String get searchGroupUrl => _searchGroupUrl;
  String get createGroupUrl => _createGroupUrl;
  String groupDetailUrl(int groupId) => _groupDetailUrl(groupId);
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
  String get createBingoUrl => _createBingoUrl;
  String bingoDetailUrl(int bingoId) => _bingoDetailUrl(bingoId);
  String editBingoUrl(int bingoId) => _editBingoUrl(bingoId);
  String deleteBingoUrl(int bingoId) => _deleteBingoUrl(bingoId);

  //* username
  String get checkNameUrl => _checkNameUrl;
  String get changeNameUrl => _changeNameUrl;

  //* main
  String get mainGroupTabUrl => _mainGroupTabUrl;
  String get mainBingoTabUrl => _mainBingoTabUrl;

  //* my page
  String get badgeListUrl => _badgeListUrl;
  String get changeBadgeUrl => _changeBadgeUrl;
  String get notiUrl => _notiUrl;
  String get profileUrl => _profileUrl;
  String get notificationsUrl => _notificationsUrl;

  //* fcm
  String get saveFCMTokentUrl => _saveFCMTokentUrl;
}
