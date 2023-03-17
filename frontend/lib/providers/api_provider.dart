import 'package:bin_got/utilities/global_func.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final baseUrl = dotenv.env['baseUrl'];

final options =
    BaseOptions(baseUrl: baseUrl!, headers: {'Authorization': 'JWT $token'});
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

class ApiProvider {
  Future listApi({required String url, required Type type}) async {
    try {
      var list = [];
      final response = await dio.get(url);
      if (response.statusCode == 200) {
        for (var element in response.data) {
          list.add(element);
        }
        return list;
      }
      throw Error();
    } catch (error) {
      throw Error();
    }
  }
}
