import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final baseUrl = dotenv.env['baseUrl'];

final options = BaseOptions(baseUrl: baseUrl!, headers: {'Authorization': ''});
final dio = Dio(options);

//* 사용자
const accountUrl = '/accounts';
const tokenUrl = '$accountUrl/token';
const usernameUrl = '$accountUrl/username';
const profileUrl = '$accountUrl/profile';
const badgeUrl = '$accountUrl/badge';
const kakaoUrl = '$accountUrl/kakao';

//* 그룹
const groupUrl = '/groups';
