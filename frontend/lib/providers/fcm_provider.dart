import 'package:bin_got/providers/api_provider.dart';

class FCMProvider extends ApiProvider {
  //* public
  void saveFCMToken(String token) async => _saveFCMToken(token);

  //* private
  void _saveFCMToken(String token) =>
      createApi(saveFCMTokentUrl, data: {'fcm_token': token});
}
