import 'package:bin_got/models/user_info_model.dart';
import 'package:bin_got/providers/api_provider.dart';
import 'package:bin_got/providers/root_provider.dart';
import 'package:bin_got/utilities/type_def_utils.dart';

class UserInfoProvider extends ApiProvider {
  //* public
  FutureBool changeBadge(DynamicMap data) => _changeBadge(data);
  Future<ProfilModel> getProfile() => _getProfile();
  Future<BadgeList> getBadges() => _getBadges();
  FutureBool checkName(String name) => _checkName(name);
  FutureBool changeName(String name) => _changeName(name);
  Future<MainGroupListModel> getMainGroupData(DynamicMap queryParameters) =>
      _getMainGroupData(queryParameters);
  Future<MyBingoList> getMainBingoData(DynamicMap queryParameters) =>
      _getMainBingoData(queryParameters);
  FutureBool changeNoti(DynamicMap data) => _changeNoti(data);

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
      print(error);
      throw Error();
    }
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

  FutureBool _changeNoti(DynamicMap data) async {
    print('noti url : $notiUrl, data : $data');
    await updateApi(notiUrl, data: data);
    return Future.value(true);
  }

  FutureBool _checkName(String name) async {
    try {
      print('$checkNameUrl => $name');
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

  Future<MainGroupListModel> _getMainGroupData(
      DynamicMap queryParameters) async {
    try {
      print('url : $mainGroupTabUrl, query : $queryParameters');
      final response = await dioWithToken()
          .get(mainGroupTabUrl, queryParameters: queryParameters);
      if (response.statusCode == 200) {
        final data = response.data;
        print('data : $data');
        if (data.isNotEmpty) {
          MyGroupList myGroupList = data['groups']
              .map<MyGroupModel>((json) => MyGroupModel.fromJson(json))
              .toList();
          bool hasNotGroup = data['is_recommend'];
          GlobalBingoProvider().setTotalPage(data['last_page']);
          return MainGroupListModel.fromJson(
              {'groups': myGroupList, 'is_recommend': hasNotGroup});
        }
        return MainGroupListModel.fromJson(
            {'groups': [], 'is_recommend': true});
      } else if (response.statusCode == 401) {
        print('여기서 401 오류 처리 할 거야');
      }
      throw Error();
    } catch (error) {
      print('mainTabGroupError: $error');
      // UserProvider.logout();
      throw Error();
    }
  }

  Future<MyBingoList> _getMainBingoData(DynamicMap queryParameters) async {
    try {
      print('in!!');
      final response = await dioWithToken()
          .get(mainBingoTabUrl, queryParameters: queryParameters);
      print(response);
      if (response.statusCode == 200) {
        final data = response.data['boards'];
        GlobalBingoProvider().setTotalPage(response.data['last_page']);
        print('data : $data');
        if (data.isNotEmpty) {
          MyBingoList myBingoList = data
              .map<MyBingoModel>((json) => MyBingoModel.fromJson(json))
              .toList();
          return myBingoList;
        }
        return [];
      }
      throw Error();
    } catch (error) {
      print('mainTabBingoError: $error');
      // UserProvider.logout();
      throw Error();
    }
  }
}
