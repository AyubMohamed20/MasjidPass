// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:masjid_pass/settingspage.dart';

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
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    10,
                    10,
                    0,
                    0,
                  ),
                  child: TextFormField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), labelText: 'User Name'),
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
                      onPressed: validate,
                      child: Text('Login'),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /* Container(
                  height: 50.0,
                  padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                  child: Form(
                      child: Column(children: <Widget>[
                    TextFormField(
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'User Name'))
                  ])),
                ),
                Container(
                  height: 50.0,
                  padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                  child: TextField(
                    obscureText: true,
                    controller: passwordController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                    ),
                  ),
                ),
                Container(
                    height: 50,
                    padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                    child: ElevatedButton(
                      child: Text('Login'),
                      onPressed: _loginPressed,
                    )),
                             ],
            )));
       
  }*/
  void _loginPressed() {
    _navigateToSettings();
  }
}
