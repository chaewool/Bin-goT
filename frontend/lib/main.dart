import 'package:bin_got/dl_settings.dart';
import 'package:bin_got/fcm_settings.dart';
import 'package:bin_got/pages/intro_page.dart';
import 'package:bin_got/providers/root_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

int? groupId;
int? isPublic;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // .env 파일 불러오기
  await dotenv.load(fileName: '.env');

  // 카카오 sdk 초기화
  KakaoSdk.init(nativeAppKey: dotenv.env['appKey']);

  // firebase 초기화
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FCM().setup();
  DynamicLink().setup();

  //* 외부 링크를 통해 앱에 들어올 경우
  // final PendingDynamicLinkData? initialLink =
  //     await FirebaseDynamicLinks.instance.getInitialLink();
  // print('initial link => $initialLink');

  // if (initialLink != null) {
  //   final Uri deepLink = initialLink.link;
  //   print('deep link => $deepLink');
  //   toOtherPage(context as BuildContext,
  //       page: const InputPassword(
  //         isPublic: true,
  //         groupId: 2,
  //         needCheck: true,
  //       ))();
  // }

  //* 앱이 실행 중인 경우
  // FirebaseDynamicLinks.instance.onLink.listen(
  //   (pendingDynamicLinkData) {
  //     print(pendingDynamicLinkData);
  //     // Set up the `onLink` event listener next as it may be received here
  //     final Uri deepLink = pendingDynamicLinkData.link;
  //     print(deepLink);
  //     // Example of using the dynamic link to push the user to a different screen
  //     toOtherPage(context as BuildContext,
  //         page: const Intro(
  //           isPublic: true,
  //           groupId: 2,
  //         ))();
  //   },
  // );

  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => NotiProvider()),
        ChangeNotifierProvider(create: (_) => GlobalGroupProvider()),
        ChangeNotifierProvider(create: (_) => GlobalBingoProvider()),
        ChangeNotifierProvider(create: (_) => GlobalScrollProvider()),
      ],
      child: MaterialApp(
        home: const Intro(),
        theme: ThemeData(
          fontFamily: 'RIDIBatang',
        ),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('ko'),
        ],
      ),
    );
  }
}
