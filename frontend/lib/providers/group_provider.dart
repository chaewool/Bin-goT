import 'package:bin_got/models/group_model.dart';
import 'package:bin_got/providers/api_provider.dart';
import 'package:bin_got/utilities/type_def_utils.dart';

//* group url
String searchGroupUrl({
  int? period,
  String? keyword,
  int? align,
  int? filter,
  required int startIndex,
  required int cnt,
  required int page,
}) =>
    '$groupUrl/search?period=$period&keyword=$keyword&align=$align&filter=$filter&start_index=$startIndex&cnt=$cnt&page=$page';

const createGroupUrl = '$groupUrl/create';

String groupDetailUrl(int groupId) => '$groupUrl/$groupId/';
String joinGroupUrl(int groupId) => '${groupDetailUrl(groupId)}/join/';
String grantMemberUrl(int groupId) => '${groupDetailUrl(groupId)}/grant/';
String editGroupUrl(int groupId) => '${groupDetailUrl(groupId)}/update/';
String deleteGroupUrl(int groupId) => '${groupDetailUrl(groupId)}/delete/';
String exitGroupUrl(int groupId) => '${groupDetailUrl(groupId)}/resign/';
String groupRankUrl(int groupId) => '${groupDetailUrl(groupId)}/rank/';

//* group provider
class GroupProvider with ApiProvider {
  //* search
  static Future<GroupList> searchGroupList({
    int? period,
    String? keyword,
    int? align,
    int? filter,
    required int startIndex,
    required int cnt,
    required int page,
  }) async {
    final url = searchGroupUrl(
      period: period,
      keyword: keyword,
      align: align,
      filter: filter,
      startIndex: startIndex,
      cnt: cnt,
      page: page,
    );
    GroupList groupList = [];
    try {
      final response = await dio.get(url);
      if (response.statusCode == 200) {
        for (var group in response.data) {
          groupList.add(GroupModel.fromJson(group));
        }
        return groupList;
      }
      throw Error();
    } catch (error) {
      throw Error();
    }
  }

  //* detail
  static Future<GroupDetailModel> readGroupDetail(int groupId) async {
    try {
      final response = await dio.get(groupDetailUrl(groupId));
      if (response.statusCode == 200) {
        return GroupDetailModel.fromJson(response.data);
      }
      throw Error();
    } catch (error) {
      throw Error();
    }
  }

  //* join
  static FutureVoid joinGroup(int groupId) async {
    ApiProvider.deliverApi(joinGroupUrl(groupId));
  }

  //* create
  static FutureInt createOwnGroup(DynamicMap groupData) async {
    try {
      final response = await dio.post(createGroupUrl, data: groupData);
      if (response.statusCode == 200) {
        return response.data.groupId;
      }
      throw Error();
    } catch (error) {
      throw Error();
    }
  }

  //* join or forced exit
  static FutureVoid grantThisMember(int groupId, DynamicMap grantData) async {
    ApiProvider.createApi(url: grantMemberUrl(groupId), data: grantData);
  }

  //* update
  static FutureVoid editOwnGroup(int groupId, DynamicMap groupData) async {
    ApiProvider.updateApi(url: editGroupUrl(groupId), data: groupData);
  }

  //* delete
  static FutureVoid deleteOwnGroup(int groupId) async {
    ApiProvider.deleteApi(deleteGroupUrl(groupId));
  }

  //* exit
  static FutureVoid exitThisGroup(int groupId) async {
    ApiProvider.deleteApi(exitGroupUrl(groupId));
  }

  //* rank
  static Future<RankList> groupRank(int groupId) async {
    try {
      final response = await dio.get(groupRankUrl(groupId));
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
