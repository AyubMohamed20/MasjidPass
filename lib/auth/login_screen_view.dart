import 'package:flutter/material.dart';
import 'package:widget_view/widget_view.dart';
import 'login_screen_controller.dart';
import 'login_screen_widget.dart';

class LoginPageView extends StatefulWidgetView<LoginPage, LoginPageController> {
  const LoginPageView(LoginPageController controller) : super(controller);

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: Form(
            key: controller.form,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: ListView(
              padding: const EdgeInsets.all(30),
              children: [
                const BuildLabel(),
                const BuildText(),
                BuildUsername(
                  controller: controller,
                ),
                const SizedBox(height: 16),
                BuildPassword(
                  controller: controller,
                ),
                const SizedBox(height: 32),
                BuildSubmit(
                  controller: controller,
                ),
              ],
            ),
          ),
        ),
      );
}
