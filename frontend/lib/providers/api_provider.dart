import 'package:bin_got/providers/base_class.dart';
import 'package:bin_got/utilities/type_def_utils.dart';

//* provider
class ApiProvider extends UrlClass {
  //* public
  FutureDynamicMap createApi(String url, {required DynamicMap data}) async =>
      _createApi(url, data: data);

  FutureVoid deliverApi(String url) async => _deliverApi(url);

  FutureVoid updateApi(String url, {required DynamicMap data}) async =>
      _updateApi(url, data: data);

  FutureVoid deleteApi(String url) async => _deleteApi(url);

  FutureDynamicMap tokenRefresh() async {
    try {
      return _tokenRefresh();
    } catch (error) {
      throw Error();
    }
  }

  //* private
  //* refresh token

  FutureDynamicMap _tokenRefresh() async {
    try {
      print('토큰 리프레시');
      final tokenData = await createApi(
        refreshTokenUrl,
        data: {'refresh': refresh},
      );
      return {...tokenData, 'refresh': refresh};
    } catch (error) {
      print(error);
      throw Error();
    }
  }

  //* create
  FutureDynamicMap _createApi(String url, {required DynamicMap data}) async {
    try {
      final response = await dioWithToken().post(url, data: data);
      print('create response: $response');
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
      print('createError: $error');
      throw Error();
    }
  }

  //* data unnecessary
  FutureDynamicMap _deliverApi(String url) async {
    try {
      final response = await dio.post(url);
      switch (response.statusCode) {
        case 200:
          return {};
        case 401:
          return tokenRefresh();
        default:
          throw Error();
      }
    } catch (error) {
      throw Error();
    }
  }

  //* update
  FutureDynamicMap _updateApi(String url, {required DynamicMap data}) async {
    try {
      final response = await dio.put(url, data: data);
      switch (response.statusCode) {
        case 200:
          return {};
        case 401:
          return tokenRefresh();
        default:
          throw Error();
      }
    } catch (error) {
      throw Error();
    }
  }

  //* delete
  FutureDynamicMap _deleteApi(String url) async {
    try {
      final response = await dio.delete(url);
      switch (response.statusCode) {
        case 200:
          return {};
        case 401:
          return tokenRefresh();
        default:
          throw Error();
      }
    } catch (error) {
      throw Error();
    }
  }
}
