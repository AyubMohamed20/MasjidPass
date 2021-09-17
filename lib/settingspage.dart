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
  @override

  _navigateToScannerPage()async{
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context)=> ScannerPage(
              title: "Scanner Page",
            )));
  }

  _navigateToInfoPage()async{
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context)=> InfoPage(
              title: "Info Page",
            )));
  }




  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(116, 178, 196, 1),
      appBar: AppBar(
          title: Text('Settings Page'),
          centerTitle: true,
          backgroundColor: Colors.transparent

      ),
      body: Center(
        child: new Column(
        children:  [
          ElevatedButton.icon(
            onPressed: () {
              _navigateToInfoPage();
            },
            icon: Icon(Icons.info),
            label: Text('Info'),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.black87),
            ),

          ),
          ElevatedButton(
            onPressed: () {
              _navigateToScannerPage();
            },
            child: Text('Scanner Page'),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.black87),
            ),
          ),
        ],
      ),
      ),
    );
  }
}




//  FlatButton(
//    onPressed: () {},
//    child: Text('click me again'),
//    color: Colors.amber
//  ),

