import 'package:shared_preferences/shared_preferences.dart';

import '../logging.dart';

class UserSharedPreferences {
  static SharedPreferences? preferences;

  static var log = logger(UserSharedPreferences);

  static const _keyEntrance = 'Entrance';
  static const _keySwitch = 'Switch';
  static const _keyScannerMode = 'Scanner Mode';
  static const _keyInternetAvailability = 'Internet Availability';
  static const _keyEventSelected = 'Event Selected';
  static const _keyLoggedIn = 'Logged In';

  static Future init() async {
    log.i('Initialize Shared Preferences');
    return preferences = await SharedPreferences.getInstance();
  }

  // Scanner Mode - Stores whether the app is in testing mode or production mode
  static setScannerMode(int scannerMode) async {
    log.i('Set Shared Preference - ScannerMode');
    return await preferences!.setInt(_keyScannerMode, scannerMode);
  }

  static getScannerMode() {
    log.i('Get Shared Preference - ScannerMode');
    return preferences!.getInt(_keyScannerMode);
  }

  // Organization Entrances - Stores whether or not doors are fetched
  static setEntrance(String entrance) async {
    log.i('Set Shared Preference - Entrance');
    return await preferences!.setString(_keyEntrance, entrance);
  }

  static getEntrance() {
    log.i('Get Shared Preference - Entrance');
    return preferences!.getString(_keyEntrance);
  }

  // Switch - Stores whether or not switch is ON(entering) or OFF(exiting)
  static setSwitch(bool isSwitched) async {
    log.i('Set Shared Preference - Switch');
    return await preferences!.setBool(_keySwitch, isSwitched);
  }

  static getSwitch() {
    log.i('Get Shared Preference - Switch');
    return preferences!.getBool(_keySwitch);
  }

  // User Logged In - Stores whether or not the user is logged in
  static setUserLoggedIn(bool loggedIn) async {
    log.i('Set Shared Preference - UserLoggedIn');
    return await preferences!.setBool(_keyLoggedIn, loggedIn);
  }

  static getUserLoggedIn() {
    log.i('Get Shared Preference - UserLoggedIn');
    return preferences!.getBool(_keyLoggedIn);
  }

  // Internet Availability - Stores whether or not the internet is available
  static setInternetAvailability(bool internetAvailability) async {
    log.i('Set Shared Preference - InternetAvailability');
    return await preferences!
        .setBool(_keyInternetAvailability, internetAvailability);
  }

  static getInternetAvailability() {
    log.i('Get Shared Preference - InternetAvailability');
    return preferences!.getBool(_keyInternetAvailability);
  }

  // Event Selected - Stores whether or not events are fetched for today
  static setEventSelected(bool eventSelected) async {
    log.i('Set Shared Preference - EventSelected');
    return await preferences!.setBool(_keyEventSelected, eventSelected);
  }

  static getEventSelected() {
    log.i('Get Shared Preference - EventSelected');
    return preferences!.getBool(_keyEventSelected);
  }

  static resetSharedPreferences() async {
    log.i('Resetting Shared Preference');
    await UserSharedPreferences.setUserLoggedIn(false);
    await UserSharedPreferences.setSwitch(false);
    await UserSharedPreferences.setEntrance('Mens');
    await UserSharedPreferences.setInternetAvailability(false);
    await UserSharedPreferences.setEventSelected(false);
  }
}
