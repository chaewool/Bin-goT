import 'dart:convert';

import 'package:bin_got/navigator_key.dart';
import 'package:bin_got/pages/input_password_page.dart';
import 'package:bin_got/pages/main_page.dart';
import 'package:bin_got/utilities/global_func.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:bin_got/providers/fcm_provider.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  flutterLocalNotificationsPlugin.show(
      message.hashCode,
      message.data['title'],
      message.data['content'],
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'flutter_notification_high',
          'flutter_notification_title_high',
        ),
      ),
      payload: message.data['data']);
}

void onNotificationTapped(NotificationResponse notificationResponse) {
  final payload = jsonDecode(notificationResponse.payload!);
  List<String> path = payload['path'].split('/');

  final context = NavigatorKey.naviagatorState.currentContext;
  Widget page;

  if (path[0] == 'mypage') {
    // 마이페이지로 이동
    page = const Main(initialPage: 0);
  } else {
    var groupId = int.parse(path[1]);
    var isPublic = true;
    var needCheck = true;

    // setGroupId(context as BuildContext, groupId);

    if (path[2] == 'admin') {
      // 그룹 관리 페이지로 이동
      page = InputPassword(
        isPublic: isPublic,
        groupId: groupId,
        needCheck: needCheck,
        admin: true,
      );
    } else if (path[2] == 'main') {
      // 그룹 메인 페이지로 이동
      page = InputPassword(
        isPublic: isPublic,
        groupId: groupId,
        needCheck: needCheck,
      );
    } else if (path[2] == 'chat') {
      // 그룹 채팅 페이지로 이동
      page = InputPassword(
        isPublic: isPublic,
        groupId: groupId,
        needCheck: needCheck,
        initialIndex: 2,
      );
    } else if (path[2] == 'myboard') {
      // 그룹 내 내 빙고 페이지로 이동
      page = InputPassword(
        isPublic: isPublic,
        groupId: groupId,
        needCheck: needCheck,
        bingoId: int.parse(path[3]),
        initialIndex: 0,
      );

      // setBingoId(context as BuildContext, int.parse(path[3]));
    } else {
      // 그룹 랭킹 페이지로 이동
      page = InputPassword(
        isPublic: isPublic,
        groupId: groupId,
        needCheck: needCheck,
        initialIndex: 3,
      );
    }
  }

  // Navigator.push(context!, MaterialPageRoute(builder: (context) => page));
  toOtherPage(context!, page: page)();
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class FCM {
  void setup() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // 메시지를 수신할 수 있는 권한 요청(iOS 및 웹)
    await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    // 채널 생성(Android)
    AndroidNotificationChannel channelLow = const AndroidNotificationChannel(
      'flutter_notification_low', // id
      'flutter_notification_title_low', // title
      importance: Importance.low,
      showBadge: true,
    );

    AndroidNotificationChannel channelHigh = const AndroidNotificationChannel(
      'flutter_notification_high', // id
      'flutter_notification_title_high', // title
      importance: Importance.high,
    );

    // 포어그라운드 알림 설정(iOS)
    await messaging.setForegroundNotificationPresentationOptions(
      alert: false,
      badge: true,
      sound: false,
    );

    // 알림 설정
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channelLow);

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channelHigh);

    const android =
        AndroidInitializationSettings('@drawable/ic_notifications_icon');
    const iOS = DarwinInitializationSettings();
    const initSettings = InitializationSettings(android: android, iOS: iOS);

    await flutterLocalNotificationsPlugin.initialize(initSettings,
        onDidReceiveNotificationResponse: onNotificationTapped,
        onDidReceiveBackgroundNotificationResponse: onNotificationTapped);

    // 포어그라운드 상태일 때 메시지 수신
    if (!kIsWeb) {
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        flutterLocalNotificationsPlugin.show(
            message.hashCode,
            message.data['title'],
            message.data['content'],
            NotificationDetails(
              android: AndroidNotificationDetails(
                channelLow.id,
                channelLow.name,
              ),
            ),
            payload: message.data['data']);
      });
    }

    // 백그라운드 상태일 때 메시지 수신
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    RemoteMessage? message =
        await FirebaseMessaging.instance.getInitialMessage();
    if (message != null) {
      _firebaseMessagingBackgroundHandler(message);
    }

    FirebaseMessaging.onMessageOpenedApp
        .listen(_firebaseMessagingBackgroundHandler);
  }

  // fcm 토큰 저장
  void saveFCMToken() async {
    // 기기의 등록 토큰 액세스
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    final fcmToken = await messaging.getToken();
    FCMProvider().saveFCMToken(fcmToken!);

    // 토큰이 업데이트될 때마다 서버에 저장
    messaging.onTokenRefresh.listen((fcmToken) {
      FCMProvider().saveFCMToken(fcmToken);
    }).onError((err) {
      print('error => $err');
      throw Error();
    });
  }
}
