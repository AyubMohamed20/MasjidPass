import 'package:flutter/material.dart';
import 'package:masjid_pass/scannerscreen.dart';

import 'infoslideover.dart';

//source from https://github.com/iamshaunjp/flutter-beginners-tutorial/blob/lesson-9/myapp/lib/main.dart

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String dropdownValueEntrance = 'Mens';
  String OrganizationName = 'Organization Name';
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

  _navigateToInfoPage() async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => InfoPage(
                  title: "Info Page",
                )));
  }

  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(116, 178, 196, 1),
        appBar: AppBar(
            title: Text('Settings Page'),
            centerTitle: true,
            backgroundColor: Colors.transparent),
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
                        _navigateToInfoPage();
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
                  Row(children: <Widget>[
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
                  Row(children: <Widget>[
                    Expanded(child: Text("Select Direction")),
                    Container(
                        child: Switch(
                      value: isSwitched,
                      onChanged: (value) {
                        setState(() {
                          isSwitched = value;
                          print(isSwitched);
                        });
                      },
                      activeTrackColor: Colors.blue,
                      activeColor: Colors.blueAccent,
                    ))
                  ]),
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
                      onPressed: () {},
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
