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
typedef MyGroupList = List<MyGroupModel>;
typedef DynamicMapList = List<DynamicMap>;
typedef GroupList = List<GroupModel>;
typedef DynamicResponse = Response<dynamic>;
