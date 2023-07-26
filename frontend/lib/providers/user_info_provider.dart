import 'package:bin_got/models/user_info_model.dart';
import 'package:bin_got/providers/api_provider.dart';
import 'package:bin_got/providers/root_provider.dart';
import 'package:bin_got/utilities/type_def_utils.dart';

class UserInfoProvider extends ApiProvider {
  //* public
  FutureBool changeBadge(DynamicMap data) => _changeBadge(data);
  Future<ProfilModel> getProfile() => _getProfile();
  FutureDynamic getBadges() => _getBadges();
  FutureDynamic checkName(String name) => _checkName(name);
  FutureDynamic changeName(String name) => _changeName(name);
  Future<MainGroupListModel> getMainGroupData(DynamicMap queryParameters) =>
      _getMainGroupData(queryParameters);
  Future<MyBingoList> getMainBingoData(DynamicMap queryParameters) =>
      _getMainBingoData(queryParameters);
  FutureDynamic changeNoti(DynamicMap data) => _changeNoti(data);

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

  Future<ProfilModel> _getProfile() async {
    try {
      final response = await dioWithToken().get(profileUrl);
      print(response.data);
      ProfilModel profile = ProfilModel.fromJson(response.data);
      return profile;
    } catch (error) {
      throw Error();
    }
  }

  FutureDynamic _getBadges() async {
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

  FutureDynamic _changeNoti(DynamicMap data) => updateApi(notiUrl, data: data);

  FutureDynamic _checkName(String name) =>
      createApi(checkNameUrl, data: {'username': name});

  FutureDynamic _changeName(String name) =>
      createApi(changeNameUrl, data: {'username': name});

  Future<MainGroupListModel> _getMainGroupData(
      DynamicMap queryParameters) async {
    try {
      print('url : $mainGroupTabUrl, query : $queryParameters');
      final response = await dioWithToken()
          .get(mainGroupTabUrl, queryParameters: queryParameters);

      final data = response.data;
      print('data : $data');
      // if (data.isNotEmpty) {
      MyGroupList myGroupList = data['groups']
          .map<MyGroupModel>((json) => MyGroupModel.fromJson(json))
          .toList();
      bool hasNotGroup = data['is_recommend'];
      // GlobalGroupProvider().setTotalPage(data['last_page']);
      GlobalGroupProvider().setLastId(data['last_idx']);
      return MainGroupListModel.fromJson(
          {'groups': myGroupList, 'is_recommend': hasNotGroup});
      // }
      // GlobalGroupProvider().setLastId(data['last_idx']);
      // return MainGroupListModel.fromJson({'groups': [], 'is_recommend': true});
    } catch (error) {
      print('mainTabGroupError: $error');
      throw Error();
    }
  }

  Future<MyBingoList> _getMainBingoData(DynamicMap queryParameters) async {
    try {
      print('in!!');
      final response = await dioWithToken()
          .get(mainBingoTabUrl, queryParameters: queryParameters);
      print(response);
      final data = response.data['boards'];
      // GlobalBingoProvider().setTotalPage(response.data['last_page']);
      GlobalBingoProvider().setLastId(response.data['last_idx']);
      print('data : $data');
      // if (data.isNotEmpty) {
      MyBingoList myBingoList = data
          .map<MyBingoModel>((json) => MyBingoModel.fromJson(json))
          .toList();
      return myBingoList;
      // }
      // return [];
    } catch (error) {
      print('mainTabBingoError: $error');
      // UserProvider.logout();
      throw Error();
    }
  }
}
