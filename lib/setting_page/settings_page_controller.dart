import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:masjid_pass/auth/login_screen_controller.dart';
import 'package:masjid_pass/db/masjid_database.dart';
import 'package:masjid_pass/models/visitor.dart';
import 'package:masjid_pass/scanner_screeen/scanner_screen_controller.dart';
import 'package:masjid_pass/setting_page/settings_page_view.dart';
import 'package:masjid_pass/setting_page/settings_page_widgets.dart';
import 'package:masjid_pass/utilities/shared_preferences/user_shared_preferences.dart';
import 'package:toggle_switch/toggle_switch.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<SettingsPage> createState() => SettingsPageController();
}

class SettingsPageController extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) => SettingsPageView(this);

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  /// List of the organization entrances
  List<String> _organizationEntrances = ['Mens', 'Womans', 'Basement', 'Gym'];

  /// The entrances currently selected
  String _entrance = 'Mens';

  /// The flag for disabling all buttons
  bool _disableButtons = false;

  /// The setting screen IN/OUT switch
  bool _isSwitched = false;
  String _switchText = 'OUT';
  Color _switchTextColor = Colors.red;

  /// The scanner version click counter
  int scanner_clicked = 0;

  /// The scanner mode flag
  int _scannerMode = 0;

  /// The internet availability flag
  bool _internetAvailability = false;

  String _deviceName = '';
  String _deviceVersion = '';
  String _identifier = '';

  List<String> get organizationEntrances => _organizationEntrances;

  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;

  String get deviceVersion => _deviceVersion;

  set deviceVersion(String value) {
    _deviceVersion = value;
  }

  String get identifier => _identifier;

  set identifier(String value) {
    _identifier = value;
  }

  String get deviceName => _deviceName;

  set deviceName(String value) {
    _deviceName = value;
  }

  bool get internetAvailability => _internetAvailability;

  set internetAvailability(bool value) {
    _internetAvailability = value;
  }

  String get switchText => _switchText;

  set switchText(String value) {
    _switchText = value;
  }

  Color get switchTextColor => _switchTextColor;

  set switchTextColor(Color value) {
    _switchTextColor = value;
  }

  bool get isSwitched => _isSwitched;

  set isSwitched(bool value) {
    _isSwitched = value;
  }

  String get entrance => _entrance;

  set entrance(String value) {
    _entrance = value;
  }

  bool get disableButtons => _disableButtons;

  set disableButtons(bool value) {
    _disableButtons = value;
  }

  int get scannerMode => _scannerMode;

  set scannerMode(int value) {
    _scannerMode = value;
  }

  @override
  void initState() {
    super.initState();
    isSwitched = UserSharedPreferences.getSwitch() ?? false;
    isSwitched = isSwitched ? false : true;
    toggleSwitch(isSwitched);
    entrance = UserSharedPreferences.getEntrance() ?? 'Mens';
    scannerMode = UserSharedPreferences.getScannerMode() ?? 0;
    //eventsSelected = UserSharedPreferences.getEventSelected() ?? false;
    internetAvailability =
        UserSharedPreferences.getInternetAvailability() ?? false;
    _getDeviceDetails();
  }

  _navigateToScannerPage() async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const ScannerPage(
                  title: 'Scanner Page',
                )));
  }

  void entrancesDropDownOnChanged(String? newValue) {
    setState(() {
      entrance = newValue!;
    });
  }

  void toggleSwitch(bool value) {
    if (isSwitched == false) {
      setState(() {
        isSwitched = true;
        switchText = 'IN';
        switchTextColor = Colors.green;
      });
    } else {
      setState(() {
        isSwitched = false;
        switchText = 'OUT';
        switchTextColor = Colors.red;
      });
    }
  }

  Future<void> scanButtonOnPressed() async {
    await UserSharedPreferences.setSwitch(isSwitched);
    await UserSharedPreferences.setEntrance(entrance);
    await UserSharedPreferences.setInternetAvailability(internetAvailability);

    // TODO: Check if the set state here is necessary
    setState(() {
      disableButtons = true;
    });

    _navigateToScannerPage();

    // TODO: addVisitInfoToDb(switchText, entrance, organizationName) & _delayForDisabledButtons();
  }

  /// Get the Device Information
  Future<void> _getDeviceDetails() async {
    final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        var build = await deviceInfoPlugin.androidInfo;
        setState(() {
          deviceName = build.device.toString();
          deviceVersion = build.version.toString();
          identifier = build.androidId.toString();
        });
      }
    } on PlatformException {
      print('Failed to get platform version');
    }
  }

  /// Scan Version on Tap
  scannerVersionOnTap() {
    scanner_clicked++;
    if (scanner_clicked == 15) {
      scanner_clicked = 0;
      showDialog(
          context: context,
          builder: (BuildContext context) => ScannerModeSwitch(scannerMode: scannerMode, scannerModeSwitchOnToggle: scannerModeSwitchOnToggle,));
    }
    return;
  }

  Future<void> scannerModeSwitchOnToggle(int scannerModeIndex) async {
    scannerMode = scannerModeIndex;
    await UserSharedPreferences.setScannerMode(scannerMode);
    UserSharedPreferences.resetSharedPreferences();
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const LoginPage()));
  }

  deviceIdOnTap() {
    // TODO: Copy device ID to clip board
  }

  void logoutButtonOnPressed() {
    UserSharedPreferences.resetSharedPreferences();
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const LoginPage()));
  }

  void infoButtonOnPressed() {
    scaffoldKey.currentState!.openDrawer();
    scanner_clicked = 0;
  }

  ///Grabs the info for the Organization's name, the entrance, and direction
  ///and updates the Visitor entry so the information can be grabbed
  ///in the scanner page from the DB.
  addVisitInfoToDb(
      String switchText, String entrance, String organizationName) async {
    final db = await MasjidDatabase.instance.database;
    await db.rawUpdate('''
    UPDATE $tableVisitors 
    SET door = ?, direction = ?, organization = ?
    WHERE _id = ?
    ''', ['$entrance', '$switchText', '$organizationName', 1]);
  }

  // _delayForDisabledButton
  _delayForDisabledButtons() async {
    await Future.delayed(const Duration(milliseconds: 5000), () {
      setState(() {
        _disableButtons = false;
      });
    });
  }
}
