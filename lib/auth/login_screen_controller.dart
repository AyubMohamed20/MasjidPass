import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:masjid_pass/models/login_info.dart';
import 'package:masjid_pass/setting_page/settings_page_controller.dart';
import 'package:masjid_pass/utilities/shared_preferences/user_shared_preferences.dart';

import '../db/masjid_database.dart';
import '../models/user.dart';
import 'login_screen_view.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  LoginPageController createState() => LoginPageController();
}

class LoginPageController extends State<LoginPage>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) => LoginPageView(this);

  GlobalKey<FormState> form = GlobalKey<FormState>();

  ///The users username
  String _username = '';

  ///Sets backColor to white
  Color _backColor = Colors.white;

  ///The users password
  String _password = '';

  ///Sets the wrong credential string
  String _wrongCreds = 'Invalid Username or Password';

  ///Sets the message for Permission Granted
  static const String _kPermissionGrantedMessage = 'Permission granted.';

  ///Sets the message for Location Service Disabled
  static const String _kLocationServicesDisabledMessage =
      'Location services are disabled.';

  ///Sets the message for Permission Denied Message
  static const String _kPermissionDeniedMessage = 'Permission denied.';

  ///Sets the message for PermissioN Denied Forever
  static const String _kPermissionDeniedForeverMessage =
      'Permission denied forever.';

  static String get kPermissionGrantedMessage => _kPermissionGrantedMessage;

  static String get kLocationServicesDisabledMessage =>
      _kLocationServicesDisabledMessage;

  static String get kPermissionDeniedMessage => _kPermissionDeniedMessage;

  static String get kPermissionDeniedForeverMessage =>
      _kPermissionDeniedForeverMessage;

  String get username => _username;

  set username(String value) {
    _username = value;
  }

  Color get backColor => _backColor;

  set backColor(Color value) {
    _backColor = value;
  }

  String get password => _password;

  set password(String value) {
    _password = value;
  }

  String get wrongCreds => _wrongCreds;

  set wrongCreds(String value) {
    _wrongCreds = value;
  }

  ///function navigates to the setting's page
  _navigateToSettings() async {
    await Future.delayed(const Duration(milliseconds: 500));
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => const SettingsPage(
                  title: 'Settings Page',
                )));
  }

  ///Function to get the current position of the device using geoLocator
  Future<void> getCurrentPosition() async {
    try {
      final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      final hasPermission = await _handlePermission();
      if (!hasPermission) {
        return;
      }
    } catch (e) {
      print(e);
    }
  }

  ///Function to handle the permissions for the geolocator
  Future<bool> _handlePermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      wrongCreds = _kLocationServicesDisabledMessage;
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        wrongCreds = _kPermissionDeniedMessage;
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      wrongCreds = _kPermissionDeniedForeverMessage;
      return false;
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.

    wrongCreds = _kPermissionGrantedMessage;
    return true;
  }

  ///simple login functionality with DB using dummy data.
  Future<bool> getLogin(String user, String password) async {
    final db = await MasjidDatabase.instance.database;
    final result = await db.query(
      tableUsers,
      where: '${UserFields.username} = ? and ${UserFields.password} = ?',
      whereArgs: [user,password],
    );

    if (result.length > 0) {
      print('successful query was $result');
      return true;
    }
    return false;
  }

  void buildUsernameOnSaved(String value) {
    setState(() => username = value);
  }

  void buildPasswordOnSaved(String value) {
    setState(() => password = value);
  }

  Future<void> loginOnClicked() async {
    Color snackBarColor = Colors.green;
    getCurrentPosition();

    // validates & saves the current values in the form
    if (form.currentState!.validate()) {
      form.currentState!.save();
    }

    bool? validLogin = await getLogin(username, password);


    if (validLogin == true) {
      wrongCreds = 'Login Successful';
    } else if (validLogin == false) {
      wrongCreds = 'Invalid Username or Password';
      snackBarColor = Colors.red;
    }

    final snackBar = SnackBar(
      content: Text(
        wrongCreds,
        style: const TextStyle(fontSize: 12),
      ),
      backgroundColor: snackBarColor,
    );


    if (validLogin) {
      await UserSharedPreferences.setUserLoggedIn(true);
      _navigateToSettings();
    }


    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void scannerLoginAndAuthenticate() {
    int scannerMode = UserSharedPreferences.getScannerMode();
    var loginInfo = LoginInfo(username: username, password: password);
  }
}
