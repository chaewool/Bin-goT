import 'package:bin_got/models/group_model.dart';
import 'package:bin_got/utilities/type_def_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

//* token, user data
class AuthProvider with ChangeNotifier, DiagnosticableTreeMixin {
  static String? _token, _refresh;
  static int? _id;

  String? get token => _token;
  String? get refresh => _refresh;
  int? get id => _id;

  void debugFillProperites(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('token', token));
    properties.add(StringProperty('refresh', refresh));
  }
  //* private

  void _setToken(String? newToken) => _token = newToken;
  void _setRefresh(String? newRefresh) => _refresh = newRefresh;
  void _setId(int? newId) => _id = newId;
  void _storeValue(String key, dynamic value) {
    const storage = FlutterSecureStorage();
    storage.write(key: key, value: value.toString());
  }

  dynamic _readStorage() async {
    const storage = FlutterSecureStorage();
    final userInfo = await storage.readAll();
    return userInfo;
  }

  //* public
  FutureBool initVar() async {
    final userInfo = await _readStorage();
    print('initVar: $userInfo');
    if (userInfo != null) {
      _setToken(userInfo!['token']);
      _setRefresh(userInfo!['refresh']);
      _setId(int.parse(userInfo['id']));
      notifyListeners();
    }
    return true;
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

  void setStoreId(int newId) {
    _setId(newId);
    _storeValue('id', newId);
    notifyListeners();
  }

  void deleteVar() {
    const storage = FlutterSecureStorage();
    storage.deleteAll();
    _setToken(null);
    _setRefresh(null);
    _setId(null);
  }
}

//* notification
class NotiProvider extends ChangeNotifier {
  static bool _rankNoti = true;
  static bool _dueNoti = true;
  static bool _chatNoti = true;

  //* getter
  bool get rankNoti => _rankNoti;
  bool get dueNoti => _dueNoti;
  bool get chatNoti => _chatNoti;

  //* private
  FutureBool initNoti() async {
    final prefs = await SharedPreferences.getInstance();
    _setRank(prefs.getBool('rank') ?? true);
    _setDue(prefs.getBool('due') ?? true);
    _setChat(prefs.getBool('chat') ?? true);
    return Future.value(true);
  }

  void _storeBool(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  void _setRank(bool newVal) => _rankNoti = newVal;
  void _setDue(bool newVal) => _dueNoti = newVal;
  void _setChat(bool newVal) => _chatNoti = newVal;

  //* public
  void setStoreRank(bool newRank) {
    _setRank(newRank);
    _storeBool('rank', newRank);
    notifyListeners();
  }

  void setStoreDue(bool newDue) async {
    _setDue(newDue);
    _storeBool('due', newDue);
    notifyListeners();
  }

  void setStoreChat(bool newChat) {
    _setChat(newChat);
    _storeBool('chat', newChat);
    notifyListeners();
  }

  void deleteVar() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
    _setChat(true);
    _setDue(true);
    _setRank(true);
  }
}

//* group data
class GlobalGroupProvider extends ChangeNotifier {
  static GroupDetailModel? _data;
  static int? _groupId;

  int? get count => _data?.count;
  int? get headCount => _data?.headCount;
  int? get groupId => _groupId;
  String? get start => _data?.start;
  String? get groupName => _data?.groupName;
  String? get description => _data?.description;
  String? get rule => _data?.rule;
  bool? get hasImage => _data?.hasImage;
  int? get bingoSize => _data?.bingoSize;
  bool? get needAuth => _data?.needAuth;

  void _setData(GroupDetailModel detailModel) => _data = detailModel;

  // void _setCount(int newVal) => _count = newVal;
  // void _setStart(String newVal) => _start = newVal;
  // void _setHeadCount(int newVal) => _headCount = newVal;
  // void _setGroupName(String newVal) => _groupName = newVal;
  // void _setDescription(String newVal) => _description = newVal;
  // void _setRule(String newVal) => _rule = newVal;
  // void _setHasImage(bool newVal) => _hasImage = newVal;
  void _setGroupId(int newVal) => _groupId = newVal;
  // void _setNeedAuth(bool newVal) => _needAuth = newVal;

  void setData(GroupDetailModel detailModel) {
    _setData(detailModel);
    notifyListeners();
  }

  // void setCount(int newVal) {
  //   _setCount(newVal);
  //   notifyListeners();
  // }

  // void setStart(String newVal) {
  //   _setStart(newVal);
  //   notifyListeners();
  // }

  // void setHeadCount(int newVal) {
  //   _setHeadCount(newVal);
  //   notifyListeners();
  // }

  // void setGroupName(String newVal) {
  //   _setGroupName(newVal);
  //   notifyListeners();
  // }

  // void setDescription(String newVal) {
  //   _setDescription(newVal);
  //   notifyListeners();
  // }

  // void setRule(String newVal) {
  //   _setRule(newVal);
  //   notifyListeners();
  // }

  // void setHasImage(bool newVal) {
  //   _setHasImage(newVal);
  //   notifyListeners();
  // }

  void setGroupId(int newVal) {
    _setGroupId(newVal);
    notifyListeners();
  }

  // void setNeedAuth(bool newVal) {
  //   _setNeedAuth(newVal);
  //   notifyListeners();
  // }

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

//* bingo data
class GlobalBingoProvider extends ChangeNotifier {
  static DynamicMap _data = {
    'group_id': 0,
    'title': null,
    'background': null,
    'is_black': false,
    'has_border': true,
    'has_round_edge': false,
    'around_kan': 0,
    'complete_icon': 0,
    'font': 0,
    'items': <DynamicMap>[],
  };
  // static DynamicMap _tempData = {..._data};
  static int? _bingoId;
  static bool _isCheckTheme = false;

  //* getter
  DynamicMap get data => _data;
  // DynamicMap get tempData => _tempData;
  int? get groupId => _data['group'];
  String? get title => _data['title'];
  int? get background => _data['background'];
  bool get hasBlackBox => _data['is_black'];
  bool get hasBorder => _data['has_border'];
  bool get hasRoundEdge => _data['has_round_edge'];
  int? get gap => _data['around_kan'];
  int? get checkIcon => _data['complete_icon'];
  int? get font => _data['font'];
  List get items => _data['items'];
  int? get bingoId => _bingoId;
  bool get isCheckTheme => _isCheckTheme;

  //* private
  DynamicMap _item(int index) => items[index];

  void _setIsCheckTheme(bool value) => _isCheckTheme = value;
  void _setData(DynamicMap newData) => _data = {...newData};
  // void _setTempData(DynamicMap newData) => _tempData = {...newData};
  void _setGBingoId(int newVal) => _bingoId = newVal;
  void _setOption(String key, dynamic value) => _data[key] = value;

  void _changeBackground(int i) {
    if (_data['background'] == i) {
      _data['background'] = null;
    } else {
      _data['background'] = i;
    }
  }

  void _changeData(int tabIndex, int i) {
    switch (tabIndex) {
      case 0:
        _changeBackground(i);
        break;
      case 1:
        final keyList = [
          'has_round_edge',
          'has_border',
          'is_black',
          'around_kan'
        ];
        switch (i) {
          case 3:
            _data[keyList[i]] += _data[keyList[i]] < 2 ? 1 : -2;
            break;
          default:
            _data[keyList[i]] = !_data[keyList[i]];
            break;
        }
        break;
      case 2:
        _setOption('font', i);
        break;
      default:
        _setOption('complete_icon', i);
        break;
    }
  }

  void _initItems(int cnt) {
    _data['items'] = List.generate(
      cnt,
      (_) => {
        'title': null,
        'content': null,
        'check': false,
        'check_goal': '0',
      },
    );
  }

  void _setItem(int index, DynamicMap item) {
    _data['items'][index] = {...item};
  }

  //* public
  DynamicMap item(int index) => _item(index);

  void setIsCheckTheme(bool value) {
    _setIsCheckTheme(value);
    notifyListeners();
  }

  void setItem(int index, DynamicMap item) {
    _setItem(index, item);
    notifyListeners();
  }

  void initItems(int cnt) => _initItems(cnt);

  void changeData(int tabIndex, int i) {
    _changeData(tabIndex, i);
    notifyListeners();
  }

  void setOption(String key, dynamic value) => _setOption(key, value);
  void setData(DynamicMap data) => _setData(data);
  // void setTempData(DynamicMap data) => _setTempData(data);

  void setBingoId(int newVal) {
    _setGBingoId(newVal);
    notifyListeners();
  }

  // void setNeedAuth(bool newVal) {
  //   _setNeedAuth(newVal);
  //   notifyListeners();
  // }

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