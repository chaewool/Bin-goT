import 'package:flutter_dotenv/flutter_dotenv.dart';

final baseUrl = dotenv.env['baseUrl'];

//* 사용자
final accountUrl = '$baseUrl/accounts';
final tokenUrl = '$accountUrl/token';
final usernameUrl = '$accountUrl/username';
final profileUrl = '$accountUrl/profile';
final badgeUrl = '$accountUrl/badge';
final kakaoUrl = '$accountUrl/kakao';

//* 그룹
final groupUrl = '$baseUrl/groups';
