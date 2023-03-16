import 'package:bin_got/utilities/type_def_utils.dart';

class ServiceTokenModel {
  final String accessToken, refreshToken;
  ServiceTokenModel.fromJson(DynamicMap json)
      : accessToken = json['accessToken'],
        refreshToken = json['refreshToken'];
}

// class RefreshTokenModel {
//   final String access;
//   RefreshTokenModel.fromJson(Map<String, dynamic> json)
//       : access = json['access'];
// }

// class NickNameModel {
//   final bool success;
//   NickNameModel.fromJson(Map<String, dynamic> json) : success = json['success'];
// }

class MyGroupModel {
  final int id, headCount, count;
  final String groupName, start, end, status;
  MyGroupModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        headCount = json['headcount'],
        count = json['count'],
        groupName = json['groupname'],
        start = json['start'],
        end = json['end'],
        status = json['status'];
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

