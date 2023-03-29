import 'package:bin_got/utilities/type_def_utils.dart';

class ServiceTokenModel {
  final String accessToken, refreshToken;
  final bool alreadyMember, notiRank, notiDue, notiChat;
  ServiceTokenModel.fromJson(DynamicMap json)
      : accessToken = json['access_token'],
        refreshToken = json['refresh_token'],
        alreadyMember = json['is_login'],
        notiRank = json['noti_rank'],
        notiDue = json['noti_due'],
        notiChat = json['noti_chat'];
}

class RefreshTokenModel {
  final String accessToken, refreshToken;
  RefreshTokenModel.fromJson(DynamicMap json)
      : accessToken = json['accessToken'],
        refreshToken = json['refreshToken'];
}
