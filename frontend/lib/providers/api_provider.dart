import 'package:bin_got/providers/base_provider.dart';
import 'package:bin_got/utilities/type_def_utils.dart';

//* provider
class ApiProvider extends UrlClass {
  //* public
  FutureDynamicMap createApi(String url, {required DynamicMap data}) async =>
      _createApi(url, data: data);

  FutureDynamicMap deliverApi(String url) async => _deliverApi(url);

  FutureVoid updateApi(String url, {required DynamicMap data}) async =>
      _updateApi(url, data: data);

  FutureDynamicMap deleteApi(String url) async => _deleteApi(url);

  //* private

  //* create
  FutureDynamicMap _createApi(String url, {required DynamicMap data}) async {
    try {
      print(data);
      final response = await dioWithToken().post(url, data: data);
      print('create: $response');
      if (response.statusCode == 200) {
        return response.data;
      }
      throw Error();
    } catch (error) {
      print('createError: $error');
      throw Error();
    }
  }

  //* data unnecessary
  FutureDynamicMap _deliverApi(String url) async {
    try {
      final response = await dioWithToken().post(url);
      if (response.statusCode == 200) {
        return {};
      }
      throw Error();
    } catch (error) {
      throw Error();
    }
  }

  //* update
  FutureDynamicMap _updateApi(String url, {required DynamicMap data}) async {
    try {
      final response = await dioWithToken().put(url, data: data);
      if (response.statusCode == 200) {
        return {};
      }
      throw Error();
    } catch (error) {
      throw Error();
    }
  }

  //* delete
  FutureDynamicMap _deleteApi(String url) async {
    try {
      final response = await dioWithToken().delete(url);
      if (response.statusCode == 200) {
        return {};
      }
      throw Error();
    } catch (error) {
      throw Error();
    }
  }
}