import 'package:bin_got/models/bingo_model.dart';
import 'package:bin_got/models/group_model.dart';
import 'package:bin_got/models/user_info_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

//? 타입 정의

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
typedef StringMap = Map<String, String>;

//* api
typedef DynamicMap = Map<String, dynamic>;
typedef DynamicMapList = List<DynamicMap>;
typedef DynamicResponse = Response<dynamic>;
typedef FutureList = Future<List>;
typedef FutureInt = Future<int>;
typedef FutureDynamic = Future<dynamic>;
typedef FutureDynamicMap = Future<DynamicMap>;
typedef FutureVoid = Future<void>;
typedef FutureBool = Future<bool>;
typedef FutureStringNull = Future<String?>;

//* group api
typedef MyGroupList = List<MyGroupModel>;
typedef MyBingoList = List<MyBingoModel>;
typedef RankList = List<GroupRankModel>;
typedef GroupMemberList = List<GroupMemberModel>;
typedef GroupChatList = List<GroupChatModel>;

//* bingo api
typedef BingoItemList = List<BingoItemModel>;

//* user api
typedef BadgeList = List<BadgeModel>;
