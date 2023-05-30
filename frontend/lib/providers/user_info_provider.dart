import 'package:bin_got/models/user_info_model.dart';
import 'package:bin_got/providers/api_provider.dart';
import 'package:bin_got/utilities/type_def_utils.dart';

class UserInfoProvider extends ApiProvider {
  //* public
  FutureBool changeBadge(DynamicMap data) => _changeBadge(data);
  Future<ProfileModel> getProfile() => _getProfile();
  Future<BadgeList> getBadges() => _getBadges();
  FutureBool checkName(String name) => _checkName(name);
  FutureBool changeName(String name) => _changeName(name);
  Future<MainTabModel> getMainTabData() => _getMainTabData();

  //* private
  FutureBool _changeBadge(DynamicMap data) async {
    try {
      await updateApi(changeBadgeUrl, data: data);
      return true;
    } catch (error) {
      print(error);
      throw Error();
    }
  }

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

  FutureBool _checkName(String name) async {
    try {
      await createApi(checkNameUrl, data: {'username': name});
      return true;
    } catch (error) {
      throw Error();
    }
  }

  FutureBool _changeName(String name) async {
    try {
      await createApi(changeNameUrl, data: {'username': name});
      return true;
    } catch (error) {
      throw Error();
    }
  }

  Future<MainTabModel> _getMainTabData() async {
    try {
      final response = await dioWithToken().get(mainTabUrl);
      if (response.statusCode == 200) {
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
      }
      throw Error();
    } catch (error) {
      print('mainTabError: $error');
      // UserProvider.logout();
      throw Error();
    }
  }
}
