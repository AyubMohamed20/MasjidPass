import 'package:flutter/material.dart';
import 'package:masjid_pass/setting_page/settings_page_controller.dart';
import 'package:masjid_pass/utilities/screen_size_config.dart';
import 'package:masjid_pass/utilities/shared_preferences/user_shared_preferences.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:widget_view/widget_view.dart';

import '../auth/loginscreen.dart';

class SettingsPageView
    extends StatefulWidgetView<SettingsPage, SettingsPageController> {
  SettingsPageView(SettingsPageController controller, {Key? key})
      : super(controller, key: key);

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // TODO: Check if this Value should be hard coded
  String organizationName = "SNMC Mosque";

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(controller.context);
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        appBar: null,
        drawerEnableOpenDragGesture: false,
        drawer: infoSideBanner(),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            if (controller.scannerMode == 1) testingModeBanner(),
            Expanded(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  SizedBox(
                    width: SizeConfig.blockSizeVertical * 12.5,
                    height: SizeConfig.blockSizeVertical * 5.56,
                    child: logoutButton(),
                  ),
                  SizedBox(
                    width: SizeConfig.screenWidth -
                        (SizeConfig.screenHeight / 4) -
                        60,
                  ),
                  SizedBox(
                    width: SizeConfig.blockSizeVertical * 12.5,
                    height: SizeConfig.blockSizeVertical * 5.56,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        //_getDeviceDetails();
                        _scaffoldKey.currentState!.openDrawer();
                        controller.scanner_clicked = 0;
                      },
                      icon: Icon(
                        Icons.info,
                        size: SizeConfig.blockSizeVertical * 2,
                      ),
                      label: Text('Info',
                          style: TextStyle(
                              fontSize: SizeConfig.blockSizeVertical * 2)),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.black),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              flex: 10,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(right: 10, left: 10),
                    child: FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Text(organizationName,
                          style: TextStyle(
                              color: Colors.lightBlue,
                              fontSize: SizeConfig.blockSizeVertical * 3.33)),
                    ),
                  ),
                  Container(
                      margin: const EdgeInsets.only(
                          top: 10, left: 20, right: 20, bottom: 10),
                      child: IgnorePointer(
                        ignoring: controller.disableButtons,
                        child: Row(children: <Widget>[
                          Expanded(
                              child: Text("Select Door",
                                  style: TextStyle(
                                      fontSize: SizeConfig.blockSizeVertical *
                                          2.22))),
                          DropdownButton<String>(
                            value: controller.entrance,
                            icon: Icon(Icons.arrow_downward,
                                size: SizeConfig.blockSizeVertical * 3.33),
                            iconSize: 24,
                            elevation: 16,
                            style: const TextStyle(color: Colors.black),
                            underline: Container(
                              height: 2,
                              color: Colors.black,
                            ),
                            onChanged: (String? newValue) {
                              controller.entrancesDropDownOnChanged(newValue);
                            },
                            items: controller.organizationEntrances
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value,
                                    style: TextStyle(
                                        fontSize: SizeConfig.blockSizeVertical *
                                            2.22)),
                              );
                            }).toList(),
                          )
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
                          Expanded(
                              child: Text("Select Direction",
                                  style: TextStyle(
                                      fontSize: SizeConfig.blockSizeVertical *
                                          2.22))),
                          Column(
                            children: [
                              SizedBox(
                                child: Transform.scale(
                                  // TODO: Check if value will work * 0.2,
                                  scale: SizeConfig.blockSizeVertical * 0.2,
                                  child: Switch(
                                    onChanged: (controller.toggleSwitch),
                                    value: controller.isSwitched,
                                    activeTrackColor: Colors.blue,
                                    activeColor: Colors.blueAccent,
                                  ),
                                ),
                              ),
                              Text(
                                controller.switchText,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: controller.switchTextColor,
                                    fontSize: SizeConfig.blockSizeVertical * 2),
                              ),
                            ],
                          )
                        ]),
                      )),
                  SizedBox(
                    height: SizeConfig.blockSizeVertical * 5,
                    child: IgnorePointer(
                      ignoring: controller.disableButtons,
                      child: ElevatedButton(
                        onPressed: () {
                          controller.selectEventsOnPressed();
                        },
                        child: Text(
                          'Select Event',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: SizeConfig.blockSizeVertical * 2.5),
                        ),
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.blue),
                        ),
                      ),
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
                      Expanded(
                          child: ElevatedButton(
                        onPressed: () {
                          controller.ScanButtonOnPressed();
                        },
                        child: Text(
                          'Scan',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: SizeConfig.blockSizeVertical * 2.5),
                        ),
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.blue),
                        ),
                      )),
                    ],
                  ),
                ),
              ),
            )
          ],
        ));
  }

  Widget infoSideBanner() {
    return Drawer(
      child: ListView(
        children: [
          ListTile(
            title: const Center(
              child: Text(
                'MasjidPass',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
            ),
            onTap: () => null,
          ),
          const ListTile(
            title: Center(
              child: Text(
                'System Information',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          ListTile(
            title: const Text(
              'Device ID',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(controller.identifier),
            onTap: () => { controller.DeviceIdOnTap(),},
          ),
          const Divider(
            thickness: 2,
          ),
          ListTile(
            title: const Text(
              'Scanner Version',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text('3.0'),
            // TODO: Implement the scanner clicker
            onTap: () => {
             controller.scannerVersionOnTap(),
            },
          ),
          const Divider(
            thickness: 2,
          ),
          ListTile(
            title: const Text(
              'Authentication API Version',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text('1.0'),
            onTap: () => null,
          ),
          const Divider(
            thickness: 2,
          ),
          ListTile(
            title: const Text(
              'Backend API Version',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text('1.0'),
            onTap: () => null,
          ),
          const Divider(
            thickness: 2,
          ),
        ], //children
      ),
    );
  }

  Widget testingModeBanner() {
    return FittedBox(
      child: Container(
        width: SizeConfig.screenWidth,
        margin: const EdgeInsets.only(top: 50),
        color: Colors.red,
        child: Center(
          child: Text('Testing Mode',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: SizeConfig.blockSizeVertical * 2)),
        ),
      ),
    );
  }

  Widget logoutButton() {
    return ElevatedButton(
      onPressed: () => showDialog<String>(
        context: controller.context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Confirmation'),
          content: const Text('Are you sure you want to logout?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                UserSharedPreferences.resetSharedPreferences();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
              },
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
      child: Text('Logout',
          style: TextStyle(fontSize: SizeConfig.blockSizeVertical * 2)),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
      ),
    );
  }

  Widget scannerClick() {
    return AlertDialog(
      title: const Center(child: Text('Scanner Mode')),
      content: Center(
        heightFactor: 1,
        widthFactor: 2,
        child: ToggleSwitch(
          initialLabelIndex: controller.scannerMode,
          totalSwitches: 2,
          labels: const ['Product', 'Test'],
          onToggle: (index) => controller.scannerModeSwitchOnToggle(index),
        ),
      ),
    );
  }
}

