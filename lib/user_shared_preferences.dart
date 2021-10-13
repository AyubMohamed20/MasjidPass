import 'package:shared_preferences/shared_preferences.dart';

class UserSharedPreferences {
  static SharedPreferences? preferences;

  static const keyEntrance = "Entrance";
  static const keySwitch = "Switch";
  static const keyLoggedIn = "Logged In";
  static const keyInternetAvailability = "Internet Availability";
  static const keyEventSelected = "Event Selected";
  static const keyScannerMode = "Scanner Mode";

  static Future init() async =>
      preferences = await SharedPreferences.getInstance();

  // Scanner Mode - Stores whether the app is in testing mode or production mode
  static setScannerMode(int scannerMode) async =>
      await preferences!.setInt(keyScannerMode, scannerMode);

  static getScannerMode() => preferences!.getInt(keyScannerMode);

  // Organization Entrances - Stores whether or not doors are fetched
  static setEntrance(String entrance) async =>
      await preferences!.setString(keyEntrance, entrance);

  static getEntrance() => preferences!.getString(keyEntrance);

  // Switch - Stores whether or not switch is ON(entering) or OFF(exiting)
  static setSwitch(bool isSwitched) async =>
      await preferences!.setBool(keySwitch, isSwitched);

  static getSwitch() => preferences!.getBool(keySwitch);

  // User Logged In - Stores whether or not the user is logged in
  static setUserLoggedIn(bool loggedIn) async =>
      await preferences!.setBool(keyLoggedIn, loggedIn);

  static getUserLoggedIn() => preferences!.getBool(keyLoggedIn);

  // Internet Availability - Stores whether or not the internet is available
  static setInternetAvailability(bool internetAvailability) async =>
      await preferences!.setBool(keyInternetAvailability, internetAvailability);

  static getInternetAvailability() =>
      preferences!.getBool(keyInternetAvailability);

  // Event Selected - Stores whether or not events are fetched for today
  static setEventSelected(bool eventSelected) async =>
      await preferences!.setBool(keyEventSelected, eventSelected);

  static getEventSelected() => preferences!.getBool(keyEventSelected);
}
