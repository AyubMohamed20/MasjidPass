import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'login_screen_controller.dart';

///Widget buildLabel sets the Icon
class BuildLabel extends StatelessWidget {
  const BuildLabel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.fromLTRB(0, 30, 0, 10),
        child: const Icon(
          Icons.qr_code_scanner,
          color: Colors.blue,
          size: 80.0,
        ),
      );
}

///Widget buildText sets the text
class BuildText extends StatelessWidget {
  const BuildText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
        child: const Text(
          'Masjid Check-in Scanner',
          textAlign: TextAlign.center,
          textScaleFactor: 2.0,
          style: TextStyle(
              color: Colors.blue, fontSize: 10.0, fontFamily: 'Arial'),
        ),
      );
}

///Widget buildUsername sets the validation and textformfield for the username
class BuildUsername extends StatelessWidget {
  const BuildUsername({Key? key, required this.controller}) : super(key: key);

  final LoginPageController controller;

  @override
  Widget build(BuildContext context) => TextFormField(
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
        onSaved: (value) => controller.buildUsernameOnSaved(value!),
      );
}

///Widget buildUsername sets the validation textformfield for the password
class BuildPassword extends StatelessWidget {
  const BuildPassword({Key? key, required this.controller}) : super(key: key);

  final LoginPageController controller;

  @override
  Widget build(BuildContext context) => TextFormField(
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
        onSaved: (value) => controller.buildPasswordOnSaved(value!),
        keyboardType: TextInputType.visiblePassword,
        obscureText: true,
      );
}

///Widget buildSubmit set the submit button functionality when it is pressed
class BuildSubmit extends StatelessWidget {
  const BuildSubmit({Key? key, required this.controller}) : super(key: key);

  final LoginPageController controller;

  @override
  Widget build(BuildContext context) => Builder(
        builder: (context) => ButtonWidget(
            text: 'Login',
            onClicked: () async {
              controller.getCurrentPosition();
              //wrongCreds = "Login Succesful";
              final isValid = controller.form.currentState!.validate();
              if (isValid) {
                controller.addUser();
                controller.form.currentState!.save();
                // String message = '$username$password';
              }
              bool? loginGood = await controller.loginPressed();
              if (loginGood == true) {
                controller.wrongCreds = 'Login Successful';
              } else if (loginGood == false) {
                controller.wrongCreds = 'Invalid Username or Password';
              }
              final snackBar = SnackBar(
                content: Text(
                  controller.wrongCreds,
                  style: const TextStyle(fontSize: 12),
                ),
                backgroundColor: Colors.green,
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }),
      );
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
