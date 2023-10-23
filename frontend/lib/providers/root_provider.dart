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

//? 전역 변수

//* token, user data
class AuthProvider with ChangeNotifier, DiagnosticableTreeMixin {
  static String? _token, _refresh;
  static int? _id;

  //* getter
  String? get token => _token;
  String? get refresh => _refresh;
  int? get id => _id;

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
  void showToast() {
    _showToast();
    notifyListeners();
  }

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
  static int? _groupId;
  static int _lastId = 0;
  static int _selectedIndex = 1;
  static String? _start, _end;
  static bool _prev = false;
  static bool _enable = true;
  static GroupDetailModel? _data;
  static final GroupChatList _chats = [];
  static final RankList _rankList = [];
  // static PageController? _pageController;
  static final StringMap _chatText = {'content': ''};

  GroupChatList get chats => _chats;
  bool get prev => _prev;

  int get selectedIndex => _selectedIndex;
  int? get lastId => _lastId;
  int? get groupId => _groupId;
  // PageController? get pageController => _pageController;
  String get chatContent => _chatText['content']!;

  //* read group
  GroupDetailModel? get data => _data;
  int? get bingoId => _data?.bingoId;
  int? get headCount => _data?.headCount;
  int? get bingoSize => _data?.bingoSize;
  int? get count => _data?.count;
  int? get memberState => _data?.memberState;
  bool get hasImage => _data?.hasImage ?? false;
  bool? get needAuth => _data?.needAuth;
  bool get enable => _enable;
  String get groupName => _data?.groupName ?? '';
  String? get start => _data?.start ?? _start;
  String? get end => _data?.end ?? _end;
  String get description => _data?.description ?? '';
  String get rule => _data?.rule ?? '';
  String? get password => _data?.password;
  List get rank => _data?.rank ?? [];
  RankList get rankList => _rankList;

  void _setData(GroupDetailModel detailModel) => _data = detailModel;

  void _setLastId(int value) => _lastId = value;

  void _setStart(String newVal) => _start = newVal;

  void _setEnd(String newVal) => _end = newVal;

  void _setGroupId(int newVal) => _groupId = newVal;

  void _addChats(GroupChatList newChats) => _chats.addAll(newChats);

  void _insertChat(GroupChatModel newChat) => _chats.insert(0, newChat);

  void _clearChat() => _chats.clear();

  void _changeIndex(int index) {
    if (index != _selectedIndex) {
      _selectedIndex = index;
      notifyListeners();
    }
  }

  void _toPrevPage(bool value) => _prev = value;

  void _initData() => _data = null;

  void _setRank(RankList value) {
    _rankList.clear();
    _rankList.addAll(value);
  }

  void _setEnable(bool value) => _enable = value;

  // void _initPage() {
  //   _pageController = PageController(initialPage: _selectedIndex);
  // }

  void _setChat(String value) {
    _chatText['content'] = value;
  }

//* public
  void setLastId(int value) => _setLastId(value);

  void setData(GroupDetailModel detailModel) {
    _setData(detailModel);
    notifyListeners();
  }

  void setPeriod(String newStart, String newEnd) {
    _setStart(newStart);
    _setEnd(newEnd);
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

  void changeIndex(int index) => _changeIndex(index);

  void toPrevPage(bool value) {
    _toPrevPage(value);
    notifyListeners();
  }

  void initData() => _initData();

  void setRank(RankList value) {
    _setRank(value);
    notifyListeners();
  }

  void setEnable(bool value) {
    _setEnable(value);
    notifyListeners();
  }

  // void initPage() => _initPage();

  void setChat(String value) => _setChat(value);
}

//* bingo data
class GlobalBingoProvider extends ChangeNotifier {
  static DynamicMap _data = {};

  static DynamicMap _formData = {
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
  GlobalKey get globalKey => _globalKey;

  int? get bingoSize => _bingoSize;
  int? get bingoId => _bingoId;
  int? get lastId => _lastId;
  int? get groupId => _data['group'];

  //* read bingo
  int? get gap => _data['around_kan'];
  int? get checkIcon => _data['complete_icon'];
  int? get font => _data['font'];
  int? get background => _data['background'];
  int get achieve =>
      _data['achieve'] != null ? (_data['achieve'] * 100).toInt() : 0;

  String? get title => _data['title'];
  String? get username => _data['username'];
  bool get hasBlackBox => _data['is_black'];
  bool get hasBorder => _data['has_border'];
  bool get hasRoundEdge => _data['has_round_edge'];
  BoolList get finished => _finished;
  List get items => _data['items'];

  //* create/update bingo
  DynamicMap get formData => _formData;
  int? get formGap => _formData['around_kan'];
  int? get formCheckIcon => _formData['complete_icon'];
  int? get formFont => _formData['font'];
  int? get formBackground => _formData['background'];
  String? get formTitle => _formData['title'];

  bool get formHasBlackBox => _formData['is_black'];
  bool get formHasBorder => _formData['has_border'];
  bool get formHasRoundEdge => _formData['has_round_edge'];
  bool get isCheckTheme => _isCheckTheme;
  List get formItems => _formData['items'];

  //* private
  DynamicMap _item(int index) => items[index];
  DynamicMap _formItem(int index) => formItems[index];

  void _setIsCheckTheme(bool value) => _isCheckTheme = value;
  void _setData(DynamicMap newData) => _data = {...newData};
  void _setBingoId(int newVal) => _bingoId = newVal;
  void _setBingoSize(int newVal) => _bingoSize = newVal;
  void _setOption(String key, dynamic value) => _formData[key] = value;

  void _changeBackground(int i) {
    if (_formData['background'] == i) {
      _formData['background'] = null;
    } else {
      _formData['background'] = i;
    }
  }

  void _setLastId(int value) => _lastId = value;

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
            _formData[keyList[i]] += _formData[keyList[i]] < 2 ? 1 : -2;
            break;
          default:
            _formData[keyList[i]] = !_formData[keyList[i]];
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
    _formData['items'] = List.generate(
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
    _formData['items'][index] = {...item};
  }

  void _changeItem(int index1, int index2) {
    final content1 = _formData['items'][index1];
    content1['item_id'] = index2;
    final content2 = _formData['items'][index2];
    content2['item_id'] = index1;
    _setItem(index1, content2);
    _setItem(index2, content1);
  }

  void _initKey() => _globalKey = GlobalKey();

  void _initFormData(editMode) {
    if (editMode) {
      _formData = Map.from(_data);
      _formData['items'] = List.from(_data['items']);
    } else {
      _formData = {
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
  }

  void _initData() => _data.clear();

  FutureBool _bingoToImage() async {
    var renderObject = _globalKey.currentContext?.findRenderObject();
    if (renderObject is RenderRepaintBoundary) {
      var boundary = renderObject;
      final image = await boundary.toImage();
      final byteData = await image.toByteData(format: ImageByteFormat.png);
      final pngBytes = byteData?.buffer.asUint8List();
      await ImageGallerySaver.saveImage(
        pngBytes!,
        name: formTitle,
        quality: 100,
      );
      return true;
    }
    return false;
  }

  //* public
  DynamicMap item(int index) => _item(index);
  DynamicMap formItem(int index) => _formItem(index);

  void setLastId(int value) => _setLastId(value);

  void initFinished(int size) =>
      _finished = List.generate(size, (index) => false);

  void setFinished(int index, bool value) => _setFinished(index, value);

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

  void initFormData(bool editMode) => _initFormData(editMode);

  void initData() => _initData();

  void initKey() => _initKey();

  void applyData() {
    _setData(_formData);
  }

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
