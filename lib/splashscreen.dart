import 'package:flutter/material.dart';
import 'package:masjid_pass/main.dart';
import 'package:masjid_pass/settingspage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
 void initState(){
    super.initState();
    _navigateToSettings();
}

  _navigateToSettings()async{
    await Future.delayed(Duration(milliseconds: 1500));
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context)=> SettingsPage(
                title: "MasjidPass Scanner",
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Text('splashscreen', style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold
            )
          ),
        ),
      ),
    );
  }
}
