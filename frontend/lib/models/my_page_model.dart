import 'package:bin_got/utilities/type_def_utils.dart';

class EnterMyPage {
  final int badgeId;
  final String nickname, username;

  EnterMyPage.fromJson(Map<dynamic, dynamic> json)
      : badgeId = json['badge_id'],
        nickname = json['nickname'],
        username = json['username'];
}

// class GetBingoList {
//   final int groupId, status, bingoId;
//   final String groupName, bingoName;
//   final DateTime start, end;
//   final File bingoDetail;

//   GetBingoList.fromJson(Map<dynamic, dynamic> json)
//       : groupId = json['group_id'],
//         status = json['status'],
//         bingoId = json['bingo_id'],
//         bingoName = json['bingo_name'],
//         groupName = json['groupName'],
//         start = json['start'],
//         end = json['end'],
//         bingoDetail = json['bingoDetail'];
// }

class GetBadgeList {
  final int badgeId;
  final String badgeName, badgeCond;
  final bool hasBadge;

  GetBadgeList.fromJson(Map<dynamic, dynamic> json)
      : badgeId = json['badge_id'],
        badgeName = json['badge_name'],
        badgeCond = json['badge_cond'],
        hasBadge = json['has_badge'];
}

class MyBadgeModel {
  final int id;
  final bool hasBadge;
  final String badgeName, badgeCond;
  MyBadgeModel.fromJson(DynamicMap json)
      : id = json['id'],
        hasBadge = json['has_badge'],
        badgeName = json['badgename'],
        badgeCond = json['badge_cond'];
}

// class ApplyBadgeModel {
//   final bool success;
//   ApplyBadgeModel.fromJson(Map<String, dynamic> json) : success = json['success'];
// }

// class ApplyNotiModel {
//   final bool success;
//   ApplyNotiModel.fromJson(Map<String, dynamic> json) : success = json['success'];
// }