import 'package:bin_got/models/user_info_model.dart';
import 'package:bin_got/providers/api_provider.dart';
import 'package:bin_got/utilities/type_def_utils.dart';

class UserInfoProvider {
  //* basic
  static const _accountUrl = '/accounts';
  static const _usernameUrl = '$_accountUrl/username';
  static const _profileUrl = '$_accountUrl/profile';
  static const _badgeUrl = '$_accountUrl/profile';

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

  static void checkName(String name) async {
    try {
      ApiProvider.createApi(_checkNameUrl, data: {'username': name});
    } catch (error) {
      throw Error();
    }
  }

  static void changeName(String name) async {
    try {
      ApiProvider.createApi(_changeNameUrl, data: {'username': name});
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
