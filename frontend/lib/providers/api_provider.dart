import 'package:bin_got/providers/base_provider.dart';
import 'package:bin_got/utilities/type_def_utils.dart';

//* CRD 기본 형식
class ApiProvider extends UrlClass {
  //* public
  FutureDynamicMap createApi(String url, {required DynamicMap data}) async =>
      _createApi(url, data: data);

  FutureDynamicMap updateApi(String url, {required DynamicMap data}) async =>
      _updateApi(url, data: data);

  FutureDynamicMap deleteApi(String url) async => _deleteApi(url);

  //* private

  //* create
  FutureDynamicMap _createApi(String url, {required DynamicMap data}) async {
    try {
      final response = await dioWithToken().post(url, data: data);
      return response.data;
    } catch (error) {
      throw Error();
    }
  }

  //* update
  FutureDynamicMap _updateApi(String url, {required DynamicMap data}) async {
    try {
      await dioWithToken().put(url, data: data);
      return {};
    } catch (error) {
      throw Error();
    }
  }

  //* delete
  FutureDynamicMap _deleteApi(String url) async {
    try {
      await dioWithToken().delete(url);
      return {};
    } catch (error) {
      throw Error();
    }
  }
}
