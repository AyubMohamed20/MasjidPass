import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:masjid_pass/settingspage.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MaterialApp(home: LoginPage()));
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  GlobalKey<FormState> form = GlobalKey<FormState>();
  String username = '';
  Color backColor = Colors.white;
  String password = '';
  final message2 = "";
  String wrongCreds = "";

  _navigateToSettings() async {
    await Future.delayed(const Duration(milliseconds: 500));
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => const SettingsPage(
                  title: "Settings Page",
                )));
  }

  bool credentials(value) {
    if (value != message2) {
      return false;
    } else {
      return true;
    }
  }

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

  Widget buildLabel() => Container(
        padding: const EdgeInsets.fromLTRB(0, 30, 0, 10),
        child: const Icon(
          Icons.qr_code_scanner,
          color: Colors.blue,
          size: 80.0,
        ),
      );
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
  Widget buildUsername() => TextFormField(
        inputFormatters: [
          LengthLimitingTextInputFormatter(12),
        ],
        maxLengthEnforcement: MaxLengthEnforcement.enforced,
        decoration: const InputDecoration(
          labelText: 'Username',
          border: OutlineInputBorder(),
        ),
        /*validator: (value) {
          if (value.length < 4) {
            return 'Enter at least 4 characters';
          } else {
            return null;
          }
        },
        maxLength: 30,
        */
        onSaved: (value) => setState(() => username = value!),
      );

  Widget buildPassword() => TextFormField(
        decoration: const InputDecoration(
          labelText: 'Password',
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          /*  if (value.length < 7) {
            return 'Password must be at least 7 characters long';
          } else {
            return null;
          }
          */
        },
        onSaved: (value) => setState(() => password = value!),
        keyboardType: TextInputType.visiblePassword,
        obscureText: true,
      );

  Widget buildSubmit() => Builder(
        builder: (context) => ButtonWidget(
            text: 'Login',
            onClicked: () {
              wrongCreds = "Login Succesful";
              final isValid = form.currentState!.validate();
              // FocusScope.of(context).unfocus();
              if (isValid) {
                form.currentState!.save();
                String message = '$username$password';
                if (credentials(message) == true) {
                  _loginPressed();
                } else {
                  wrongCreds = "Wrong Credentials";
                }
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
  void _loginPressed() {
    _navigateToSettings();
  }
}

class ButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onClicked;

  const ButtonWidget({
    required this.text,
    required this.onClicked,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => ElevatedButton(
        child: Text(
          text,
          style: const TextStyle(fontSize: 20),
        ),
        onPressed: onClicked,
      );
}
