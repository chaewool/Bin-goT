import 'package:bin_got/providers/api_provider.dart';
import 'package:bin_got/utilities/type_def_utils.dart';

class FCMProvider extends ApiProvider {
  //* public
  FutureDynamicMap saveFCMToken(String token) async => _saveFCMToken(token);

  //* private
  FutureDynamicMap _saveFCMToken(String token) =>
      createApi(saveFCMTokentUrl, data: {'fcm_token': token});
}
