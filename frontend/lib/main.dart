import 'package:bin_got/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  // KakaoSdk.init(nativeAppKey: dotenv.env['nativeAppKey']);
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // home: const GroupMain(),
      home: const Intro(),
      // home: const BingoForm(),
      theme: ThemeData(
        fontFamily: 'RIDIBatang',
      ),
    );
  }
}
