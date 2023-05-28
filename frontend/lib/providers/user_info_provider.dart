import 'package:bin_got/models/user_info_model.dart';
import 'package:bin_got/providers/api_provider.dart';
import 'package:bin_got/utilities/type_def_utils.dart';

class UserInfoProvider extends ApiProvider {
  //* public
  Future<ProfileModel> getProfile() => _getProfile();
  Future<BadgeList> getBadges() => _getBadges();
  void checkName(String name) => _checkName(name);
  void changeName(String name) => _changeName(name);
  Future<MainTabModel> getMainTabData() => _getMainTabData();

  //* private
  Future<ProfileModel> _getProfile() async {
    final response = await dioWithToken().get(profileUrl);
    ProfileModel profile = ProfileModel.fromJson(response.data);
    return profile;
  }

  Future<BadgeList> _getBadges() async {
    try {
      final response = await dioWithToken().get(badgeListUrl);
      BadgeList badgeList = response.data
          .map<BadgeModel>((json) => BadgeModel.fromJson(json))
          .toList();
      return badgeList;
    } catch (error) {
      throw Error();
    }
  }

  void _checkName(String name) async {
    try {
      createApi(checkNameUrl, data: {'username': name});
    } catch (error) {
      throw Error();
    }
  }

  void _changeName(String name) async {
    try {
      createApi(changeNameUrl, data: {'username': name});
    } catch (error) {
      throw Error();
    }
  }

  Future<MainTabModel> _getMainTabData() async {
    try {
      final response = await dioWithToken().get(mainTabUrl);
      switch (response.statusCode) {
        case 200:
          final data = response.data;
          if (data.isNotEmpty) {
            print('tabData : $data');
            MyGroupList myGroupList = data['groups']
                .map<MyGroupModel>((json) => MyGroupModel.fromJson(json))
                .toList();
            MyBingoList myBingoList = data['boards']
                .map<MyBingoModel>((json) => MyBingoModel.fromJson(json))
                .toList();
            bool hasNotGroup = data['is_recommend'];
            return MainTabModel.fromJson({
              'groups': myGroupList,
              'boards': myBingoList,
              'is_recommend': hasNotGroup
            });
          }
          return MainTabModel.fromJson(
              {'groups': [], 'boards': [], 'is_recommend': true});
        case 401:
          await tokenRefresh();
          return _getMainTabData();
        default:
          throw Error();
      }
    } catch (error) {
      print('mainTabError: $error');
      // UserProvider.logout();
      throw Error();
    }
  }
}
