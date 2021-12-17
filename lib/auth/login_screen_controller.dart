import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
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
  String _snackBarMessage = '';

  ///Sets the message for Location Service Disabled
  static const String _kLocationServicesDisabledMessage =
      'Location services are disabled.';

  ///Sets the message for Permission Denied Message
  static const String _locationPermissionMessage = 'Permission denied.';

  static String get kLocationServicesDisabledMessage =>
      _kLocationServicesDisabledMessage;

  static String get kPermissionDeniedMessage => _locationPermissionMessage;

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

  String get snackBarMessage => _snackBarMessage;

  set snackBarMessage(String value) {
    _snackBarMessage = value;
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
  Future<bool> locationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      snackBarMessage = 'Location services are disabled';
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        snackBarMessage = 'Location permission denied';
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      snackBarMessage = 'Location permissions are permanently denied - Please enable permission in your phones settings';
      return false;
    }

    return true;
  }

  ///Function to add user using dummy data in order to validate it
  Future addUser() async {
    final testUser =
        const User(username: 'test', password: '1234', organizationId: 11);

    await MasjidDatabase.instance.create(testUser);
  }

  ///simple login functionality with DB using dummy data.
  Future<bool> getLogin(String user, String password) async {
    final db = await MasjidDatabase.instance.database;
    final result = await db.query(
      tableUsers,
      where: '${UserFields.username} = ? and ${UserFields.password} = ?',
      whereArgs: [user, password],
    );

    if (result.length > 0) return true;

    return false;
  }

  void buildUsernameOnSaved(String value) {
    setState(() => username = value);
  }

  void buildPasswordOnSaved(String value) {
    setState(() => password = value);
  }

  Future<void> buildSubmitOnClicked() async {
    Color snackBarColor = Colors.red;
    bool? requestLocation = false;

    final isValid = form.currentState!.validate();
    if (isValid) {
      addUser();
      form.currentState!.save();
    }

    bool? validLogin = await getLogin(username, password);

    if (validLogin) {
      requestLocation = await locationPermission();
      if (requestLocation) {
        snackBarMessage = 'Login Successful';
        snackBarColor = Colors.green;
      }
    } else {
      snackBarMessage = 'Invalid Username or Password';
    }

    showSnackBar(snackBarColor);

    if (validLogin && requestLocation) {
      await UserSharedPreferences.setUserLoggedIn(true);
      _navigateToSettings();
    }
  }

  void showSnackBar(Color snackBarColor) {
    final snackBar = SnackBar(
      content: Text(
        snackBarMessage,
        style: const TextStyle(fontSize: 12),
      ),
      action: SnackBarAction(
        label: 'Close',
          textColor: Colors.black,
        onPressed: () {},
      ),
      backgroundColor: snackBarColor,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
