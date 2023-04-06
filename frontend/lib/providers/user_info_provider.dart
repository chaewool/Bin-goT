import 'package:bin_got/models/user_info_model.dart';
import 'package:bin_got/providers/api_provider.dart';
import 'package:bin_got/utilities/type_def_utils.dart';

class UserInfoProvider extends ApiProvider {
  //* public
  void checkName(String name) async => _checkName(name);
  void changeName(String name) async => _changeName(name);
  Future<MainTabModel> getMainTabData() async => _getMainTabData();

  //* private
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
          print(response);
          final data = response.data;
          print(data);
          if (data.isNotEmpty) {
            print('isNot');
            MyGroupList myGroupList = data['groups']
                .map<MyGroupModel>((json) => MyGroupModel.fromJson(json))
                .toList();
            MyBingoList myBingoList = data['boards']
                .map<MyBingoModel>((json) => MyBingoModel.fromJson(json))
                .toList();
            print(data);
            bool hasNotGroup = data['is_recommended'];
            return MainTabModel.fromJson({
              'groups': myGroupList,
              'boards': myBingoList,
              'hasNotGroup': hasNotGroup
            });
          }
          return MainTabModel.fromJson(
              {'groups': [], 'boards': [], 'hasNotGroup': true});
        case 401:
          tokenRefresh();
          return MainTabModel.fromJson(
              {'groups': [], 'boards': [], 'hasNotGroup': true});
        default:
          throw Error();
      }
    } catch (error) {
      print(error);
      // UserProvider.logout();
      throw Error();
    }
  }
}
