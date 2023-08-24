import 'package:bin_got/utilities/type_def_utils.dart';

// class GroupModel {
//   final int id, headCount, count;
//   final String name, start, end;
//   final bool isPublic;
//   GroupModel.fromJson(DynamicMap json)
//       : id = json['id'],
//         headCount = json['headcount'],
//         count = json['count'],
//         name = json['group_name'],
//         start = json['start'],
//         end = json['end'],
//         isPublic = json['is_public'];
// }

class GroupMemberModel {
  final int id, bingoId;
  final String username;
  GroupMemberModel.fromJson(DynamicMap json)
      : id = json['id'],
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
  final int userId, bingoId;
  final double achieve;
  final String nickname;
  GroupRankModel.fromJson(DynamicMap json)
      : userId = json['user_id'],
        achieve = json['achieve'],
        bingoId = json['board_id'],
        nickname = json['nickname'];
}

class GroupDetailModel {
  final int headCount, count, bingoSize, memberState;
  final int? bingoId;
  final String groupName, nickname, start, end, password, description, rule;
  final bool hasImage, needAuth;
  final List rank;
  GroupDetailModel.fromJson(DynamicMap json)

      // : id = json['id'],
      : bingoId = json['board_id'],
        headCount = json['headcount'],
        bingoSize = json['size'],
        groupName = json['groupname'],
        nickname = json['rand_name'],
        count = json['count'],
        start = json['start'],
        end = json['end'],
        description = json['description'],
        rule = json['rule'],
        password = json['password'],
        hasImage = json['has_img'],
        needAuth = json['need_auth'],
        memberState = json['is_participant'],
        // rank = json['rank'];
        rank = json['rank']
            .map((eachRank) => GroupRankModel.fromJson(eachRank))
            .toList();
}

class GroupChatModel {
  final int id, userId, badgeId, itemId;
  final String? content;
  final String username, createdAt;
  // title;
  final bool reviewed, hasImage;
  GroupChatModel.fromJson(DynamicMap json)
      : id = json['id'],
        userId = json['user_id'],
        badgeId = json['badge_id'],
        itemId = json['item_id'],
        username = json['username'],
        content = json['content'],
        createdAt = json['created_at'],
        // title = json['title'],
        reviewed = json['reviewed'],
        hasImage = json['has_img'];
}
