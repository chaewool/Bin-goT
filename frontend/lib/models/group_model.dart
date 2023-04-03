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
  final int id, headCount, count, bingoSize, period, memberState, bingoId;
  final String groupName, password;
  final String? description, rule;
  final DateTime start, end;
  final bool isPublic, hasImage, needAuth;
  final GroupRankModel rank;
  GroupDetailModel.fromJson(DynamicMap json)
      : id = json['id'],
        bingoId = json['bingo_id'],
        headCount = json['headcount'],
        count = json['count'],
        bingoSize = json['size'],
        groupName = json['group_name'],
        start = json['start'],
        end = json['end'],
        isPublic = json['is_public'],
        description = json['description'],
        rule = json['rule'],
        hasImage = json['has_image'],
        period = json['period'],
        password = json['password'],
        needAuth = json['need_auth'],
        memberState = json['is_participant'],
        rank = json['rank'];
}

class ChatDetailModel {
  final int chatId, userId;
  final String nickname, content, createdAt, image;
  ChatDetailModel.fromJson(DynamicMap json)
      : chatId = json['chat_id'],
        userId = json['user_id'],
        nickname = json['nickname'],
        content = json['content'],
        createdAt = json['created_at'],
        image = json['image'];
}
