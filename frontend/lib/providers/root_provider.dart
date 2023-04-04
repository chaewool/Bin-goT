import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier, DiagnosticableTreeMixin {
  String? _token, _refresh;

  String? get token => _token;
  String? get refresh => _refresh;

  void debugFillProperites(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('token', token));
    properties.add(StringProperty('refresh', refresh));
  }

  void _setToken(String? newToken) => _token = newToken;
  void _setRefresh(String? newRefresh) => _refresh = newRefresh;
  void _storeValue(String key, String? value) {
    const storage = FlutterSecureStorage();
    storage.write(key: 'token', value: value);
  }

  dynamic _readStorage() async {
    const storage = FlutterSecureStorage();
    final userInfo = await storage.readAll();
    return userInfo;
  }

  void initVar() {
    final userInfo = _readStorage();
    if (userInfo != null) {
      _setToken(userInfo!['token']);
      _setRefresh(userInfo!['refresh']);
      notifyListeners();
    }
  }

  void setStoreToken(String newToken) {
    _setToken(newToken);
    _storeValue('token', newToken);
    notifyListeners();
  }

  void setStoreRefresh(String newRefresh) {
    _setRefresh(newRefresh);
    _storeValue('refresh', newRefresh);
    notifyListeners();
  }
}

class StateProvider extends ChangeNotifier {
  bool? _rankNoti, _dueNoti, _chatNoti;

  void _storeBool(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  void _setRank(bool newRank) => _rankNoti = newRank;
  void _setDue(bool newDue) => _dueNoti = newDue;
  void _setChat(bool newChat) => _chatNoti = newChat;

  void setStoreRank(bool newRank) {
    _setRank(newRank);
    _storeBool('rank', newRank);
    notifyListeners();
  }

  void setStoreDue(bool newDue) {
    _setDue(newDue);
    _storeBool('due', newDue);
    notifyListeners();
  }

  void setStoreChat(bool newChat) {
    _setChat(newChat);
    _storeBool('chat', newChat);
    notifyListeners();
  }
}
