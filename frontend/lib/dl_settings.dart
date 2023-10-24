import 'package:bin_got/navigator_key.dart';
import 'package:bin_got/pages/input_password_page.dart';
import 'package:bin_got/pages/main_page.dart';
import 'package:bin_got/utilities/global_func.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DynamicLink {
  void setup() {
    _getInitialDynamicLink();
    _addListener();
  }

  // 포어그라운드 및 백그라운드 상태에서 Dynamic Link 수신
  void _addListener() {
    FirebaseDynamicLinks.instance.onLink.listen((pendingDynamicLinkData) {
      _toOtherPage(pendingDynamicLinkData);
    }).onError((_) {
      final context = NavigatorKey.naviagatorState.currentContext;
      toOtherPage(context!, page: const Main())();
    });
  }

  // 종료 상태에서 Dynamic Link 수신
  void _getInitialDynamicLink() async {
    try {
      PendingDynamicLinkData? pendingDynamicLinkData =
          await FirebaseDynamicLinks.instance.getInitialLink();

      if (pendingDynamicLinkData != null) {
        _toOtherPage(pendingDynamicLinkData);
      }
    } catch (_) {
      final context = NavigatorKey.naviagatorState.currentContext;
      toOtherPage(context!, page: const Main())();
    }
  }

  void _toOtherPage(PendingDynamicLinkData pendingDynamicLinkData) {
    try {
      final Uri deepLink = pendingDynamicLinkData.link;

      int groupId = int.parse(deepLink.queryParameters['groupId']!);

      Widget page = InputPassword(
        isPublic: true,
        groupId: groupId,
        needCheck: true,
      );

      final context = NavigatorKey.naviagatorState.currentContext;
      toOtherPage(context!, page: page)();
    } catch (_) {
      final context = NavigatorKey.naviagatorState.currentContext;
      toOtherPage(context!, page: const Main())();
    }
  }

  Future<String> buildDynamicLink(int groupId) async {
    try {
      String uriPrefix = dotenv.env['dynamicLinkPrefix']!;

      final DynamicLinkParameters parameters = DynamicLinkParameters(
        uriPrefix: uriPrefix,
        link: Uri.parse('$uriPrefix/groups?groupId=$groupId'),
        androidParameters:
            AndroidParameters(packageName: dotenv.env['packageName']!),
      );
      final dynamicLink =
          await FirebaseDynamicLinks.instance.buildShortLink(parameters);
      return dynamicLink.shortUrl.toString();
    } catch (_) {
      throw Error();
    }
  }
}
