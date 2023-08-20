import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:bin_got/providers/fcm_provider.dart';

@pragma('vm:entry-point')
void onNotificationTapped(NotificationResponse notificationResponse) {
  final payload = notificationResponse.payload;
  print('페이로드 : $payload');

  //! 페이로드에 따른 페이지 이동 로직 추가 필요
}

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
      payload: message.data['page']);
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
            payload: message.data['page']);
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
