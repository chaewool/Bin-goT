import 'package:bin_got/utilities/type_def_utils.dart';

class MyGroupModel {
  final int id, headCount, count;
  final bool? isPublic;
  final String? status;
  final String name, start, end;
  MyGroupModel.fromJson(DynamicMap json)
      : id = json['id'],
        headCount = json['headcount'],
        count = json['count'],
        isPublic = json['is_public'],
        name = json['groupname'],
        start = json['start'],
        end = json['end'],
        status = json['status'];
}

class MyBingoModel {
  final int id, size, groupId;
  final String groupName, status, start;
  MyBingoModel.fromJson(DynamicMap json)
      : id = json['id'],
        groupId = json['group_id'],
        size = json['size'],
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

class ProfilModel {
  final String username;
  final int badgeId, numberOfCompleted, numberOfWon, ownBadges;
  ProfilModel.fromJson(DynamicMap json)
      : badgeId = json['badge'],
        username = json['username'],
        numberOfCompleted = json['cnt_boards_complete'],
        numberOfWon = json['cnt_rank1'],
        ownBadges = json['cnt_badge'];
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

class NotificationModel {
  final bool rank, due, chat, check;
  NotificationModel.fromJson(DynamicMap json)
      : rank = json['noti_rank'],
        due = json['noti_due'],
        chat = json['noti_chat'],
        check = json['noti_check'];
}
