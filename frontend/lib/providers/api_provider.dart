import 'package:bin_got/providers/user_provider.dart';
import 'package:bin_got/utilities/type_def_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final baseUrl = dotenv.env['baseUrl'];
final dio = Dio(BaseOptions(baseUrl: baseUrl!));

//* provider
class ApiProvider {
  //* public
  static FutureDynamicMap createApi(String url,
          {required DynamicMap data}) async =>
      _createApi(url, data: data);

  static FutureVoid deliverApi(String url) async => _deliverApi(url);

  static FutureVoid updateApi(String url, {required DynamicMap data}) async =>
      _updateApi(url, data: data);

  static FutureVoid deleteApi(String url) async => _deleteApi(url);

  //* private
  //* create
  static FutureDynamicMap _createApi(String url,
      {required DynamicMap data}) async {
    try {
      final token = await UserProvider.token();
      BaseOptions options = BaseOptions(
          baseUrl: baseUrl!, headers: {'Authorization': 'JWT $token'});
      final dioWithToken = Dio(options);
      print(data);
      final response = await dioWithToken.post(url, data: data);
      print('response: $response');
      switch (response.statusCode) {
        case 200:
          return response.data;
        case 401:
          UserProvider.tokenRefresh();
          return {};
        default:
          throw Error();
      }
    } catch (error) {
      print(error);
      throw Error();
    }
  }

  //* data unnecessary
  static FutureVoid _deliverApi(String url) async {
    try {
      final response = await dio.post(url);
      switch (response.statusCode) {
        case 200:
          return;
        case 401:
          return UserProvider.tokenRefresh();
        default:
          throw Error();
      }
    } catch (error) {
      throw Error();
    }
  }

  //* update
  static FutureVoid _updateApi(String url, {required DynamicMap data}) async {
    try {
      final response = await dio.put(url, data: data);
      switch (response.statusCode) {
        case 200:
          return;
        case 401:
          return UserProvider.tokenRefresh();
        default:
          throw Error();
      }
    } catch (error) {
      throw Error();
    }
  }

  //* delete
  static FutureVoid _deleteApi(String url) async {
    try {
      final response = await dio.delete(url);
      switch (response.statusCode) {
        case 200:
          return;
        case 401:
          return UserProvider.tokenRefresh();
        default:
          throw Error();
      }
    } catch (error) {
      throw Error();
    }
  }
}
