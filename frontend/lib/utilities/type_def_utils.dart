import 'package:bin_got/models/group_model.dart';
import 'package:bin_got/models/user_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

//* 기본
typedef ReturnVoid = void Function();
typedef StringList = List<String>;
typedef WidgetList = List<Widget>;
typedef IntList = List<int>;
typedef FuncList = List<ReturnVoid>;
typedef BoxShadowList = List<BoxShadow>;
typedef ImageList = List<Image>;
typedef BoolList = List<bool>;
typedef IconDataList = List<IconData>;

//* api 관련
typedef DynamicMap = Map<String, dynamic>;
typedef DynamicMapList = List<DynamicMap>;
typedef DynamicResponse = Response<dynamic>;

typedef MyGroupList = List<MyGroupModel>;
typedef GroupList = List<GroupModel>;
typedef FutureList = Future<List>;
typedef FutureInt = Future<int>;
typedef FutureDynamic = Future<dynamic>;
typedef FutureDynamicMap = Future<DynamicMap>;
typedef FutureVoid = Future<void>;
