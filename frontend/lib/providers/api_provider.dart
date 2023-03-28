import 'package:bin_got/utilities/type_def_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final baseUrl = dotenv.env['baseUrl'];
// final options =
//     BaseOptions(baseUrl: baseUrl!, headers: {'Authorization': 'JWT $token'});
final options = BaseOptions(baseUrl: baseUrl!);
final dio = Dio(options);

//* 그룹
const groupUrl = '/groups';

//* Api 기본 틀
class ApiProvider {
  //* create
  static FutureDynamicMap _createApi(String url,
      {required DynamicMap data}) async {
    try {
      final response = await dio.post(url, data: data);
      if (response.statusCode == 200) {
        return response.data;
      }
      throw Error();
    } catch (error) {
      print(error);
      throw Error();
    }
  }

  static FutureDynamicMap createApi(String url,
      {required DynamicMap data}) async {
    return _createApi(url, data: data);
  }

  //* data unnecessary
  static FutureVoid _deliverApi(String url) async {
    try {
      final response = await dio.post(url);
      if (response.statusCode == 200) {
        return;
      }
      throw Error();
    } catch (error) {
      throw Error();
    }
  }

  static FutureVoid deliverApi(String url) async {
    return _deliverApi(url);
  }

  //* update
  static FutureVoid _updateApi(String url, {required DynamicMap data}) async {
    try {
      final response = await dio.put(url, data: data);
      if (response.statusCode == 200) {
        return;
      }
      throw Error();
    } catch (error) {
      throw Error();
    }
  }

  static FutureVoid updateApi(String url, {required DynamicMap data}) async {
    _updateApi(url, data: data);
  }

  //* delete
  static FutureVoid _deleteApi(String url) async {
    try {
      final response = await dio.delete(url);
      if (response.statusCode == 200) {
        return;
      }
      throw Error();
    } catch (error) {
      throw Error();
    }
  }

  static FutureVoid deleteApi(String url) async {
    _deleteApi(url);
  }
}
