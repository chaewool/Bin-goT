import 'package:bin_got/utilities/global_func.dart';
import 'package:bin_got/utilities/type_def_utils.dart';
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

//* Api 기본 틀
class ApiProvider {
  //* read list
  static FutureList _listApi(
      {required String url, required List list, required dynamic model}) async {
    try {
      final response = await dio.get(url);
      if (response.statusCode == 200) {
        for (var element in response.data) {
          list.add(model.fromJson(element));
        }
        return list;
      }
      throw Error();
    } catch (error) {
      throw Error();
    }
  }

  static FutureList listApi(
      {required String url, required List list, required dynamic model}) async {
    return _listApi(url: url, list: list, model: model);
  }

  //* read detail
  static FutureDynamic _detailApi(
      {required String url, required dynamic model}) async {
    try {
      final response = await dio.get(url);
      if (response.statusCode == 200) {
        return model.fromJson(response.data);
      }
      throw Error();
    } catch (error) {
      throw Error();
    }
  }

  static FutureDynamic detailApi(
      {required String url, required dynamic model}) async {
    return _detailApi(url: url, model: model);
  }

  //* create
  static FutureDynamicMap _createApi(
      {required String url, required DynamicMap data}) async {
    try {
      final response = await dio.post(url, data: data);
      if (response.statusCode == 200) {
        return response.data;
      }
      throw Error();
    } catch (error) {
      throw Error();
    }
  }

  static FutureDynamicMap createApi(
      {required String url, required DynamicMap data}) async {
    return _createApi(url: url, data: data);
  }

  //* data unnecessary
  static FutureVoid _deliverApi({required String url}) async {
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

  static FutureVoid deliverApi({required String url}) async {
    return _deliverApi(url: url);
  }

  //* update
  static FutureVoid _updateApi(
      {required String url, required DynamicMap data}) async {
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

  static FutureVoid updateApi(
      {required String url, required DynamicMap data}) async {
    _updateApi(url: url, data: data);
  }

  //* delete
  static FutureVoid _deleteApi({required String url}) async {
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

  static FutureVoid deleteApi({required String url}) async {
    _deleteApi(url: url);
  }
}
