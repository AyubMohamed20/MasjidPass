import 'package:flutter/material.dart';
import 'package:masjid_pass/setting_page/settings_page_controller.dart';
import 'package:masjid_pass/setting_page/settings_page_widgets.dart';
import 'package:masjid_pass/utilities/screen_size_config.dart';
import 'package:widget_view/widget_view.dart';

class SettingsPageView
    extends StatefulWidgetView<SettingsPage, SettingsPageController> {
  const SettingsPageView(SettingsPageController controller, {Key? key})
      : super(controller, key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(controller.context);
    return Scaffold(
        key: controller.scaffoldKey,
        backgroundColor: Colors.white,
        appBar: null,
        drawerEnableOpenDragGesture: false,
        drawer: InfoSideBanner(
          controller: controller,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            if (controller.scannerMode == 1) const TestingModeBanner(),
            Expanded(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  SizedBox(
                    width: SizeConfig.blockSizeVertical * 12.5,
                    height: SizeConfig.blockSizeVertical * 5.56,
                    child: LogoutButton(controller: controller),
                  ),
                  SizedBox(
                    width: SizeConfig.screenWidth -
                        (SizeConfig.screenHeight / 4) -
                        60,
                  ),
                  SizedBox(
                    width: SizeConfig.blockSizeVertical * 12.5,
                    height: SizeConfig.blockSizeVertical * 5.56,
                    child: InfoButton(controller: controller),
                  )
                ],
              ),
            ),
            Expanded(
              flex: 10,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const OrganizationName(),
                  Container(
                      margin: const EdgeInsets.only(
                          top: 10, left: 20, right: 20, bottom: 10),
                      child: IgnorePointer(
                        ignoring: controller.disableButtons,
                        child: Row(children: <Widget>[
                          const SelectDoorText(text: 'Select Door'),
                          SelectDoorDropDown(controller: controller)
                        ]),
                      )),
                  Container(
                      margin: EdgeInsets.only(
                          top: 10,
                          left: 20,
                          right: SizeConfig.blockSizeVertical * 5,
                          bottom: 10),
                      child: IgnorePointer(
                        ignoring: controller.disableButtons,
                        child: Row(children: <Widget>[
                          const SelectDoorText(text: 'Select Direction'),
                          DirectionSwitch(
                            controller: controller,
                          )
                        ]),
                      )),
                  SizedBox(
                    height: SizeConfig.blockSizeVertical * 5,
                    child: IgnorePointer(
                      ignoring: controller.disableButtons,
                      child: const SelectEventButton(),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                margin: const EdgeInsets.all(10),
                child: IgnorePointer(
                  ignoring: controller.disableButtons,
                  child: Row(
                    children: [
                      ScanButton(controller: controller),
                    ],
                  ),
                ),
              ),
            )
          ],
        ));
  }
}

class InfoButton extends StatelessWidget {
  const InfoButton({Key? key, required this.controller}) : super(key: key);
  final SettingsPageController controller;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        controller.infoButtonOnPressed();
      },
      icon: Icon(
        Icons.info,
        size: SizeConfig.blockSizeVertical * 2,
      ),
      label: Text('Info',
          style: TextStyle(fontSize: SizeConfig.blockSizeVertical * 2)),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
      ),
    );
  }
}
