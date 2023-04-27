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
    int? filter,
    required int public,
    required int cnt,
    required int page,
  }) async {
    try {
      final response = await dioWithToken().get(
        searchGroupUrl,
        queryParameters: {
          'period': period,
          'keyword': keyword,
          'order': order,
          'filter': filter,
          'public': public,
          'cnt': cnt,
          'page': page,
        },
      );
      if (response.statusCode == 200) {
        MyGroupList groupList = response.data
            .map<MyGroupModel>((json) => MyGroupModel.fromJson(json));
        return groupList;
      }
      throw Error();
    } catch (error) {
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
      switch (response.statusCode) {
        case 200:
          return GroupDetailModel.fromJson(response.data);
        case 401:
          //* 토큰 리프레시
          final token = await tokenRefresh();
          break;
        default:
          throw Error();
      }

      throw Error();
    } catch (error) {
      print(error);
      throw Error();
    }
  }

  //* join
  FutureVoid joinGroup(int groupId) async {
    deliverApi(joinGroupUrl(groupId));
  }

  //* create
  FutureInt createOwnGroup(FormData groupData) async {
    try {
      final dioWithForm = dioWithToken();
      dioWithForm.options.contentType = 'multipart/form-data';
      final response = await dioWithForm.post(createGroupUrl, data: groupData);
      if (response.statusCode == 200) {
        return response.data.groupId;
      }
      throw Error();
    } catch (error) {
      throw Error();
    }
  }

  //* join or forced exit
  FutureVoid grantThisMember(int groupId, DynamicMap grantData) async {
    createApi(grantMemberUrl(groupId), data: grantData);
  }

  //* update
  FutureVoid editOwnGroup(int groupId, DynamicMap groupData) async {
    updateApi(editGroupUrl(groupId), data: groupData);
  }

  //* delete
  FutureVoid deleteOwnGroup(int groupId) async {
    deleteApi(deleteGroupUrl(groupId));
  }

  //* exit
  FutureVoid exitThisGroup(int groupId) async {
    deleteApi(exitGroupUrl(groupId));
  }

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
}
