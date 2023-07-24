import 'package:bin_got/fcm_settings.dart';
import 'package:bin_got/pages/input_password_page.dart';
import 'package:bin_got/pages/intro_page.dart';
import 'package:bin_got/providers/root_provider.dart';
import 'package:bin_got/utilities/global_func.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:path/path.dart';

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
  initFCM();
  final PendingDynamicLinkData? initialLink =
      await FirebaseDynamicLinks.instance.getInitialLink();

  if (initialLink != null) {
    final Uri deepLink = initialLink.link;
    print('deep link => $deepLink');
    toOtherPage(context as BuildContext,
        page: const InputPassword(isPublic: true, groupId: 2))();
  }

  FirebaseDynamicLinks.instance.onLink.listen(
    (pendingDynamicLinkData) {
      // Set up the `onLink` event listener next as it may be received here
      final Uri deepLink = pendingDynamicLinkData.link;
      // Example of using the dynamic link to push the user to a different screen
      Navigator.pushNamed(context as BuildContext, deepLink.path);
    },
  );

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
