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
  final int userId, achieve, bingoId;
  final String nickname;
  GroupRankModel.fromJson(DynamicMap json)
      : userId = json['userId'],
        achieve = json['achieve'],
        bingoId = json['bingoId'],
        nickname = json['nickname'];
}

class GroupDetailModel {
  final int headCount, count, bingoSize, memberState;
  final int? bingoId;
  final String groupName, nickname, start, end;
  final String? description, rule;
  final bool hasImage, needAuth;
  // final GroupRankModel rank;
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
        hasImage = json['has_img'],
        needAuth = json['need_auth'],
        memberState = json['is_participant'];
  // rank = json['rank'],
}

class GroupChatModel {
  final int chatId, userId, itemId;
  final String content, createdAt;
  final bool reviewed, hasImage;
  GroupChatModel.fromJson(DynamicMap json)
      : chatId = json['id'],
        userId = json['user_id'],
        itemId = json['item_id'],
        content = json['content'],
        createdAt = json['created_at'],
        reviewed = json['reviewed'],
        hasImage = json['has_img'];
}
