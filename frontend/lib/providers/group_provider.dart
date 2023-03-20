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

//* group provider
class GroupProvider with ApiProvider {
  //* search
  static FutureList searchGroupList({
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
    return ApiProvider.listApi(url: url, list: groupList, model: GroupModel);
  }

  //* detail
  static FutureDynamic readGroupDetail(int groupId) async {
    return ApiProvider.detailApi(
        url: groupDetailUrl(groupId), model: GroupDetail);
  }

  //* join
  static FutureVoid joinGroup(int groupId) async {
    ApiProvider.deliverApi(url: joinGroupUrl(groupId));
  }

  //* create
  static FutureInt createOwnGroup(DynamicMap groupData) async {
    return ApiProvider.createApi(
        url: createGroupUrl, data: groupData)['groupId'];
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
    ApiProvider.deleteApi(url: deleteGroupUrl(groupId));
  }

  //* exit
  static FutureVoid exitThisGroup(int groupId) async {
    ApiProvider.deleteApi(url: exitGroupUrl(groupId));
  }
}
