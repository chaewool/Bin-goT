import 'package:bin_got/providers/api_provider.dart';

String searchGroup({
  required int period,
  required String keyword,
  required int align,
  required int filter,
  required int startIndex,
  required int cnt,
  required int page,
}) =>
    '$groupUrl/search?period=$period&keyword=$keyword&align=$align&filter=$filter&start_index=$startIndex&cnt=$cnt&page=$page';

final createGroup = '$groupUrl/create';

String groupDetail(int groupId) => '$groupUrl/$groupId/';
String joinGroup(int groupId) => '${groupDetail(groupId)}/join/';
String grantGroup(int groupId) => '${groupDetail(groupId)}/grant/';
String editGroup(int groupId) => '${groupDetail(groupId)}/update/';
String deleteGroup(int groupId) => '${groupDetail(groupId)}/delete/';
String exitGroup(int groupId) => '${groupDetail(groupId)}/resign/';
