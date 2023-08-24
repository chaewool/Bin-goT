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
    required int lastId,
  }) =>
      _searchGroupList(
        period: period,
        keyword: keyword,
        order: order,
        public: public,
        lastId: lastId,
        // page: page,
      );

  FutureDynamic _searchGroupList({
    int? period,
    String? keyword,
    int? order,
    required int public,
    required int lastId,
  }) async {
    try {
      print(searchGroupUrl);
      print('${{
        'period': period,
        'keyword': keyword,
        'order': order,
        'public': public,
        'idx': lastId,
      }}');
      final response = await dioWithToken().get(
        searchGroupUrl,
        queryParameters: {
          'period': period,
          'keyword': keyword,
          'order': order,
          'public': public,
          'idx': lastId,
        },
      );
      print('data => ${response.data}');
      MyGroupList groupList = response.data['groups']
          .map<MyGroupModel>((json) => MyGroupModel.fromJson(json))
          .toList();
      print('group list => $groupList');

      // GlobalScrollProvider().setTotalPage(response.data['last_page']);
      GlobalScrollProvider().setLastId(response.data['last_idx']);
      return groupList;
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
      print('response: ${response.data}');
      // print(
      //     'type => userId : ${response.data['rank'][0]['user_id'].runtimeType}');
      // print(
      //     'type => bingoId : ${response.data['rank'][0]['board_id'].runtimeType}');
      GroupDetailModel groupDetail = GroupDetailModel.fromJson(response.data);
      // return response;
      return groupDetail;
    } catch (error) {
      print(error);
      throw Error();
    }
  }

  //* join
  FutureDynamic joinGroup(int groupId, FormData groupData) async {
    try {
      final response =
          await dioWithTokenForm().post(joinGroupUrl(groupId), data: groupData);
      print(response);
      return Future.value(true);
    } catch (error) {
      print(error);
      throw Error();
    }
  }

  //* create
  FutureInt createOwnGroup(FormData groupData) async {
    try {
      final response =
          await dioWithTokenForm().post(createGroupUrl, data: groupData);
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
      // final response =
      await dioWithTokenForm().put(editGroupUrl(groupId), data: groupData);

      return {};
    } catch (error) {
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
  Future<RankList> groupRank(int groupId) async {
    try {
      final response = await dioWithToken().get(groupRankUrl(groupId));
      RankList rankList = response.data.map<GroupRankModel>((json) {
        return GroupRankModel.fromJson(json);
      }).toList();
      return rankList;
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
      print('mainTabError: $error');
      // UserProvider.logout();
      throw Error();
    }
  }

  //* chat list
  FutureDynamic readGroupChatList(int groupId, int lastId) async {
    try {
      final response = await dioWithToken().get(
        groupChatListUrl(groupId),
        queryParameters: {'idx': lastId},
      );
      final data = response.data;
      if (data.isNotEmpty) {
        print(data);
        GroupChatList chats = data
            .map<GroupChatModel>((json) => GroupChatModel.fromJson(json))
            .toList();

        int id = chats.last.id;

        print('provider last id => $id');
        GlobalScrollProvider().setLastId(id != 0 ? id : -1);
        return chats;
      } else {
        GlobalScrollProvider().setLastId(-1);
        return [];
      }
    } catch (error) {
      print('chat error => $error');
      throw Error();
    }
  }

  //* create chat
  FutureDynamicMap createGroupChatChat(
      int groupId, FormData groupChatData) async {
    try {
      print(groupChatCreateUrl(groupId));
      final response = await dioWithTokenForm()
          .post(groupChatCreateUrl(groupId), data: groupChatData);

      return response.data;
    } catch (error) {
      print(error);
      throw Error();
    }
  }

  //* check review
  FutureBool checkReview(int groupId, int reviewId) async {
    try {
      print(groupReviewCheckUrl(groupId));
      final response = await dioWithToken()
          .put(groupReviewCheckUrl(groupId), data: {'review_id': reviewId});
      print(response.data);
      return true;
    } catch (error) {
      print(error);
      throw Error();
    }
  }
}
