import 'package:bin_got/providers/base_class.dart';
import 'package:bin_got/providers/user_provider.dart';
import 'package:bin_got/utilities/type_def_utils.dart';

//* provider

class TokenProvider with DioClass, UrlClass {
  //* refresh token
  FutureVoid tokenRefresh() async {
    try {
      _tokenRefresh();
    } catch (error) {
      await storage.delete(key: 'token');
      await storage.delete(key: 'refresh');
      throw Error();
    }
  }

  void _tokenRefresh() async {
    try {
      print('토큰 리프레시');
      final data = await createApi(
        refreshTokenUrl,
        data: {'refresh': await refresh()},
      );
      print('data: $data');
      _setToken(data['access']);
    } catch (error) {
      print(error);
      throw Error();
    }
  }
}

//* provider
class ApiProvider extends TokenProvider {
  //* public
  FutureDynamicMap createApi(String url,
          {required DynamicMap data, required String token}) async =>
      _createApi(url, data: data, token: token);

  FutureVoid deliverApi(String url) async => _deliverApi(url);

  FutureVoid updateApi(String url, {required DynamicMap data}) async =>
      _updateApi(url, data: data);

  FutureVoid deleteApi(String url) async => _deleteApi(url);

  //* private

  //* create
  FutureDynamicMap _createApi(String url,
      {required DynamicMap data, required String token}) async {
    try {
      final response = await dioWithToken(token).post(url, data: data);
      print('response: $response');
      switch (response.statusCode) {
        case 200:
          return response.data;
        case 401:
          tokenRefresh();
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
  FutureVoid _deliverApi(String url) async {
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
  FutureVoid _updateApi(String url, {required DynamicMap data}) async {
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
  FutureVoid _deleteApi(String url) async {
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
