import 'package:bin_got/navigator_key.dart';
import 'package:bin_got/pages/input_password_page.dart';
import 'package:bin_got/utilities/global_func.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DynamicLink {
  void setup() async {
    _getInitialDynamicLink();
    _addListener();
  }

  // 포어그라운드 및 백그라운드 상태에서 Dynamic Link 수신
  void _addListener() {
    FirebaseDynamicLinks.instance.onLink.listen((pendingDynamicLinkData) {
      _toOtherPage(pendingDynamicLinkData);
    }).onError((error) {
      print(error);
    });
  }

  // 종료 상태에서 Dynamic Link 수신
  void _getInitialDynamicLink() async {
    PendingDynamicLinkData? pendingDynamicLinkData =
        await FirebaseDynamicLinks.instance.getInitialLink();

    if (pendingDynamicLinkData != null) {
      _toOtherPage(pendingDynamicLinkData);
    }
  }

  void _toOtherPage(PendingDynamicLinkData pendingDynamicLinkData) {
    final Uri deepLink = pendingDynamicLinkData.link;
    print("딥링크 출력: $deepLink");

    int groupId = int.parse(deepLink.queryParameters['groupId']!);

    Widget page = InputPassword(
        isPublic: true,
        groupId: groupId,
        needCheck: true,
      );

    final context = NavigatorKey.naviagatorState.currentContext;
    Navigator.push(context!, MaterialPageRoute(builder: (context) => page));
    // toOtherPage(context!, page: page);
  }

  Future<String> buildDynamicLink(bool isPublic, int groupId) async {
    String uriPrefix = dotenv.env['dynamicLinkPrefix']!;

    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: uriPrefix,
      link: Uri.parse('$uriPrefix/groups?groupId=$groupId&isPublic=$isPublic'),
      androidParameters:
          AndroidParameters(packageName: dotenv.env['packageName']!),
    );
    final dynamicLink =
        await FirebaseDynamicLinks.instance.buildShortLink(parameters);
    return dynamicLink.shortUrl.toString();
  }
}
