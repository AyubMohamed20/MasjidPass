import 'package:flutter/material.dart';
import 'package:masjid_pass/setting_page/settings_page_controller.dart';
import 'package:masjid_pass/utilities/shared_preferences/user_shared_preferences.dart';
import '../auth/loginscreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToPage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(color: Color.fromRGBO(116, 178, 196, 1)),
          ),
          Column(
            children: <Widget>[
              Expanded(
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Spacer(flex: 6),
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 50.0,
                        child: Icon(
                          Icons.qr_code_scanner,
                          color: Colors.black87,
                          size: 50.0,
                        ),
                      ),

                      Spacer(flex: 1),
                      Text(
                        "Masjid Check-in Scanner",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 24.0),
                      ),

                      Spacer(flex: 1),
                      //CircularProgressIndicator(),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(),
                    Padding(
                      padding: EdgeInsets.only(top: 20.0),
                    ),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  /// If the user is already logged in, it navigates to the Settings page; otherwise, it navigates to the login screen.
  _navigateToPage() async {
    await Future.delayed(Duration(milliseconds: 4000));

    if (UserSharedPreferences.getUserLoggedIn() ?? false) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => const SettingsPage(
                    title: "Settings Page",
                  )));
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
    }
  }
}
