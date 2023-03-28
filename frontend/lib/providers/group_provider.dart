import 'package:bin_got/models/group_model.dart';
import 'package:bin_got/models/user_model.dart';
import 'package:bin_got/providers/api_provider.dart';
import 'package:bin_got/utilities/type_def_utils.dart';

//* group provider
class GroupProvider with ApiProvider {
  //* group url
  String _searchGroupUrl({
    int? period,
    String? keyword,
    int? align,
    int? filter,
    required int startIndex,
    required int cnt,
    required int page,
  }) =>
      '$groupUrl/search?period=$period&keyword=$keyword&align=$align&filter=$filter&start_index=$startIndex&cnt=$cnt&page=$page';

  final _createGroupUrl = '$groupUrl/create/';
  final _recommendGroupUrl = '$groupUrl/recommend/';
  String _groupDetailUrl(int groupId) => '$groupUrl/$groupId/';
  String _joinGroupUrl(int groupId) => '${_groupDetailUrl(groupId)}/join/';
  String _grantMemberUrl(int groupId) => '${_groupDetailUrl(groupId)}/grant/';
  String _editGroupUrl(int groupId) => '${_groupDetailUrl(groupId)}/update/';
  String _deleteGroupUrl(int groupId) => '${_groupDetailUrl(groupId)}/delete/';
  String _exitGroupUrl(int groupId) => '${_groupDetailUrl(groupId)}/resign/';
  String _groupRankUrl(int groupId) => '${_groupDetailUrl(groupId)}/rank/';

  //* search
  Future<GroupList> searchGroupList({
    int? period,
    String? keyword,
    int? align,
    int? filter,
    required int startIndex,
    required int cnt,
    required int page,
  }) async {
    final url = _searchGroupUrl(
      period: period,
      keyword: keyword,
      align: align,
      filter: filter,
      startIndex: startIndex,
      cnt: cnt,
      page: page,
    );
    try {
      final response = await dio.get(url);
      if (response.statusCode == 200) {
        GroupList groupList =
            response.data.map<GroupModel>((json) => GroupModel.fromJson(json));
        return groupList;
      }
      throw Error();
    } catch (error) {
      throw Error();
    }
  }

  //* detail
  Future<GroupDetailModel> readGroupDetail(int groupId) async {
    try {
      final response = await dio.get(_groupDetailUrl(groupId));
      if (response.statusCode == 200) {
        return GroupDetailModel.fromJson(response.data);
      }
      throw Error();
    } catch (error) {
      throw Error();
    }
  }

  //* recommend
  Future<MyGroupList> recommendGroupList() async {
    try {
      final response = await dio.get(_recommendGroupUrl);
      if (response.statusCode == 200) {
        MyGroupList groupList = response.data
            .map<MyGroupModel>((json) => MyGroupModel.fromJson(json));
        return groupList;
      }
      throw Error();
    } catch (error) {
      print(error);
      throw Error();
    }
  }

  //* join
  FutureVoid joinGroup(int groupId) async {
    ApiProvider.deliverApi(_joinGroupUrl(groupId));
  }

  //* create
  FutureInt createOwnGroup(DynamicMap groupData) async {
    try {
      final response = await dio.post(_createGroupUrl, data: groupData);
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
    ApiProvider.createApi(_grantMemberUrl(groupId), data: grantData);
  }

  //* update
  FutureVoid editOwnGroup(int groupId, DynamicMap groupData) async {
    ApiProvider.updateApi(_editGroupUrl(groupId), data: groupData);
  }

  //* delete
  FutureVoid deleteOwnGroup(int groupId) async {
    ApiProvider.deleteApi(_deleteGroupUrl(groupId));
  }

  //* exit
  FutureVoid exitThisGroup(int groupId) async {
    ApiProvider.deleteApi(_exitGroupUrl(groupId));
  }

  //* rank
  Future<RankList> groupRank(int groupId) async {
    try {
      final response = await dio.get(_groupRankUrl(groupId));
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
