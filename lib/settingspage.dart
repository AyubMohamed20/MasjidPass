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
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String dropdownValueEntrance = 'Mens';
  String OrganizationName = 'Organization Name';
  String switchText = "OUT";
  bool isSwitched = false;

  final ButtonStyle style =
      ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));


  @override
  _navigateToScannerPage() async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ScannerPage(
                  title: "Scanner Page",
                )));
  }

  void toggleSwitch(bool value) {
    if (isSwitched == false) {
      setState(() {
        isSwitched = true;
        switchText = 'IN';
      });
    } else {
      setState(() {
        isSwitched = false;
        switchText = 'OUT';
      });
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Color.fromRGBO(116, 178, 196, 1),
        appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text('Settings Page'),
            centerTitle: true,
            backgroundColor: Colors.transparent),
        drawerEnableOpenDragGesture: false,
        drawer: Drawer(
          child: ListView(
            children: [
              ListTile(
                title: Center(
                  child: Text(
                    'MasjidPass',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                ),
                onTap: () => null,
              ),
              ListTile(
                title: Center(
                  child: Text(
                    'System Information',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              ListTile(
                title: Text(
                  'Device ID',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text('f774690826290hd832'),
                onTap: () => null,
              ),
              Divider(
                thickness: 2,
              ),
              ListTile(
                title: Text(
                  'Scanner Version',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text('2.8'),
                onTap: () => null,
              ),
              Divider(
                thickness: 2,
              ),
              ListTile(
                title: Text(
                  'Authentication API Version',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text('1.0'),
                onTap: () => null,
              ),
              Divider(
                thickness: 2,
              ),
              ListTile(
                title: Text(
                  'Backend API Version',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text('1.0'),
                onTap: () => null,
              ),
              Divider(
                thickness: 2,
              ),
            ], //children
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              flex: 10,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    child: ElevatedButton(
                      onPressed: () {},
                      child: const Text('Logout'),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.red),
                      ),
                    ),
                  ),
                  Container(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _scaffoldKey.currentState!.openDrawer();
                      },
                      icon: Icon(Icons.info),
                      label: Text('Info'),
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
              flex: 100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Text(OrganizationName),
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    child: Row(children: <Widget>[
                      Expanded(child: Text("Select Door")),
                      Container(
                        child: DropdownButton<String>(
                          value: dropdownValueEntrance,
                          icon: const Icon(Icons.arrow_downward),
                          iconSize: 24,
                          elevation: 16,
                          style: const TextStyle(color: Colors.blue),
                          underline: Container(
                            height: 2,
                            color: Colors.blueAccent,
                          ),
                          onChanged: (String? newValue) {
                            setState(() {
                              dropdownValueEntrance = newValue!;
                            });
                          },
                          items: <String>["Mens", "Womans", "Basement", "Gym"]
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      )
                    ]),
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    child: Row(children: <Widget>[
                      Expanded(child: Text("Select Direction")),
                      Column(
                        children: [
                          Container(
                              child: Switch(
                            onChanged: (toggleSwitch),
                            value: isSwitched,
                            activeTrackColor: Colors.blue,
                            activeColor: Colors.blueAccent,
                          )),
                          Text(
                            switchText,
                            style: TextStyle(fontSize: 10),
                          ),
                        ],
                      )
                    ]),
                  ),
                  Container(
                    child: ElevatedButton(
                      onPressed: () {},
                      child: const Text('Select Event'),
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
              flex: 10,
              child: Container(
                margin: EdgeInsets.all(10),
                child: Row(
                  children: [
                    Expanded(
                        child: ElevatedButton(
                      onPressed: () {_navigateToScannerPage();},
                      child: const Text('Scan'),
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
}
