import 'package:bin_got/models/user_info_model.dart';
import 'package:bin_got/providers/api_provider.dart';
import 'package:bin_got/providers/root_provider.dart';
import 'package:bin_got/utilities/type_def_utils.dart';

//? 사용자 정보, 설정 api
class UserInfoProvider extends ApiProvider {
  //* public
  FutureBool changeBadge(DynamicMap data) => _changeBadge(data);
  Future<ProfilModel> getProfile() => _getProfile();
  Future<BadgeList> getBadges() => _getBadges();
  FutureDynamic checkName(String name) =>
      createApi(checkNameUrl, data: {'username': name});
  FutureDynamic changeName(String name) =>
      createApi(changeNameUrl, data: {'username': name});
  Future<MainGroupListModel> getMainGroupData(DynamicMap queryParameters) =>
      _getMainGroupData(queryParameters);
  Future<MyBingoList> getMainBingoData(DynamicMap queryParameters) =>
      _getMainBingoData(queryParameters);
  FutureDynamic changeNoti(DynamicMap data) =>
      updateApi(changenotiUrl, data: data);

  FutureDynamic getNoti() => _getNoti();

  //* private
  FutureBool _changeBadge(DynamicMap data) async {
    try {
      await updateApi(changeBadgeUrl, data: data);
      return true;
    } catch (error) {
      throw Error();
    }
  }

  Future<ProfilModel> _getProfile() async {
    try {
      final response = await dioWithToken().get(profileUrl);
      ProfilModel profile = ProfilModel.fromJson(response.data);
      return profile;
    } catch (error) {
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

  FutureDynamic _getNoti() async {
    try {
      final response = await dioWithToken().get(notificationsUrl);
      NotificationModel notifications =
          NotificationModel.fromJson(response.data);

      return notifications;
    } catch (error) {
      throw Error();
    }
  }

  Future<MainGroupListModel> _getMainGroupData(
    DynamicMap queryParameters,
  ) async {
    try {
      final response = await dioWithToken()
          .get(mainGroupTabUrl, queryParameters: queryParameters);

      final data = response.data;
      MyGroupList myGroupList;
      if (data['groups'].isNotEmpty) {
        myGroupList = data['groups']
            .map<MyGroupModel>((json) => MyGroupModel.fromJson(json))
            .toList();

        GlobalGroupProvider()
            .setLastId(myGroupList.length == 10 ? myGroupList.last.id : -1);
      } else {
        myGroupList = [];
        GlobalGroupProvider().setLastId(-1);
      }
      bool hasNotGroup = data['is_recommend'];

      return MainGroupListModel.fromJson(
          {'groups': myGroupList, 'is_recommend': hasNotGroup});
    } catch (error) {
      throw Error();
    }
  }

  Future<MyBingoList> _getMainBingoData(DynamicMap queryParameters) async {
    try {
      final response = await dioWithToken()
          .get(mainBingoTabUrl, queryParameters: queryParameters);

      final data = response.data['boards'];

      if (data.isNotEmpty) {
        MyBingoList myBingoList = data
            .map<MyBingoModel>((json) => MyBingoModel.fromJson(json))
            .toList();
        GlobalBingoProvider()
            .setLastId(myBingoList.length == 10 ? myBingoList.last.id : -1);

        return myBingoList;
      }
      return [];
    } catch (error) {
      throw Error();
    }
  }
}
