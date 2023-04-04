import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

//* dio
class DioClass {
  static final _baseUrl = dotenv.env['baseUrl'];
  Dio dio = Dio(BaseOptions(baseUrl: _baseUrl!));
  Dio dioWithToken(String token) => Dio(
        BaseOptions(
          baseUrl: _baseUrl!,
          headers: {'Authorization': 'JWT $token'},
        ),
      );
}

//* url
class UrlClass {
  //! account
  static const _accountUrl = '/accounts';
  static const _tokenUrl = '$_accountUrl/token';
  static const _kakaoUrl = '$_accountUrl/kakao';
  static const _usernameUrl = '$_accountUrl/username';
  static const _badgeUrl = '$_accountUrl/badge';

  //* main
  static const _mainTabUrl = '$_accountUrl/main/';

  //* username
  static const _checkNameUrl = '$_usernameUrl/check/';
  static const _changeNameUrl = '$_usernameUrl/update/';

  //* my page
  static const _badgeListUrl = '$_badgeUrl/list/';
  static const _changeBadgeUrl = '$_badgeUrl/update/';
  static const _notiUrl = '$_accountUrl/notification/update/';
  static const _profileUrl = '$_accountUrl/profile/';

  //* login
  static const _serviceTokenUrl = '$_kakaoUrl/native/';
  static const _exitServiceUrl = '$_kakaoUrl/unlink/';

  //* token
  static const _verifyTokenUrl = '$_tokenUrl/verify/';
  static const _refreshTokenUrl = '$_tokenUrl/refresh/';

  //! group
  static const _groupUrl = '/groups';

  //* search
  String _searchGroupUrl({
    int? period,
    String? keyword,
    int? align,
    int? filter,
    required int startIndex,
    required int cnt,
    required int page,
  }) =>
      '$_groupUrl/search?period=$period&keyword=$keyword&align=$align&filter=$filter&start_index=$startIndex&cnt=$cnt&page=$page';

  //* CRUD
  final _createGroupUrl = '$_groupUrl/create/';
  String _groupDetailUrl(int groupId) => '$_groupUrl/$groupId/';
  String _editGroupUrl(int groupId) => '${_groupDetailUrl(groupId)}/update/';
  String _deleteGroupUrl(int groupId) => '${_groupDetailUrl(groupId)}/delete/';

  //* member
  String _joinGroupUrl(int groupId) => '${_groupDetailUrl(groupId)}/join/';
  String _grantMemberUrl(int groupId) => '${_groupDetailUrl(groupId)}/grant/';
  String _exitGroupUrl(int groupId) => '${_groupDetailUrl(groupId)}/resign/';
  String _groupRankUrl(int groupId) => '${_groupDetailUrl(groupId)}/rank/';

  //! getter

  //* user
  String get serviceTokenUrl => _serviceTokenUrl;
  String get exitServiceUrl => _exitServiceUrl;
  String get verifyTokenUrl => _verifyTokenUrl;
  String get refreshTokenUrl => _refreshTokenUrl;

  //* group
  String searchGroupUrl({
    int? period,
    String? keyword,
    int? align,
    int? filter,
    required int startIndex,
    required int cnt,
    required int page,
  }) =>
      _searchGroupUrl(
        period: period,
        keyword: keyword,
        align: align,
        filter: filter,
        startIndex: startIndex,
        cnt: cnt,
        page: page,
      );
  String get createGroupUrl => _createGroupUrl;
  String groupDetailUrl(int groupId) => _groupDetailUrl(groupId);
  String joinGroupUrl(int groupId) => _joinGroupUrl(groupId);
  String grantMemberUrl(int groupId) => _grantMemberUrl(groupId);
  String editGroupUrl(int groupId) => _editGroupUrl(groupId);
  String deleteGroupUrl(int groupId) => _deleteGroupUrl(groupId);
  String exitGroupUrl(int groupId) => _exitGroupUrl(groupId);
  String groupRankUrl(int groupId) => _groupRankUrl(groupId);

  //* username
  String get checkNameUrl => _checkNameUrl;
  String get changeNameUrl => _changeNameUrl;

  //* main
  String get mainTabUrl => _mainTabUrl;

  //* my page
  String get badgeListUrl => _badgeListUrl;
  String get changeBadgeUrl => _changeBadgeUrl;
  String get notiUrl => _notiUrl;
  String get profileUrl => _profileUrl;
}
