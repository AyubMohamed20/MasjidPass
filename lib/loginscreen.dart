import 'package:flutter/material.dart';
import 'package:masjid_pass/db/masjid_database.dart';
import 'package:masjid_pass/settingspage.dart';

import 'models/user.dart';

//sourced from https://flutterawesome.com/a-simple-login-example-using-only-textfields-and-texteditingcontrollers/

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _LoginPageState();
}

// Used for controlling whether the user is loggin or creating an account
enum FormType { login, register }

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailFilter = new TextEditingController();
  final TextEditingController _passwordFilter = new TextEditingController();
  String _email = "";
  String _password = "";
  FormType _form = FormType
      .login; // our default setting is to login, and we should switch to creating an account when the user chooses to

  _LoginPageState() {
    _emailFilter.addListener(_emailListen);
    _passwordFilter.addListener(_passwordListen);
  }

  void _emailListen() {
    if (_emailFilter.text.isEmpty) {
      _email = "";
    } else {
      _email = _emailFilter.text;
    }
  }

  void _passwordListen() {
    if (_passwordFilter.text.isEmpty) {
      _password = "";
    } else {
      _password = _passwordFilter.text;
    }
  }

  // Swap in between our two forms, registering and logging in
  void _formChange() async {
    setState(() {
      if (_form == FormType.register) {
        _form = FormType.login;
      } else {
        _form = FormType.register;
      }
    });
  }

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
    return new Scaffold(
      backgroundColor: Color.fromRGBO(116, 178, 196, 1),
      //appBar: _buildBar(context),
      body: new Container(
        padding: EdgeInsets.all(16.0),
        child: new Column(
          children: <Widget>[
            _buildTextFields(),
            _buildButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildBar(BuildContext context) {
    return new AppBar(
      title: new Text("Simple Login Example"),
      centerTitle: true,
    );
  }

  Widget _buildTextFields() {
    return new Container(
      child: new Column(
        children: <Widget>[
          new Container(
            child: new TextField(
              controller: _emailFilter,
              decoration: new InputDecoration(labelText: 'Email'),
            ),
          ),
          new Container(
            child: new TextField(
              controller: _passwordFilter,
              decoration: new InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildButtons() {
    if (_form == FormType.login) {
      return new Container(
        child: new Column(
          children: <Widget>[
            new ElevatedButton(
              child: new Text('Login'),
              onPressed: _loginPressed,
            ),
            new TextButton(
              style: TextButton.styleFrom(
                primary: Colors.white,
              ),
              child: new Text('Dont have an account? Tap here to register.'),
              onPressed: _formChange,
            ),
            new TextButton(
              style: TextButton.styleFrom(
                primary: Colors.white,
              ),
              child: new Text('Forgot Password?'),
              onPressed: _passwordReset,
            )
          ],
        ),
      );
    } else {
      return new Container(
        child: new Column(
          children: <Widget>[
            new ElevatedButton(
              child: new Text('Create an Account'),
              onPressed: _createAccountPressed,
            ),
            new TextButton(
              style: TextButton.styleFrom(
                primary: Colors.white,
              ),
              child: new Text('Have an account? Click here to login.'),
              onPressed: _formChange,
            )
          ],
        ),
      );
    }
  }

  // These functions can self contain any user auth logic required, they all have access to _email and _password

  Future<void> _loginPressed() async {
    print('The user wants to login with $_email and $_password');
    bool? validLogin = await getLogin(_email, _password);
    if(validLogin == true){
      //TODO add success message
      //TODO build function that saves the user data in shared preferences
      print('its valid');//placeholder for testing
      _navigateToSettings();
    }else{
      //TODO add error message
      print('its NOT valid');//placeholder for testing
    }
  }

  ///simple login functionality with DB using dummy data.
  Future<bool> getLogin(String user, String password) async {

    final db = await MasjidDatabase.instance.database;
    final result = await db.query(tableUsers,
      where: '${UserFields.username} = ? and ${UserFields.password} = ?',
      whereArgs: [user, password],
    );

    if (result.length > 0){
      print('successful query was $result');
      return true;
    }
    return false;
  }

  void _createAccountPressed() {
    print('The user wants to create an accoutn with $_email and $_password');
  }

  void _passwordReset() {
    print("The user wants a password reset request sent to $_email");
  }
}
