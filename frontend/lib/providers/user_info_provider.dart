import 'package:bin_got/models/user_info_model.dart';
import 'package:bin_got/providers/api_provider.dart';
import 'package:bin_got/providers/user_provider.dart';
import 'package:bin_got/utilities/type_def_utils.dart';
import 'package:dio/dio.dart';

class UserInfoProvider {
  //* basic
  static const _accountUrl = '/accounts';
  static const _usernameUrl = '$_accountUrl/username';
  static const _profileUrl = '$_accountUrl/profile';
  static const _badgeUrl = '$_accountUrl/badge';

  //* username
  static const _checkNameUrl = '$_usernameUrl/check/';
  static const _changeNameUrl = '$_usernameUrl/update/';

  //* main
  static const _mainTabUrl = '$_accountUrl/main/';

  //* badge
  static const _badgeListUrl = '$_badgeUrl/list/';
  static const _changeBadgeUrl = '$_badgeUrl/update/';

  //* notification
  static const _notiUrl = '$_accountUrl/notification/update/';

  //* public
  static void checkName(String name) async => _checkName(name);
  static void changeName(String name) async => _changeName(name);
  static Future<MainTabModel> getMainTabData() async => _getMainTabData();

  //* private
  static void _checkName(String name) async {
    try {
      ApiProvider.createApi(_checkNameUrl, data: {'username': name});
    } catch (error) {
      throw Error();
    }
  }

  static void _changeName(String name) async {
    try {
      ApiProvider.createApi(_changeNameUrl, data: {'username': name});
    } catch (error) {
      throw Error();
    }
  }

  static Future<MainTabModel> _getMainTabData() async {
    try {
      final token = await UserProvider.token();
      BaseOptions options = BaseOptions(
        baseUrl: baseUrl!,
        headers: {'Authorization': 'JWT $token'},
      );
      final dioWithToken = Dio(options);
      final response = await dioWithToken.get(_mainTabUrl);
      switch (response.statusCode) {
        case 200:
          final data = response.data;
          if (data.isNotEmpty) {
            MyGroupList myGroupList = data.groups
                .map<MyGroupModel>((json) => MyGroupModel.fromJson(json));
            MyBingoList myBingoList = data.boards
                .map<MyGroupModel>((json) => MyGroupModel.fromJson(json));
            return MainTabModel.fromJson(
                {'groups': myGroupList, 'boards': myBingoList});
          }
          return MainTabModel.fromJson({'groups': [], 'boards': []});
        case 401:
          UserProvider.tokenRefresh();
          return MainTabModel.fromJson({'groups': [], 'boards': []});
        default:
          throw Error();
      }
    } catch (error) {
      print(error);
      throw Error();
    }
  }
}
