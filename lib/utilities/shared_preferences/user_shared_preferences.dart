import 'package:shared_preferences/shared_preferences.dart';

class UserSharedPreferences {
  static SharedPreferences? preferences;

  static const _keyEntrance = "Entrance";
  static const _keySwitch = "Switch";
  static const _keyScannerMode = "Scanner Mode";
  static const _keyInternetAvailability = "Internet Availability";
  static const _keyEventSelected = "Event Selected";
  static const _keyLoggedIn = "Logged In";

  static Future init() async =>
      preferences = await SharedPreferences.getInstance();

  // Scanner Mode - Stores whether the app is in testing mode or production mode
  static setScannerMode(int scannerMode) async =>
      await preferences!.setInt(_keyScannerMode, scannerMode);

  static getScannerMode() => preferences!.getInt(_keyScannerMode);

  // Organization Entrances - Stores whether or not doors are fetched
  static setEntrance(String entrance) async =>
      await preferences!.setString(_keyEntrance, entrance);

  static getEntrance() => preferences!.getString(_keyEntrance);

  // Switch - Stores whether or not switch is ON(entering) or OFF(exiting)
  static setSwitch(bool isSwitched) async =>
      await preferences!.setBool(_keySwitch, isSwitched);

  static getSwitch() => preferences!.getBool(_keySwitch);

  // User Logged In - Stores whether or not the user is logged in
  static setUserLoggedIn(bool loggedIn) async =>
      await preferences!.setBool(_keyLoggedIn, loggedIn);

  static getUserLoggedIn() => preferences!.getBool(_keyLoggedIn);

  // Internet Availability - Stores whether or not the internet is available
  static setInternetAvailability(bool internetAvailability) async =>
      await preferences!.setBool(_keyInternetAvailability, internetAvailability);

  static getInternetAvailability() =>
      preferences!.getBool(_keyInternetAvailability);

  // Event Selected - Stores whether or not events are fetched for today
  static setEventSelected(bool eventSelected) async =>
      await preferences!.setBool(_keyEventSelected, eventSelected);

  static getEventSelected() => preferences!.getBool(_keyEventSelected);

  static resetSharedPreferences () async {
    await UserSharedPreferences.setUserLoggedIn(false);
    await UserSharedPreferences.setSwitch(false);
    await UserSharedPreferences.setEntrance("Mens");
    await UserSharedPreferences.setInternetAvailability(false);
    await UserSharedPreferences.setEventSelected(false);
  }
}
