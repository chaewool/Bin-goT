import 'package:bin_got/providers/api_provider.dart';
import 'package:bin_got/utilities/type_def_utils.dart';

//? fcm api
class FCMProvider extends ApiProvider {
  //* public
  FutureDynamicMap saveFCMToken(String token) async =>
      createApi(saveFCMTokentUrl, data: {'fcm_token': token});
}
