import 'dart:io';

class EnterMyPage {
  final int badgeId;
  final String nickname, username;
  // final int groupId, status, headCount, count;
  // final String groupName;
  // final DateTime start, end;

  EnterMyPage.fromJson(Map<dynamic, dynamic> json)
      : badgeId = json['badge_id'],
        nickname = json['nickname'],
        username = json['username'];
  // groupId = json['group_id'],
  // status = json['status'],
  // headCount = json['headCount'],
  // count = json['count'],
  // groupName = json['groupName'],
  // start = json['start'],
  // end = json['end'];
}

class GetBingoList {
  final int groupId, status, bingoId;
  final String groupName, bingoName;
  final DateTime start, end;
  final File bingoDetail;

  GetBingoList.fromJson(Map<dynamic, dynamic> json)
      : groupId = json['group_id'],
        status = json['status'],
        bingoId = json['bingo_id'],
        bingoName = json['bingo_name'],
        groupName = json['groupName'],
        start = json['start'],
        end = json['end'],
        bingoDetail = json['bingoDetail'];
}

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
