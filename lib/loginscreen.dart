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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
            // ignore: prefer_const_constructors
            padding: EdgeInsets.all(60),
            child: ListView(
              children: <Widget>[
                // ignore: duplicate_ignore
                Container(
                  child: Image(
                    image: AssetImage('assets/mosqueicon.png'),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  // ignore: prefer_const_constructors
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'MasjidPass',
                    style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.w500,
                        fontSize: 30),
                  ),
                ),

                Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'Sign in',
                      style: TextStyle(fontSize: 20),
                    )),
                Container(
                  height: 60.0,
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'User Name',
                    ),
                  ),
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
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: ElevatedButton(
                      child: Text('Login'),
                      onPressed: _loginPressed,
                    )),
              ],
            )));
  }

  void _loginPressed() {
    _navigateToSettings();
  }
}

/*
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    

    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(appTitle),
        ),
        body: const MyCustomForm(),
      ),
    );
  }
}

// Create a Form widget.
class MyCustomForm extends StatefulWidget {
  const MyCustomForm({Key? key}) : super(key: key);

  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}


class MyCustomFormState extends State<MyCustomForm> {
 
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            // The validator receives the text that the user has entered.
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              if (value  || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: () {
                // Validate returns true if the form is valid, or false otherwise.
                if (_formKey.currentState!.validate()) {
                  //NEED DATABASE FOR THIS//
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Processing Data')),
                  );
                }
              },
              child: const Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }
}
*/