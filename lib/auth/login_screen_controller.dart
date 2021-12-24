import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:masjid_pass/setting_page/settings_page_controller.dart';
import 'package:masjid_pass/utilities/logging.dart';
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

  var log = logger(LoginPage);

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
    log.i('Navigating to SettingsPage');
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
    log.i('locationPermission() - Requesting Location Permission');
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      log.w('Location services are disabled');
      snackBarMessage = 'Location services are disabled';
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        log.w('Location permission denied');
        snackBarMessage = 'Location permission denied';
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      log.w('Location permissions are permanently denied');
      snackBarMessage =
          'Location permissions are permanently denied - Please enable permission in your phones settings';
      return false;
    }

    return true;
  }

  ///simple login functionality with DB using dummy data.
  Future<bool> getLogin(String user, String password) async {
    log.i('getLogin() - Verifying if the username and password are correct');

    final db = await MasjidDatabase.instance.database;

    final result = await db.query(
      tableUsers,
      where: '${UserFields.username} = ? and ${UserFields.password} = ?',
      whereArgs: [user, password],
    );

    if (result.length > 0) {
      return true;
    }

    return false;
  }

  ///Function to add user using dummy data in order to validate it
  Future<void> addUser() async {
    log.i('addUser() - Adding a test user to MasjidDatabase');
    final testUser =
        const User(username: 'test', password: '1234', organizationId: 11);
    await MasjidDatabase.instance.create(testUser);
  }

  Future<void> buildSubmitOnClicked() async {
    log.i('buildSubmitOnClicked() - Login Button Pressed');
    Color snackBarColor = Colors.red;
    bool? requestLocation = false;
    final isValid = form.currentState!.validate();

    if (isValid) {
      log.v('Form is Valid');
      addUser();
      form.currentState!.save();
    } else {
      log.v('Form is invalid - Username or Password are empty');
    }

    bool? validLogin = await getLogin(username, password);

    if (validLogin) {
      log.v('User entered an valid Username or Password');
      requestLocation = await locationPermission();
      if (requestLocation) {
        log.v('Location Permission Granted');
        snackBarMessage = 'Login Successful';
        snackBarColor = Colors.green;
      }
    } else {
      log.v('User entered an Invalid Username or Password');
      snackBarMessage = 'Invalid Username or Password';
    }

    showSnackBar(snackBarColor);

    if (validLogin && requestLocation) {
      await UserSharedPreferences.setUserLoggedIn(true);
      _navigateToSettings();
    }
  }

  void buildUsernameOnSaved(String value) {
    log.i('buildUsernameOnSaved() - Username saved');
    username = value;
  }

  void buildPasswordOnSaved(String value) {
    log.i('buildPasswordOnSaved() - Password saved');
    password = value;
  }

  void showSnackBar(Color snackBarColor) {
    log.i('showSnackBar() - Create and Display Snack Bar');
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
