import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final baseUrl = dotenv.env['baseUrl'];

final options = BaseOptions(baseUrl: baseUrl!, headers: {'Authorization': ''});
final dio = Dio();

//* 사용자
// const accountUrl = '/accounts';
// const tokenUrl = '$accountUrl/token';
// const usernameUrl = '$accountUrl/username';
// const profileUrl = '$accountUrl/profile';
// const badgeUrl = '$accountUrl/badge';
// const kakaoUrl = '$accountUrl/kakao';

final accountUrl = '$baseUrl/accounts';
final tokenUrl = '$accountUrl/token';
final usernameUrl = '$accountUrl/username';
final profileUrl = '$accountUrl/profile';
final badgeUrl = '$accountUrl/badge';
final kakaoUrl = '$accountUrl/kakao';

//* 그룹
const groupUrl = '/groups';
// final groupUrl = '$baseUrl/groups';
