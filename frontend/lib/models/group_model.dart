import 'package:bin_got/utilities/type_def_utils.dart';

class GroupModel {
  final int id, headCount, count;
  final String groupName, start, end;
  final bool isPublic;
  GroupModel.fromJson(DynamicMap json)
      : id = json['id'],
        headCount = json['headcount'],
        count = json['count'],
        groupName = json['group_name'],
        start = json['start'],
        end = json['end'],
        isPublic = json['is_public'];
}

class GroupDetail {
  final int id, headCount, count, bingoSize, period;
  final String groupName, start, end, password;
  final String? description;
  final bool isPublic, hasImage, needAuth, isParticipant;
  final DynamicMapList rank;
  GroupDetail.fromJson(DynamicMap json)
      : id = json['id'],
        headCount = json['headcount'],
        count = json['count'],
        bingoSize = json['size'],
        groupName = json['group_name'],
        start = json['start'],
        end = json['end'],
        isPublic = json['is_public'],
        description = json['description'],
        hasImage = json['has_image'],
        period = json['period'],
        password = json['password'],
        needAuth = json['need_auth'],
        isParticipant = json['is_participant'],
        rank = json['rank'];
}

class ChatDetail {
  final int chatId, userId;
  final String nickname, content, createdAt, image;
  ChatDetail.fromJson(DynamicMap json)
      : chatId = json['chat_id'],
        userId = json['user_id'],
        nickname = json['nickname'],
        content = json['content'],
        createdAt = json['created_at'],
        image = json['image'];
}
