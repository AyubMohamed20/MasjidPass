import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:masjid_pass/loginscreen.dart';
import 'package:masjid_pass/scannerscreen.dart';
import 'package:masjid_pass/shared_preferences/user_shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:toggle_switch/toggle_switch.dart';

import 'db/masjid_database.dart';
import 'models/visitor.dart';

//source from https://github.com/iamshaunjp/flutter-beginners-tutorial/blob/lesson-9/myapp/lib/main.dart

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<String> OrganizationEntrances = ["Mens", "Womans", "Basement", "Gym"];
  String entrance = 'Mens';
  String organizationName = "Organization Name";
  String switchText = "OUT";
  Color switchTextColor = Colors.red;
  bool isSwitched = false;
  bool eventsSelected = false;
  bool internetAvailability = false;
  int scannerMode = 0;
  int denied_cnt = 0;
  bool _disableButtons = false;
  String device_id = 'f774690826290hd832';
  int scanner_clicked = 0;
  int mode_index = 0;
  String mode_name = 'TEST';

  final ButtonStyle style =
      ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));

  @override
  void initState() {
    super.initState();
    isSwitched = UserSharedPreferences.getSwitch() ?? false;
    isSwitched = isSwitched ? false : true;
    toggleSwitch(isSwitched);
    entrance = UserSharedPreferences.getEntrance() ?? 'Mens';
    scannerMode = UserSharedPreferences.getScannerMode() ?? 0;
    eventsSelected = UserSharedPreferences.getEventSelected() ?? false;
    internetAvailability =
        UserSharedPreferences.getInternetAvailability() ?? false;
  }

  _checkCameraPermission() async {
    var denyContext = context;
    showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
              title: const Text('Camera Permission'),
              content: const Text(
                  'Your app needs camera access to take QR scanner.'),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: const Text('Deny'),
                  onPressed: () => showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        if (denied_cnt > 0) {
                          denied_cnt = 0;
                          return AlertDialog(
                            title: const Text("Camera Permission"),
                            content: const Text(
                                "You have to go to app's settings and grant permissions manually."),
                            actions: [
                              TextButton(
                                child: const Text("OK"),
                                onPressed: () {
                                  Navigator.pop(denyContext, true);
                                  Navigator.pop(context, true);
                                },
                              )
                            ],
                          );
                        }
                        return AlertDialog(
                          title: const Text("Camera Permission"),
                          content: const Text("You denied camera access."),
                          actions: [
                            TextButton(
                              child: const Text("OK"),
                              onPressed: () {
                                denied_cnt++;
                                Navigator.pop(context, false);
                              },
                            )
                          ],
                        );
                      }),
                ),
                CupertinoDialogAction(
                    child: const Text('Grant'),
                    onPressed: () async => {
                          Navigator.pop(denyContext, true),
                          await Permission.camera.isGranted
                              ? _grantCamera()
                              : openAppSettings(),
                        }),
              ],
            ));
  }

  _delayForDisabledButtons()async{
    await Future.delayed(Duration(milliseconds: 5000),(){

      setState(() {
        _disableButtons = false;
      });

    });

  }

  _grantCamera() async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const ScannerPage(
                  title: "Scanner Page",
                )));
  }

  _navigateToScannerPage() async {
    _checkCameraPermission();
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

  ///Grabs the info for the Organization's name, the entrance, and direction
  ///and updates the Visitor entry so the information can be grabbed
  ///in the scanner page from the DB.
  addVisitInfoToDb(String switchText, String entrance,String organizationName) async{
    final db = await MasjidDatabase.instance.database;
    await db.rawUpdate('''
    UPDATE $tableVisitors 
    SET door = ?, direction = ?, organization = ?
    WHERE _id = ?
    ''',
        ['$entrance', '$switchText', '$organizationName', 1]);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        appBar: null,
        drawerEnableOpenDragGesture: false,
        drawer: infoSideBanner(),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  SizedBox(
                    width: MediaQuery.of(context).size.height / 8,
                    height: MediaQuery.of(context).size.height / 18,
                    child: logoutButton(),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width -
                        ((MediaQuery.of(context).size.height / 8) * 2) -
                        60,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.height / 8,
                    height: MediaQuery.of(context).size.height / 18,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _scaffoldKey.currentState!.openDrawer();
                        scanner_clicked = 0;
                      },
                      icon: Icon(
                        Icons.info,
                        size: MediaQuery.of(context).size.height / 50,
                      ),
                      label: Text('Info',
                          style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.height / 50)),
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
                    margin:
                    const EdgeInsets.only(right: 10, left: 10, bottom: 50),
                    child: FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Text('This is $mode_name Mode',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize:
                              MediaQuery.of(context).size.height / 30)),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 10, left: 10),
                    child: FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Text(organizationName,
                          style: TextStyle(
                              color: Colors.lightBlue,
                              fontSize:
                                  MediaQuery.of(context).size.height / 30)),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                        top: 10, left: 20, right: 20, bottom: 10),
                    child: IgnorePointer(
                      ignoring: _disableButtons,

                    child: Row(children: <Widget>[
                      Expanded(
                          child: Text("Select Door",
                              style: TextStyle(
                                  fontSize: MediaQuery.of(context).size.height /
                                      45))),
                      DropdownButton<String>(
                        value: entrance,
                        icon: Icon(Icons.arrow_downward,
                            size: MediaQuery.of(context).size.height / 30),
                        iconSize: 24,
                        elevation: 16,
                        style: const TextStyle(color: Colors.black),
                        underline: Container(
                          height: 2,
                          color: Colors.black,
                        ),
                        onChanged: (String? newValue) {
                          setState(() {
                            entrance = newValue!;
                          });
                        },
                        items:
                            OrganizationEntrances.map<DropdownMenuItem<String>>(
                                (String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value,
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.height /
                                            45)),
                          );
                        }).toList(),
                      )
                    ]),
                    )),
                  Container(
                    margin: EdgeInsets.only(
                        top: 10,
                        left: 20,
                        right: MediaQuery.of(context).size.height / 20,
                        bottom: 10),
                    child: IgnorePointer(
                      ignoring: _disableButtons,

                    child: Row(children: <Widget>[
                      Expanded(
                          child: Text("Select Direction",
                              style: TextStyle(
                                  fontSize: MediaQuery.of(context).size.height /
                                      45))),
                      Column(
                        children: [
                          SizedBox(
                            child: Transform.scale(
                              scale: MediaQuery.of(context).size.height / 500,
                              child: Switch(
                                onChanged: (toggleSwitch),
                                value: isSwitched,
                                activeTrackColor: Colors.blue,
                                activeColor: Colors.blueAccent,
                              ),
                            ),
                          ),
                          Text(
                            switchText,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: switchTextColor,
                                fontSize:
                                    MediaQuery.of(context).size.height / 50),
                          ),
                        ],
                      )
                    ]),
                    )),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 20,
                    child: IgnorePointer(
                      ignoring: _disableButtons,

                    child: ElevatedButton(
                      onPressed: () {},
                      child: Text(
                        'Select Event',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: MediaQuery.of(context).size.height / 40),
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
                  ignoring: _disableButtons,


                child: Row(
                  children: [
                    Expanded(
                        child: ElevatedButton(
                      onPressed: () async {
                        await UserSharedPreferences.setSwitch(isSwitched);
                        await UserSharedPreferences.setEntrance(entrance);
                        await UserSharedPreferences.setInternetAvailability(
                            internetAvailability);
                        _disableButtons = true;
                        addVisitInfoToDb(switchText, entrance, organizationName);
                        _delayForDisabledButtons();
                        _navigateToScannerPage();
                      },
                      child: Text(
                        'Scan',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: MediaQuery.of(context).size.height / 40),
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

  Widget logoutButton() {
    return ElevatedButton(
      onPressed: () => showDialog<String>(
        context: context,
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
                await UserSharedPreferences.setUserLoggedIn(false);
                await UserSharedPreferences.setSwitch(false);
                await UserSharedPreferences.setEntrance("Mens");
                await UserSharedPreferences.setInternetAvailability(false);
                await UserSharedPreferences.setScannerMode(0);
                await UserSharedPreferences.setEventSelected(false);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
              },
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
      child: Text('Logout',
          style: TextStyle(fontSize: MediaQuery.of(context).size.height / 50)),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
      ),
    );
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
            subtitle: Text(device_id),
            onTap: () => {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Copy Result'),
                    content: SingleChildScrollView(
                      child: ListBody(
                        children: <Widget>[
                          Text('Device ID: $device_id'),
                          const Text('You copied Device ID'),
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('Ok'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              )
            },
          ),
          const Divider(
            thickness: 2,
          ),
          ListTile(
            title: const Text(
              'Scanner Version',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text('2.8'),
            onTap: () => {_scannerClick()},
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

  _scannerClick() {
    scanner_clicked++;
    print('scanner clicked $scanner_clicked');
    if (scanner_clicked == 15)
        {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Center(child: Text('Scanner Mode')),
            content: Center(
              heightFactor: 1,
              widthFactor: 2,
              child: ToggleSwitch(
                initialLabelIndex: 0,
                totalSwitches: 3,
                labels: const ['Current', 'Product', 'Test'],
                onToggle: (index) {
                  print('switched to: $index');
                  mode_index = index;
                  _onLoading();
                },
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                  scanner_clicked = 0;
                },
              ),
            ],
          );
        },
      );
    }
  }

  void _onLoading() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const Dialog(
          child: Center(
            heightFactor: 7,
            child: CircularProgressIndicator(),
          ),
        );
      },
    );

    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pop(context); //pop dialog
      showDialog<String>(
          context: context,
          builder: (BuildContext context) => Container(
            width: 300,
            height: 300,
            child: AlertDialog(
              title: const Text('Confirmation'),
              contentPadding: const EdgeInsets.all(40.0),
              content: const Text('Are you sure you want to logout?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Cancel'),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPage())),
                  child: const Text('Logout'),
                ),
              ],
            ),
          ));
      setState(() {
        if (mode_index == 0) mode_name = 'Current';
        if (mode_index == 1) mode_name = 'Product';
        if (mode_index == 2) mode_name = 'Testing';
      });
    });
  }
}
