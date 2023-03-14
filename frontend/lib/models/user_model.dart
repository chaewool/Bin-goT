class ServiceTokenModel {
  final String accessToken, refreshToken;
  ServiceTokenModel.fromJson(Map<String, dynamic> json)
      : accessToken = json['accessToken'],
        refreshToken = json['refreshToken'];
}

class RefreshTokenModel {
  final String access;
  RefreshTokenModel.fromJson(Map<String, dynamic> json)
      : access = json['access'];
}

class NickNameModel {
  final bool success;
  NickNameModel.fromJson(Map<String, dynamic> json) : success = json['success'];
}

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
