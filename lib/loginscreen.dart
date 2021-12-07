import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:masjid_pass/settingspage.dart';
import 'package:masjid_pass/shared_preferences/user_shared_preferences.dart';

import 'db/masjid_database.dart';
import 'models/user.dart';

///Main fuction to set the preferred orientation of the screen
Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MaterialApp(home: LoginPage()));
}

///Class of LoginPage creates a loginPageState
class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

///LoginPageState class
class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  GlobalKey<FormState> form = GlobalKey<FormState>();

  ///The users username
  String username = '';

  ///Sets backColor to white
  Color backColor = Colors.white;

  ///The users password
  String password = '';

  ///Sets the wrong credential string
  String wrongCreds = "Invalid Username or Password";

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

  ///function navigates to the setting's page
  _navigateToSettings() async {
    await Future.delayed(const Duration(milliseconds: 500));
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => const SettingsPage(
                  title: "Settings Page",
                )));
  }

  ///Widget builds the UI scaffold for the login screen page
  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: Form(
            key: form,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: ListView(
              padding: const EdgeInsets.all(30),
              children: [
                buildLabel(),
                buildText(),
                buildUsername(),
                const SizedBox(height: 16),
                buildPassword(),
                const SizedBox(height: 32),
                buildSubmit(),
              ],
            ),
          ),
        ),
      );

  ///Widget buildLabel sets the Icon
  Widget buildLabel() => Container(
        padding: const EdgeInsets.fromLTRB(0, 30, 0, 10),
        child: const Icon(
          Icons.qr_code_scanner,
          color: Colors.blue,
          size: 80.0,
        ),
      );

  ///Widget buildText sets the text
  Widget buildText() => Container(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
        child: const Text(
          "Masjid Check-in Scanner",
          textAlign: TextAlign.center,
          textScaleFactor: 2.0,
          style: TextStyle(
              color: Colors.blue, fontSize: 10.0, fontFamily: "Arial"),
        ),
      );

  ///Widget buildUsername sets the validation and textformfield for the username
  Widget buildUsername() => TextFormField(
        inputFormatters: [
          LengthLimitingTextInputFormatter(12),
        ],
        maxLengthEnforcement: MaxLengthEnforcement.enforced,
        decoration: const InputDecoration(
          labelText: 'Username',
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please enter a username';
          } else {
            return null;
          }
        },
        maxLength: 30,
        onSaved: (value) => setState(() => username = value!),
      );

  ///Widget buildUsername sets the validation textformfield for the password
  Widget buildPassword() => TextFormField(
        decoration: const InputDecoration(
          labelText: 'Password',
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please enter a password';
          } else {
            return null;
          }
        },
        onSaved: (value) => setState(() => password = value!),
        keyboardType: TextInputType.visiblePassword,
        obscureText: true,
      );

  ///Widget buildSubmit set the submit button functionality when it is pressed
  Widget buildSubmit() => Builder(
        builder: (context) => ButtonWidget(
            text: 'Login',
            onClicked: () async {
              _getCurrentPosition();
              //wrongCreds = "Login Succesful";
              final isValid = form.currentState!.validate();
              if (isValid) {
                addUser();
                form.currentState!.save();
                // String message = '$username$password';
              }
              bool? loginGood = await _loginPressed();
              if (loginGood == true) {
                wrongCreds = "Login Successful";
              } else if (loginGood == false) {
                wrongCreds = "Invalid Username or Password";
              }
              final snackBar = SnackBar(
                content: Text(
                  wrongCreds,
                  style: const TextStyle(fontSize: 12),
                ),
                backgroundColor: Colors.green,
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }),
      );

  ///Function to get the current position of the device using geoLocator
  Future<void> _getCurrentPosition() async {
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

  ///Function to get the login when the submit button is pressed
  Future<bool> _loginPressed() async {
    bool? validLogin = await getLogin(username, password);
    if (validLogin == true) {
      await UserSharedPreferences.setUserLoggedIn(true);
      _navigateToSettings();
      return true;
    }

    return false;
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

  ///Function to add user using dummy data in order to validate it
  Future addUser() async {
    final testUser =
        User(username: 'test', password: '1234', organizationId: 11);

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

    if (result.length > 0) {
      print('successful query was $result');
      return true;
    }

    return false;
  }
}

///Class ButtonWidget
class ButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onClicked;

  const ButtonWidget({
    required this.text,
    required this.onClicked,
    Key? key,
  }) : super(key: key);

  ///Widge build to set the elevated button (submit) when it is pressed to onClicked
  @override
  Widget build(BuildContext context) => ElevatedButton(
        child: Text(
          text,
          style: const TextStyle(fontSize: 20),
        ),
        onPressed: onClicked,
      );
}
