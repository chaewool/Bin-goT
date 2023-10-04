import 'package:bin_got/utilities/type_def_utils.dart';

class GroupMemberModel {
  final int id, bingoId, badgeId;
  final String username;
  GroupMemberModel.fromJson(DynamicMap json)
      : id = json['id'],
        badgeId = json['badge'],
        bingoId = json['board_id'],
        username = json['username'];
}

class GroupAdminTabModel {
  final GroupMemberList applicants;
  final GroupMemberList members;
  final bool needAuth;
  GroupAdminTabModel.fromJson(DynamicMap json)
      : applicants = json['applicants'],
        members = json['members'],
        needAuth = json['need_auth'];
}

class GroupRankModel {
  final int userId, bingoId, rank;
  final double achieve;
  final String nickname;
  GroupRankModel.fromJson(DynamicMap json)
      : userId = json['user_id'],
        achieve = json['achieve'],
        bingoId = json['board_id'],
        rank = json['rank'],
        nickname = json['nickname'];
}

class GroupDetailModel {
  final int headCount, count, bingoSize, memberState, bingoId;
  final String groupName, nickname, start, end, password, description, rule;
  final bool hasImage, needAuth;
  final List rank;
  GroupDetailModel.fromJson(DynamicMap json)
      : bingoId = json['board_id'],
        headCount = json['headcount'],
        bingoSize = json['size'],
        count = json['count'],
        memberState = json['is_participant'],
        hasImage = json['has_img'],
        needAuth = json['need_auth'],
        groupName = json['groupname'],
        nickname = json['rand_name'],
        start = json['start'],
        end = json['end'],
        description = json['description'],
        rule = json['rule'],
        password = json['password'],
        rank = json['rank']
            .map((eachRank) => GroupRankModel.fromJson(eachRank))
            .toList();
}

class GroupChatModel {
  final int id, userId, badgeId, itemId;
  final String? content;
  final String username, createdAt, title;
  final bool reviewed, hasImage;
  GroupChatModel.fromJson(DynamicMap json)
      : id = json['id'],
        userId = json['user_id'],
        badgeId = json['badge_id'],
        itemId = json['item_id'],
        username = json['username'],
        content = json['content'],
        createdAt = json['created_at'],
        title = json['title'],
        reviewed = json['reviewed'],
        hasImage = json['has_img'];
}
