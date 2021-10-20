// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:masjid_pass/settingspage.dart';
import 'package:form_field_validator/form_field_validator.dart';

void main() {
  runApp(MaterialApp(
    home: LoginPage(),
  ));
}

// ignore: use_key_in_widget_constructors
class LoginPage extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<LoginPage> {
  GlobalKey<FormState> form = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  _navigateToSettings() async {
    await Future.delayed(Duration(milliseconds: 500));
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => SettingsPage(
                  title: "Settings Page",
                )));
  }

  void validate() {
    if (form.currentState!.validate()) {
      //  validate ()=>logingPressed();
    } else {
      print("Not validated");
    }
  }

  String validation(value) {
    if (value!.isEmpty) {
      return "Required";
    } else {
      return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(30),
        child: Center(
          child: Form(
            autovalidateMode: AutovalidateMode.always,
            key: form,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: Text(
                    "Masjid Check-in Scanner",
                    textAlign: TextAlign.center,
                    textScaleFactor: 2.0,
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
                Container(
                  child: Icon(
                    Icons.qr_code_scanner,
                    color: Colors.blue,
                    size: 100.0,
                  ),
                ),
                Flexible(
                  flex: 2,
                  child: TextFormField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), labelText: 'User Name'),
                    validator: validation,
                  ),
                ),
                Flexible(
                  flex: 2,
                  child: TextFormField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), labelText: 'Password'),
                    validator: validation,
                  ),
                ),
                Padding(
                    padding: EdgeInsets.fromLTRB(
                      10,
                      10,
                      0,
                      0,
                    ),
                    child: ElevatedButton(
                      onPressed:
                          showAlertDialog(context), //validate,//loginPressed,
                      child: Text('Login'),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget remindButton = TextButton(
      child: Text("While using the App"),
      onPressed: () {},
    );
    Widget cancelButton = TextButton(
      child: Text("Only this time"),
      onPressed: () {},
    );
    Widget launchButton = TextButton(
      child: Text("Deny"),
      onPressed: () {},
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(""),
      content: Text(
          "Allow Masjid Pass Check-in Scanner to access this device's location ? "),
      actions: [
        remindButton,
        cancelButton,
        launchButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void progressIndicator() {
    CircularProgressIndicator();
    Future.delayed(const Duration(seconds: 20));
  }

  void _loginPressed() {
    _navigateToSettings();
  }
}
