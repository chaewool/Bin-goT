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
      );

  FutureDynamic _searchGroupList({
    int? period,
    String? keyword,
    int? order,
    required int public,
    required int lastId,
  }) async {
    try {
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
      List groups = response.data['groups'];
      MyGroupList groupList;
      if (groups.isNotEmpty) {
        groupList = response.data['groups']
            .map<MyGroupModel>((json) => MyGroupModel.fromJson(json))
            .toList();

        GlobalScrollProvider()
            .setLastId(groupList.length == 10 ? groupList.last.id : -1);
      } else {
        groupList = [];
        GlobalScrollProvider().setLastId(-1);
      }
      return groupList;
    } catch (error) {
      throw Error();
    }
  }

  //* check password
  Future<DynamicMap> checkPassword(int groupId, String password) async {
    try {
      final response = await dioWithToken().post(
        checkPasswordUrl(groupId),
        data: {'password': password},
      );
      return response.data;
    } catch (error) {
      throw Error();
    }
  }

  //* detail
  Future<GroupDetailModel> readGroupDetail(int groupId) async {
    try {
      final response = await dioWithToken().get(groupDetailUrl(groupId));
      GroupDetailModel groupDetail = GroupDetailModel.fromJson(response.data);
      groupDetail.rank.sort((a, b) => b.achieve.compareTo(a.achieve));
      return groupDetail;
    } catch (error) {
      throw Error();
    }
  }

  //* join
  FutureDynamic joinGroup(int groupId, FormData groupData) async {
    try {
      await dioWithTokenForm().post(joinGroupUrl(groupId), data: groupData);
      return Future.value(true);
    } catch (error) {
      throw Error();
    }
  }

  //* create
  FutureInt createOwnGroup(FormData groupData) async {
    try {
      final response =
          await dioWithTokenForm().post(createGroupUrl, data: groupData);

      return response.data['group_id'];
    } catch (error) {
      throw Error();
    }
  }

  //* join or forced exit
  FutureDynamic grantThisMember(int groupId, DynamicMap grantData) =>
      createApi(grantMemberUrl(groupId), data: grantData);

  //* update
  FutureDynamic editOwnGroup(int groupId, FormData groupData) async {
    try {
      await dioWithTokenForm().put(editGroupUrl(groupId), data: groupData);

      return {};
    } catch (error) {
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
      rankList.sort((a, b) => b.achieve.compareTo(a.achieve));
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
        GroupChatList chats = data
            .map<GroupChatModel>((json) => GroupChatModel.fromJson(json))
            .toList();

        int id = chats.last.id;
        GlobalScrollProvider().setLastId(id != 0 ? id : -1);
        return chats;
      } else {
        GlobalScrollProvider().setLastId(-1);
        return [];
      }
    } catch (error) {
      throw Error();
    }
  }

  //* create chat
  FutureDynamicMap createGroupChatChat(
      int groupId, FormData groupChatData) async {
    try {
      final response = await dioWithTokenForm()
          .post(groupChatCreateUrl(groupId), data: groupChatData);

      return response.data;
    } catch (error) {
      throw Error();
    }
  }

  //* check review
  FutureBool checkReview(int groupId, int reviewId) async {
    try {
      await dioWithToken()
          .put(groupReviewCheckUrl(groupId), data: {'review_id': reviewId});
      return true;
    } catch (error) {
      throw Error();
    }
  }
}
