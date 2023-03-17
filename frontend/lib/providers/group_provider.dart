import 'package:bin_got/providers/api_provider.dart';
import 'package:bin_got/utilities/type_def_utils.dart';

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
String grantGroupUrl(int groupId) => '${groupDetailUrl(groupId)}/grant/';
String editGroupUrl(int groupId) => '${groupDetailUrl(groupId)}/update/';
String deleteGroupUrl(int groupId) => '${groupDetailUrl(groupId)}/delete/';
String exitGroupUrl(int groupId) => '${groupDetailUrl(groupId)}/resign/';

class GroupProvider {
  Future<GroupList> searchGroupList({
    int? period,
    String? keyword,
    int? align,
    int? filter,
    required int startIndex,
    required int cnt,
    required int page,
  }) async {
    // ApiProvider.listApi();
    // try {
    //   GroupList groupList = [];
    //   final response = await dio.get(searchGroupUrl(
    //       period: period,
    //       keyword: keyword,
    //       align: align,
    //       filter: filter,
    //       startIndex: startIndex,
    //       cnt: cnt,
    //       page: page));
    //   if (response.statusCode == 200) {
    //     for (var group in response.data) {
    //       groupList.add(group);
    //     }
    //     return groupList;
    //   }
    //   throw Error();
    // } catch (error) {
    //   throw Error();
    // }
  }

  Future<int> createOwnGroup(DynamicMap groupData) async {
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

  Future<void> editOwnGroup(int groupId, DynamicMap groupData) async {
    try {
      final response = await dio.post(editGroupUrl(groupId), data: groupData);
      if (response.statusCode == 200) {
        return;
      }
      throw Error();
    } catch (error) {
      throw Error();
    }
  }

  Future<void> deleteOwnGroup() async {
    try {
      final response = await dio.post(editGroupUrl(groupId), data: groupData);
      if (response.statusCode == 200) {
        return;
      }
      throw Error();
    } catch (error) {
      throw Error();
    }
  }
}
