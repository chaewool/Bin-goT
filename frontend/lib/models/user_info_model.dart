import 'package:bin_got/utilities/type_def_utils.dart';

class MyGroupModel {
  final int id, headCount, count;
  final bool? isPublic, hasBingo;
  final String? status;
  final String name, start, end;
  MyGroupModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        headCount = json['headcount'],
        count = json['count'],
        isPublic = json['is_public'],
        hasBingo = json['has_board'],
        name = json['groupname'],
        start = json['start'],
        end = json['end'],
        status = json['status'];
}

class MyBingoModel {
  final int id;
  final String groupName, status, start;
  MyBingoModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        groupName = json['groupname'],
        start = json['start'],
        status = json['status'];
}

class MainTabModel {
  final MyGroupList groups;
  final MyBingoList bingos;
  final bool hasNotGroup;
  MainTabModel.fromJson(Map<String, dynamic> json)
      : groups = json['groups'],
        bingos = json['boards'],
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
