import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:bubble/bubble.dart';
import 'package:masjid_pass/settingspage.dart';

//hello
class ScannerPage extends StatefulWidget {
  const ScannerPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage>
    with SingleTickerProviderStateMixin {
  final Icon _icon_up = const Icon(
    Icons.keyboard_arrow_up,
    size: 13.0,
  );

  final Icon _icon_down = const Icon(
    Icons.keyboard_arrow_down,
    size: 13.0,
  );

  bool flag = false;

  int currentState = 0;

  _navigateToSettingsPage() async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const SettingsPage(
              title: "Settings Page",
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: Color.fromRGBO(116, 178, 196, 1),
      // backgroundColor: Color.fromRGBO(116, 178, 196, 1),
        appBar: AppBar(
            title: const Text('  Scanner Page\n Capacity Count (0/10)'),
            centerTitle: true,
            backgroundColor:  Color.fromRGBO(116, 178, 196, 1)),
        body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              //Expanded(
              //  child: Image.asset(
                 // 'assets/scanner.jpeg',
                //  height: 200,
                //  width: 200,
               // ),
             // ),
              Bubble(
                alignment: Alignment.center,
                color: Colors.red,
                margin: const BubbleEdges.all(10),
                child: const Text(
                  'Please enable Location Services and enable Improve Location Accuracy.',
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    AnimatedPositioned(
                      width: MediaQuery.of(context).size.width,
                      height: flag ? 200 : 40,
                      top: flag ? 40 : 200.0,
                      duration: const Duration(seconds: 1),
                      curve: Curves.fastOutSlowIn,
                      child: Container(
                        color: Colors.grey,
                        child: ListView(
                          padding: const EdgeInsets.all(40),
                          children: [
                            Bubble(
                              alignment: Alignment.center,
                              color: Colors.red,
                              margin: const BubbleEdges.all(10),
                              child: const Text(
                                'This visitor has already been scanned.\nVisitor ID: b123456789',
                                style: TextStyle(color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Bubble(
                              alignment: Alignment.center,
                              color: Colors.red,
                              margin: const BubbleEdges.all(10),
                              child: const Text(
                                'This visitor has already been scanned.\nVisitor ID: b123456789',
                                style: TextStyle(color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Bubble(
                              alignment: Alignment.center,
                              color: Colors.red,
                              margin: const BubbleEdges.all(10),
                              child: const Text(
                                'This visitor has already been scanned.\nVisitor ID: b123456789',
                                style: TextStyle(color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Bubble(
                              alignment: Alignment.center,
                              color: Colors.red,
                              margin: const BubbleEdges.all(10),
                              child: const Text(
                                'This visitor has already been scanned.\nVisitor ID: b123456789',
                                style: TextStyle(color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    AnimatedPositioned(
                      width: MediaQuery.of(context).size.width,
                      height: 40,
                      top: flag ? 40 : 200.0,
                      duration: const Duration(seconds: 1),
                      curve: Curves.fastOutSlowIn,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            flag = !flag;
                          });
                        },
                        label: const Text(
                          'SCAN HISTORY',
                          style: TextStyle(fontSize: 13.0),
                        ),
                        icon: flag ? _icon_down : _icon_up,
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.lightBlue),
                          alignment: Alignment.centerLeft,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: double.infinity,
                    height: 40,
                    margin: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      onPressed: () {
                        _navigateToSettingsPage();
                      },
                      child: const Text('SETTINGS'),
                      style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.blue),
                      ),
                    ),
                  )),
            ]));
  }
}
