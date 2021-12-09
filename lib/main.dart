import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:masjid_pass/splash_screen/splashscreen.dart';
import 'package:masjid_pass/utilities/shared_preferences/user_shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await UserSharedPreferences.init();
  preferredOrientations();
  runApp(const MyApp());
}

///function to set the preferred orientation of the screen
Future preferredOrientations() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  static final String title = 'QR Code Scanner';
  @override
  Widget build(BuildContext context) => MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(),
    );
}
