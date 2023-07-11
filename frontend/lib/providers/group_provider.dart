import 'package:bin_got/models/group_model.dart';
import 'package:bin_got/models/user_info_model.dart';
import 'package:bin_got/providers/api_provider.dart';
import 'package:bin_got/utilities/type_def_utils.dart';
import 'package:dio/dio.dart';

//* group provider
class GroupProvider extends ApiProvider {
  //* search
  Future<MyGroupList> searchGroupList({
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

  Future<MyGroupList> _searchGroupList({
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
        MyGroupList groupList = response.data
            .map<MyGroupModel>((json) => MyGroupModel.fromJson(json))
            .toList();
        return groupList;
      }
      throw Error();
    } catch (error) {
      print(error);
      throw Error();
    }
  }

  //* detail
  Future<GroupDetailModel> readGroupDetail(int groupId, String password) async {
    try {
      print('groupId: $groupId, password: $password');
      print(groupDetailUrl(groupId));
      final response = await dioWithToken().get(
        groupDetailUrl(groupId),
        queryParameters: {'password': password},
      );
      print('response: $response');
      if (response.statusCode == 200) {
        return GroupDetailModel.fromJson(response.data);
      }
      throw Error();
    } catch (error) {
      print(error);
      throw Error();
    }
  }

  //* join
  FutureDynamicMap joinGroup(int groupId) async =>
      deliverApi(joinGroupUrl(groupId));

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
      print(error);
      throw Error();
    }
  }

  //* join or forced exit
  FutureVoid grantThisMember(int groupId, DynamicMap grantData) async =>
      createApi(grantMemberUrl(groupId), data: grantData);

  //* update
  FutureVoid editOwnGroup(int groupId, FormData groupData) async {
    try {
      print(groupData);
      final response =
          await dioWithToken().put(editGroupUrl(groupId), data: groupData);
      print(response);
      if (response.statusCode == 200) {
        return response.data.groupId;
      }
      throw Error();
    } catch (error) {
      print(error);
      throw Error();
    }
  }

  //* delete
  FutureVoid deleteOwnGroup(int groupId) async =>
      deleteApi(deleteGroupUrl(groupId));

  //* exit
  FutureVoid exitThisGroup(int groupId) async =>
      deleteApi(exitGroupUrl(groupId));

  //* rank
  Future<RankList> groupRank(int groupId) async {
    try {
      final response = await dioWithToken().get(groupRankUrl(groupId));
      if (response.statusCode == 200) {
        RankList rankList = response.data.map<GroupRankModel>((json) {
          return GroupRankModel.fromJson(json);
        }).toList();
        return rankList;
      }
      throw Error();
    } catch (error) {
      throw Error();
    }
  }

  //* group members
  Future<GroupAdminTabModel> getAdminTabData(int groupId) =>
      _getAdminTabData(groupId);
  Future<GroupAdminTabModel> _getAdminTabData(int groupId) async {
    try {
      print(getMembersUrl(groupId));
      final response = await dioWithToken().get(getMembersUrl(groupId));
      switch (response.statusCode) {
        case 200:
          final data = response.data;
          if (data.isNotEmpty) {
            GroupMemberList applicants = data['applicants']
                .map<GroupMemberModel>(
                    (json) => GroupMemberModel.fromJson(json))
                .toList();
            GroupMemberList members = data['members']
                .map<GroupMemberModel>(
                    (json) => GroupMemberModel.fromJson(json))
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
        default:
          throw Error();
      }
    } catch (error) {
      print('mainTabError: $error');
      // UserProvider.logout();
      throw Error();
    }
  }

  //* chat list
  Future<GroupChatList> readGroupChatList(int groupId, int page) async {
    try {
      final response = await dioWithToken().get(
        groupChatListUrl(groupId),
        queryParameters: {
          'page': page,
        },
      );
      switch (response.statusCode) {
        case 200:
          final data = response.data;
          if (data.isNotEmpty) {
            GroupChatList chats = data
                .map<GroupChatModel>((json) => GroupChatModel.fromJson(json))
                .toList();
            return chats;
          }
          return [];
        default:
          throw Error();
      }
    } catch (error) {
      print(error);
      throw Error();
    }
  }
}
