import 'package:bin_got/utilities/type_def_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

//* token, user data
class AuthProvider with ChangeNotifier, DiagnosticableTreeMixin {
  static String? _token, _refresh;

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
    storage.write(key: key, value: value);
  }

  dynamic _readStorage() async {
    const storage = FlutterSecureStorage();
    final userInfo = await storage.readAll();
    return userInfo;
  }

  FutureBool initVar() async {
    final userInfo = await _readStorage();
    print('initVar: $userInfo');
    if (userInfo != null) {
      _setToken(userInfo!['token']);
      _setRefresh(userInfo!['refresh']);
      notifyListeners();
    }
    return true;
  }

  void setStoreToken(String? newToken) {
    _setToken(newToken);
    _storeValue('token', newToken);
    notifyListeners();
  }

  void setStoreRefresh(String? newRefresh) {
    _setRefresh(newRefresh);
    _storeValue('refresh', newRefresh);
    notifyListeners();
  }
}

//* notification
class NotiProvider extends ChangeNotifier {
  static bool? _rankNoti, _dueNoti, _chatNoti;

  void _storeBool(String key, bool? value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value != null) {
      await prefs.setBool(key, value);
    } else {
      prefs.remove(key);
    }
  }

  bool? get rankNoti => _rankNoti;
  bool? get dueNoti => _dueNoti;
  bool? get chatNoti => _chatNoti;

  void _setRank(bool? newRank) => _rankNoti = newRank;
  void _setDue(bool? newDue) => _dueNoti = newDue;
  void _setChat(bool? newChat) => _chatNoti = newChat;

  void setStoreRank(bool? newRank) {
    _setRank(newRank);
    _storeBool('rank', newRank);
    notifyListeners();
  }

  void setStoreDue(bool? newDue) {
    _setDue(newDue);
    _storeBool('due', newDue);
    notifyListeners();
  }

  void setStoreChat(bool? newChat) {
    _setChat(newChat);
    _storeBool('chat', newChat);
    notifyListeners();
  }
}

//* group data
class GlobalGroupProvider extends ChangeNotifier {
  static int? _count, _headCount;
  static String? _start, _groupName, _description, _rule;
  static bool? _hasImage;

  int? get count => _count;
  int? get headCount => _headCount;
  String? get start => _start;
  String? get groupName => _groupName;
  String? get description => _description;
  String? get rule => _rule;
  bool? get hasImage => _hasImage;

  void _setCount(int newVal) => _count = newVal;
  void _setStart(String newVal) => _start = newVal;
  void _setHeadCount(int newVal) => _headCount = newVal;
  void _setGroupName(String newVal) => _groupName = newVal;
  void _setDescription(String newVal) => _description = newVal;
  void _setRule(String newVal) => _rule = newVal;
  void _setHasImage(bool newVal) => _hasImage = newVal;

  void setCount(int newVal) {
    _setCount(newVal);
    notifyListeners();
  }

  void setStart(String newVal) {
    _setStart(newVal);
    notifyListeners();
  }

  void setHeadCount(int newVal) {
    _setHeadCount(newVal);
    notifyListeners();
  }

  void setGroupName(String newVal) {
    _setGroupName(newVal);
    notifyListeners();
  }

  void setDescription(String newVal) {
    _setDescription(newVal);
    notifyListeners();
  }

  void setRule(String newVal) {
    _setRule(newVal);
    notifyListeners();
  }

  void setHasImage(bool newVal) {
    _setHasImage(newVal);
    notifyListeners();
  }

  // void initVar() {
  //   _setCount(0);
  //   _setStart('');
  //   _setHeadCount(0);
  //   _setGroupName('');
  //   _setDescription('');
  //   _setRule('');
  //   notifyListeners();
  // }
}
