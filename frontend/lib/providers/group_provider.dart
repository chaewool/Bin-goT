import 'package:bin_got/models/group_model.dart';
import 'package:bin_got/models/user_info_model.dart';
import 'package:bin_got/providers/api_provider.dart';
import 'package:bin_got/providers/root_provider.dart';
import 'package:bin_got/utilities/type_def_utils.dart';
import 'package:dio/dio.dart';

//* group provider
class GroupProvider extends ApiProvider {
  //* search
  FutureDynamic searchGroupList({
    int? period,
    String? keyword,
    int? order,
    required int public,
    required int cnt,
    required int page,
  }) =>
      _searchGroupList(
        period: period,
        keyword: keyword,
        order: order,
        public: public,
        cnt: cnt,
        page: page,
      );

  FutureDynamic _searchGroupList({
    int? period,
    String? keyword,
    int? order,
    required int public,
    required int cnt,
    required int page,
  }) async {
    try {
      // print(searchGroupUrl);
      // print('${{
      //   'period': period,
      //   'keyword': keyword,
      //   'order': order,
      //   'public': public,
      //   'cnt': cnt,
      //   'page': page,
      // }}');
      final response = await dioWithToken().get(
        searchGroupUrl,
        queryParameters: {
          'period': period,
          'keyword': keyword,
          'order': order,
          'public': public,
          'page': page,
          'cnt': cnt,
        },
      );
      if (response.statusCode == 200) {
        print('data => ${response.data}');
        MyGroupList groupList = response.data['groups']
            .map<MyGroupModel>((json) => MyGroupModel.fromJson(json))
            .toList();
        print('group list => $groupList');

        GlobalScrollProvider().setTotalPage(response.data['last_page']);
        return groupList;
      }
      throw Error();
    } catch (error) {
      print(error);
      throw Error();
    }
  }

  //* detail
  FutureDynamic readGroupDetail(int groupId, String password) async {
    try {
      print('groupId: $groupId, password: $password');
      print(groupDetailUrl(groupId));
      final response = await dioWithToken().get(
        groupDetailUrl(groupId),
        queryParameters: {'password': password},
      ).catchError((error) {
        // print('catch error => ${error.response!.data}');
      });
      print('response: $response');
      // return response;
      return GroupDetailModel.fromJson(response.data);
    } catch (error) {
      if (error.toString().contains('401')) {
        return {'statusCode': 401};
      }
      throw Error();
    }
  }

  //* join
  FutureDynamic joinGroup(int groupId, FormData groupData) async {
    try {
      final dioWithForm = dioWithToken();
      dioWithForm.options.contentType = 'multipart/form-data';
      final response =
          await dioWithForm.post(joinGroupUrl(groupId), data: groupData);
      print(response);
      return Future.value(true);
    } catch (error) {
      if (error.toString().contains('401')) {
        return {'statusCode': 401};
      }
      print(error);
      throw Error();
    }
  }

  //* create
  FutureInt createOwnGroup(FormData groupData) async {
    try {
      final dioWithForm = dioWithToken();
      dioWithForm.options.contentType = 'multipart/form-data';
      final response = await dioWithForm.post(createGroupUrl, data: groupData);
      print(response);
      if (response.statusCode == 200) {
        return response.data['group_id'];
      }
      throw Error();
    } catch (error) {
      print(error);
      throw Error();
    }
  }

  //* join or forced exit
  FutureDynamic grantThisMember(int groupId, DynamicMap grantData) =>
      createApi(grantMemberUrl(groupId), data: grantData);

  //* update
  FutureDynamic editOwnGroup(int groupId, FormData groupData) async {
    try {
      print(groupData);
      final response =
          await dioWithToken().put(editGroupUrl(groupId), data: groupData);
      return response.data.groupId;
    } catch (error) {
      if (error.toString().contains('401')) {
        return {'statusCode': 401};
      }
      print(error);
      throw Error();
    }
  }

  //* delete
  FutureDynamic deleteOwnGroup(int groupId) async =>
      deleteApi(deleteGroupUrl(groupId));

  //* exit
  FutureDynamic exitThisGroup(int groupId) async =>
      deleteApi(exitGroupUrl(groupId));

  //* rank
  FutureDynamic groupRank(int groupId) async {
    try {
      final response = await dioWithToken().get(groupRankUrl(groupId));
      RankList rankList = response.data.map<GroupRankModel>((json) {
        return GroupRankModel.fromJson(json);
      }).toList();
      return rankList;
    } catch (error) {
      if (error.toString().contains('401')) {
        return {'statusCode': 401};
      }
      throw Error();
    }
  }

  //* group members
  FutureDynamic getAdminTabData(int groupId) => _getAdminTabData(groupId);

  FutureDynamic _getAdminTabData(int groupId) async {
    try {
      print(getMembersUrl(groupId));
      final response = await dioWithToken().get(getMembersUrl(groupId));

      final data = response.data;
      if (data.isNotEmpty) {
        GroupMemberList applicants = data['applicants']
            .map<GroupMemberModel>((json) => GroupMemberModel.fromJson(json))
            .toList();
        GroupMemberList members = data['members']
            .map<GroupMemberModel>((json) => GroupMemberModel.fromJson(json))
            .toList();
        bool needAuth = data['need_auth'];
        return GroupAdminTabModel.fromJson({
          'applicants': applicants,
          'members': members,
          'need_auth': needAuth,
        });
      }
      return GroupAdminTabModel.fromJson({
        'applicants': [],
        'members': [],
        'need_auth': false,
      });
    } catch (error) {
      if (error.toString().contains('401')) {
        return {'statusCode': 401};
      }
      print('mainTabError: $error');
      // UserProvider.logout();
      throw Error();
    }
  }

  //* chat list
  FutureDynamic readGroupChatList(int groupId, int page) async {
    try {
      final response = await dioWithToken().get(
        groupChatListUrl(groupId),
        queryParameters: {
          'page': page,
        },
      );
      final data = response.data;
      if (data.isNotEmpty) {
        GroupChatList chats = data
            .map<GroupChatModel>((json) => GroupChatModel.fromJson(json))
            .toList();
        return chats;
      }
      return [];
    } catch (error) {
      if (error.toString().contains('401')) {
        return {'statusCode': 401};
      }
      print(error);
      throw Error();
    }
  }
}
