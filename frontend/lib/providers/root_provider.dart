import 'dart:io';
import 'dart:ui';

import 'package:bin_got/models/group_model.dart';
import 'package:bin_got/utilities/global_func.dart';
import 'package:bin_got/utilities/type_def_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';

//* token, user data
class AuthProvider with ChangeNotifier, DiagnosticableTreeMixin {
  static String? _token, _refresh;
  static int? _id;

  String? get token => _token;
  String? get refresh => _refresh;
  int? get id => _id;

  // void debugFillProperites(DiagnosticPropertiesBuilder properties) {
  //   super.debugFillProperties(properties);
  //   properties.add(StringProperty('token', token));
  //   properties.add(StringProperty('refresh', refresh));
  // }
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
    if (userInfo.isNotEmpty) {
      _setToken(userInfo?['token']);
      _setRefresh(userInfo?['refresh']);
      _setId(int.parse(userInfo?['id']));
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
  static bool _beforeExit = false;
  static bool _afterWork = false;
  static bool _spinnerState = false;
  static bool _refreshState = false;
  static String _toastString = '';

  //* getter

  bool get beforeExit => _beforeExit;
  bool get afterWork => _afterWork;
  bool get spinnerState => _spinnerState;
  bool get refreshState => _refreshState;
  String get toastString => _toastString;

  //* private

  // void _storeBool(String key, bool value) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.setBool(key, value);
  // }

  FutureBool _changePressed() {
    if (!_beforeExit) {
      _beforeExit = true;
      notifyListeners();
      afterFewSec(() {
        _beforeExit = false;
        notifyListeners();
      }, 2000);
      return Future.value(false);
    }
    return Future.value(true);
  }

  FutureBool _showToast() {
    if (!_afterWork) {
      _afterWork = true;
      notifyListeners();
      afterFewSec(() {
        _afterWork = false;
        notifyListeners();
      }, 2000);
      return Future.value(false);
    }
    return Future.value(true);
  }

  void _showSpinner(bool showState) => _spinnerState = showState;

  void _applyRefresh(bool state) => _refreshState = state;

  void _setToastString(String value) => _toastString = value;

  //* public

  FutureBool changePressed() => _changePressed();
  void showToast() => _showToast();
  void showSpinner(bool showState) => _showSpinner(showState);
  void applyRefresh(bool state) {
    _applyRefresh(state);
    notifyListeners();
  }

  void setToastString(String value) {
    _setToastString(value);
    notifyListeners();
  }
}

//* scroll
class GlobalScrollProvider extends ChangeNotifier {
  static int _lastId = 0;
  static bool _loading = true;
  static bool _working = false;
  static bool _additional = false;

  bool get loading => _loading;
  bool get working => _working;
  bool get additional => _additional;
  int? get lastId => _lastId;
  // int get page => _page;

  void setWorking(bool newVal) {
    _setWorking(newVal);
    notifyListeners();
  }

  void setAdditional(bool newVal) {
    _setAdditional(newVal);
    notifyListeners();
  }

  void setLoading(bool value) {
    _setLoading(value);
    notifyListeners();
  }

  void setLastId(int value) => _setLastId(value);

  //* private
  void _setWorking(bool newVal) => _working = newVal;
  void _setAdditional(bool newVal) => _additional = newVal;
  void _setLastId(int newVal) => _lastId = newVal;
  void _setLoading(bool value) => _loading = value;
}

//* group data
class GlobalGroupProvider extends ChangeNotifier {
  static GroupDetailModel? _data;
  static int? _groupId;
  static int _lastId = 0;
  static String? _start;
  static final GroupChatList _chats = [];
  static int _selectedIndex = 1;
  static bool _prev = false;
  static bool _enable = false;

  GroupChatList get chats => _chats;
  bool get prev => _prev;

  int get selectedIndex => _selectedIndex;
  int? get lastId => _lastId;
  int? get groupId => _groupId;

  int? get bingoId => _data?.bingoId;
  int? get headCount => _data?.headCount;
  int? get bingoSize => _data?.bingoSize;
  int? get count => _data?.count;
  int? get memberState => _data?.memberState;
  bool get hasImage => _data?.hasImage ?? false;
  bool? get needAuth => _data?.needAuth;
  bool? get alreadyStarted => _data?.start != null
      ? DateTime.now().difference(DateTime.parse(_data!.start)) >= Duration.zero
      : null;
  String get groupName => _data?.groupName ?? '';
  String? get start => _data?.start ?? _start;
  String? get end => _data?.end;
  String get description => _data?.description ?? '';
  String get rule => _data?.rule ?? '';
  String? get password => _data?.password;
  List get rank => _data?.rank ?? [];

  void _setData(GroupDetailModel detailModel) => _data = detailModel;

  void _setLastId(int value) => _lastId = value;

  void _setStart(String newVal) => _start = newVal; //* start??

  void _setGroupId(int newVal) => _groupId = newVal;

  void _addChats(GroupChatList newChats) => _chats.addAll(newChats);

  void _insertChat(GroupChatModel newChat) => _chats.insert(0, newChat);

  void _clearChat() => _chats.clear();

  void _changeIndex(int index) {
    if (index != _selectedIndex) {
      if (_enable) {
        _selectedIndex = index;
        notifyListeners();
        _enable = false;
        afterFewSec(() {
          _enable = true;
          notifyListeners();
        });
      }
    }
  }

  void _toPrevPage(bool value) => _prev = value;

//* public
  void setLastId(int value) => _setLastId(value);

  void setData(GroupDetailModel detailModel) {
    _setData(detailModel);
    notifyListeners();
  }

  void setStart(String newVal) {
    _setStart(newVal);
    notifyListeners();
  }

  void setGroupId(int newVal) {
    _setGroupId(newVal);
    notifyListeners();
  }

  void addChats(GroupChatList newChats) {
    _addChats(newChats);
    notifyListeners();
  }

  void insertChat(GroupChatModel newChat) {
    _insertChat(newChat);
    notifyListeners();
  }

  void clearChat() {
    _clearChat();
  }

  void changeIndex(int index) {
    _changeIndex(index);
    notifyListeners();
  }

  void toPrevPage(bool value) {
    _toPrevPage(value);
    notifyListeners();
  }
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

  static int? _bingoId;
  static int? _bingoSize;
  static bool _isCheckTheme = false;
  static int _lastId = 0;
  static BoolList _finished = [];

  static GlobalKey _globalKey = GlobalKey();

  //* getter
  DynamicMap get data => _data;

  int? get bingoSize => _bingoSize;

  int? get groupId => _data['group'];
  int? get gap => _data['around_kan'];
  int? get checkIcon => _data['complete_icon'];
  int? get font => _data['font'];
  int? get background => _data['background'];
  int? get bingoId => _bingoId;
  int? get lastId => _lastId;
  int get achieve =>
      _data['achieve'] != null ? (_data['achieve'] * 100).toInt() : 0;
  String? get title => _data['title'];
  String? get username => _data['username'];
  bool get hasBlackBox => _data['is_black'];
  bool get hasBorder => _data['has_border'];
  bool get hasRoundEdge => _data['has_round_edge'];
  bool get isCheckTheme => _isCheckTheme;
  BoolList get finished => _finished;
  List get items => _data['items'];
  GlobalKey get globalKey => _globalKey;

  //* private
  DynamicMap _item(int index) => items[index];

  void _setIsCheckTheme(bool value) => _isCheckTheme = value;
  void _setData(DynamicMap newData) => _data = {...newData};
  void _setBingoId(int newVal) => _bingoId = newVal;
  void _setBingoSize(int newVal) => _bingoSize = newVal;
  void _setOption(String key, dynamic value) => _data[key] = value;

  void _changeBackground(int i) {
    if (_data['background'] == i) {
      _data['background'] = null;
    } else {
      _data['background'] = i;
    }
  }

  void _setLastId(int value) => _lastId = value;

  void setLastId(int value) => _setLastId(value);

  void initFinished(int size) =>
      _finished = List.generate(size, (index) => false);

  void setFinished(int index, bool value) => _setFinished(index, value);
  void _setFinished(int index, bool value) => _finished[index] = value;

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
      (index) => {
        'item_id': index,
        'title': null,
        'content': null,
        'check': false,
        'check_goal': 2,
      },
    );
  }

  void _setItem(int index, DynamicMap item) {
    _data['items'][index] = {...item};
  }

  void _changeItem(int index1, int index2) {
    final content1 = _data['items'][index1];
    content1['item_id'] = index2;
    final content2 = _data['items'][index2];
    content2['item_id'] = index1;
    _setItem(index1, content2);
    _setItem(index2, content1);
  }

  void _initKey() {
    _globalKey = GlobalKey();
  }

  void _initData() {
    _data = {
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
  }

  FutureBool _bingoToImage() async {
    var renderObject = _globalKey.currentContext?.findRenderObject();
    if (renderObject is RenderRepaintBoundary) {
      var boundary = renderObject;
      final image = await boundary.toImage();
      final byteData = await image.toByteData(format: ImageByteFormat.png);
      final pngBytes = byteData?.buffer.asUint8List();
      await ImageGallerySaver.saveImage(
        pngBytes!,
        name: title,
      );
      print('성공!!!');
      return true;
    }
    return false;
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

  void changeItem(int index1, int index2) {
    _changeItem(index1, index2);
    notifyListeners();
  }

  void initItems(int cnt) => _initItems(cnt);

  void changeData(int tabIndex, int i) {
    _changeData(tabIndex, i);
    notifyListeners();
  }

  void setOption(String key, dynamic value) => _setOption(key, value);
  void setData(DynamicMap data) {
    _setData(data);
    notifyListeners();
  }

  void setBingoId(int newId) {
    _setBingoId(newId);
    notifyListeners();
  }

  void setBingoSize(int newSize) {
    _setBingoSize(newSize);
  }

  void initData() => _initData();

  void initKey() => _initKey();

  FutureBool bingoToImage() => _bingoToImage();

  Future<File> bingoToXFile() async {
    var renderObject = _globalKey.currentContext?.findRenderObject();
    if (renderObject is RenderRepaintBoundary) {
      var boundary = renderObject;
      final image = await boundary.toImage();
      final byteData = await image.toByteData(format: ImageByteFormat.png);
      final pngBytes = byteData?.buffer.asUint8List();

      final Directory tempDir = await getTemporaryDirectory();
      File file = await File('${tempDir.path}/img.png').create();
      file.writeAsBytesSync(pngBytes!);

      return file;
    }
    return File('');
  }
}
