import 'package:flutter/material.dart';
import 'package:masjid_pass/scannerscreen.dart';
import 'package:masjid_pass/loginscreen.dart';

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
  String dropdownValueEntrance = 'Mens';
  String OrganizationName = "Organization Name";
  String switchText = "OUT";
  Color switchTextColor = Colors.red;
  bool isSwitched = false;

  final ButtonStyle style =
      ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));

  @override
  _navigateToScannerPage() async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const ScannerPage(
                  title: "Scanner Page",
                )));
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
                    margin: const EdgeInsets.only(right: 10, left: 10),
                    child: FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Text(OrganizationName,
                          style: TextStyle(
                              color: Colors.lightBlue,
                              fontSize:
                                  MediaQuery.of(context).size.height / 30)),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                        top: 10, left: 20, right: 20, bottom: 10),
                    child: Row(children: <Widget>[
                      Expanded(
                          child: Text("Select Door",
                              style: TextStyle(
                                  fontSize: MediaQuery.of(context).size.height /
                                      45))),
                      DropdownButton<String>(
                        value: dropdownValueEntrance,
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
                            dropdownValueEntrance = newValue!;
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
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        top: 10,
                        left: 20,
                        right: MediaQuery.of(context).size.height / 20,
                        bottom: 10),
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
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 20,
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
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                margin: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    Expanded(
                        child: ElevatedButton(
                      onPressed: () {
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
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage())),
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
            subtitle: Text('f774690826290hd832'),
            onTap: () => null,
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
            onTap: () => null,
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
}
