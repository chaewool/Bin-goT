import 'package:bin_got/utilities/type_def_utils.dart';

class MyGroupModel {
  final int id, headCount, count;
  final String groupName, status;
  final DateTime start, end;
  MyGroupModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        headCount = json['headcount'],
        count = json['count'],
        groupName = json['groupname'],
        start = json['start'],
        end = json['end'],
        status = json['status'];
}

class MyBingoModel {
  final int id;
  final String groupName, status;
  final DateTime start;
  MyBingoModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        groupName = json['groupname'],
        start = json['start'],
        status = json['status'];
}

class MainTabModel {
  final MyGroupList groups;
  final MyBingoList bingos;
  MainTabModel.fromJson(Map<String, dynamic> json)
      : groups = json['groups'],
        bingos = json['boards'];
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

