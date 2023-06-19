import 'package:bin_got/utilities/type_def_utils.dart';

class MyGroupModel {
  final int id, headCount, count;
  // final bool? hasBingo;
  // final bool? isPublic;
  final String? status;
  final String name, start, end;
  MyGroupModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        headCount = json['headcount'],
        count = json['count'],
        // isPublic = json['is_public'],
        // hasBingo = json['has_board'],
        name = json['groupname'],
        start = json['start'],
        end = json['end'],
        status = json['status'];
}

class MyBingoModel {
  final int id;
  // final int id, size;
  final String groupName, status, start;
  MyBingoModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        // size = json['size'],
        groupName = json['groupname'],
        start = json['start'],
        status = json['status'];
}

class MainGroupListModel {
  final MyGroupList groups;
  final bool hasNotGroup;
  MainGroupListModel.fromJson(Map<String, dynamic> json)
      : groups = json['groups'],
        hasNotGroup = json['is_recommend'];
}

class ProfileModel {
  final String username;
  final int badgeId;
  ProfileModel.fromJson(DynamicMap json)
      : badgeId = json['badge'],
        username = json['username'];
}

class BadgeModel {
  final int id;
  final String name;
  final bool hasBadge;
  BadgeModel.fromJson(DynamicMap json)
      : id = json['id'],
        name = json['badge_cond'],
        hasBadge = json['has_badge'];
}
