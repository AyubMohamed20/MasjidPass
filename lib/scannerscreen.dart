import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:masjid_pass/settingspage.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage>
    with SingleTickerProviderStateMixin {
  List<Widget> criticalErrorMessagesBubbles = [SizedBox(height: 20,)];

  String messageText = "Initial Text";
  String uploadPercentageText = "100%";
  String savedVisitLogsNumberText = "30/50";

  bool hasMessage = false;
  bool hasCriticalErrorMessage = false;
  bool visitLogUploadTimeoutMessage = false;

  bool hasIndicator = false;
  bool errorIndicator = false;
  bool warningIndicator = false;
  bool offlineSuccessIndicator = false;
  bool successIndicator = false;

  bool scanHistoryFlag = false;
  int currentState = 0;
  int numCase = 0;

  // Temporary for showcasing All messages and Indicator
  bool hasProgressIndicator = false;
  bool hasSavedScansIndicator = false;

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
        backgroundColor: const Color.fromRGBO(116, 178, 196, 1),
        appBar: null,
        body: Stack(
          children: [
            QRScanner(),
            ScanHistory(),
            if (hasIndicator ||
                hasMessage ||
                hasProgressIndicator ||
                hasSavedScansIndicator)
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: const Color(0x00000000).withOpacity(.8),
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 30,
                    ),
                    if (hasMessage) showMessage(),
                    Center(
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 100,
                          ),
                          if (hasIndicator) OutcomeIndicator(),
                          if (hasProgressIndicator) progressIndicator(),
                          if (hasSavedScansIndicator) SavedScansIndicator(),
                          const SizedBox(
                            height: 50,
                          ),
                          if ((errorIndicator || warningIndicator) &&
                              hasIndicator)
                            OverrideButton(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            showcaseIndicators(),
          ],
        ));
  }

  Widget CriticalErrorMessage() {
    return Bubble(
      alignment: Alignment.center,
      color: Colors.red,
      margin: const BubbleEdges.all(10),
      child: Text(
        messageText,
        style: TextStyle(color: Colors.white,fontSize: MediaQuery.of(context).size.width / 28 ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget SettingPageNavigationButton() {
    return Container(
      width: double.infinity,
      height: 40,
      margin: const EdgeInsets.all(10),
      child: ElevatedButton(
        onPressed: () {
          _navigateToSettingsPage();
        },
        child: Text('SETTINGS',
            style:
                TextStyle(fontSize: MediaQuery.of(context).size.height / 50)),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
        ),
      ),
    );
  }

  Widget ScanHistory() {

    double drawerHeight = MediaQuery.of(context).size.height / 3.7;

    Widget _icon_up = Icon(Icons.keyboard_arrow_up,
        size: MediaQuery.of(context).size.height / 30);
    Widget _icon_down = Icon(Icons.keyboard_arrow_down,
        size: MediaQuery.of(context).size.height / 30);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height/ 3.1,
          child: Stack(
            children: <Widget>[
              if (hasCriticalErrorMessage) CriticalErrorMessage(),
              AnimatedPositioned(
                width: MediaQuery.of(context).size.width,
                height: scanHistoryFlag ? drawerHeight : 40,
                top: scanHistoryFlag ? 40 : drawerHeight,
                duration: const Duration(seconds: 1),
                curve: Curves.fastOutSlowIn,
                child: Container(
                  color: Colors.blueGrey,
                  child: ListView.builder(
                    itemCount: criticalErrorMessagesBubbles.length,
                    itemBuilder: (BuildContext context, int index) {
                      return criticalErrorMessagesBubbles[index];
                    },
                  ),
                ),
              ),
              AnimatedPositioned(
                width: MediaQuery.of(context).size.width,
                height: 40,
                top: scanHistoryFlag ? 40 : drawerHeight,
                duration: const Duration(seconds: 1),
                curve: Curves.fastOutSlowIn,
                child: ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      scanHistoryFlag = !scanHistoryFlag;
                    });
                  },
                  label: Text(
                    'SCAN HISTORY',
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height / 50),
                  ),
                  icon: scanHistoryFlag ? _icon_down : _icon_up,
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.lightBlue),
                    alignment: Alignment.centerLeft,
                  ),
                ),
              ),
            ],
          ),
        ),
        SettingPageNavigationButton()
      ],
    );
  }

  Widget showMessage() {
    Color messageColor = Colors.black;

    if (errorIndicator) {
      messageColor = Colors.red;
    } else if (warningIndicator) {
      messageColor = Colors.amberAccent;
    } else if (offlineSuccessIndicator) {
      messageColor = Colors.lightGreen;
    } else if (visitLogUploadTimeoutMessage) {
      messageColor = Colors.lightBlue;
    }

    return Container(
      color: messageColor,
      padding: EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Icon(
              Icons.priority_high_rounded,
              color: Colors.white,
              size: MediaQuery.of(context).size.height / 30,
            ),
          ),
          Flexible(
              child: Text(messageText,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).size.height / 50)))
        ],
      ),
    );
  }

  Widget QRScanner() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: Colors.white,
      child: const FittedBox(child: Icon(Icons.qr_code_scanner)),
    );
  }

  Widget OutcomeIndicator() {
    Color indicatorColor = Colors.black;
    Widget indicatorIcon = const Icon(Icons.error_outline);
    if (errorIndicator) {
      indicatorColor = Colors.red;
      indicatorIcon = Icon(Icons.block_outlined, color: Colors.white);
    } else if (successIndicator) {
      indicatorColor = Colors.green;
      indicatorIcon = Icon(Icons.check_circle_outline, color: Colors.white);
    } else if (warningIndicator) {
      indicatorColor = Colors.amberAccent;
      indicatorIcon = Icon(Icons.error_outline, color: Colors.white);
    } else if (offlineSuccessIndicator) {
      indicatorColor = Colors.lightGreen;
      indicatorIcon = Icon(Icons.wifi_off, color: Colors.white);
    }
    return Container(
      decoration: BoxDecoration(
        color: indicatorColor,
        borderRadius: const BorderRadius.all(
          Radius.circular(40.0),
        ),
        border: Border.all(color: Colors.black),
      ),
      width: MediaQuery.of(context).size.height / 3,
      height: MediaQuery.of(context).size.height / 3,
      child: FittedBox(child: indicatorIcon),
    );
  }

  Widget progressIndicator() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(
          Radius.circular(120.0),
        ),
        border: Border.all(color: Colors.black),
      ),
      width: MediaQuery.of(context).size.height / 4,
      height: MediaQuery.of(context).size.height / 4,
      child: Container(
          color: Colors.white,
          margin: const EdgeInsets.all(50),
          child: const CircularProgressIndicator()),
    );
  }

  Widget SavedScansIndicator() {
    return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(
            Radius.circular(20.0),
          ),
          border: Border.all(color: Colors.black),
        ),
        width: MediaQuery.of(context).size.height / 2.5,
        height: MediaQuery.of(context).size.height / 4,
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const LinearProgressIndicator(
              semanticsLabel: 'Linear progress indicator',
            ),
            const SizedBox(
              height: 10,
              width: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(uploadPercentageText,
                    style: TextStyle(
                        color: Colors.lightBlue,
                        fontWeight: FontWeight.bold,
                        fontSize: MediaQuery.of(context).size.height / 50)),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 4,
                ),
                Text(savedVisitLogsNumberText,
                    style: TextStyle(
                        color: Colors.lightBlue,
                        fontWeight: FontWeight.bold,
                        fontSize: MediaQuery.of(context).size.height / 50))
              ],
            ),
            const SizedBox(
              height: 10,
              width: 10,
            ),
            Text('Uploading Saved Visit Logs...',
                style: TextStyle(
                    color: Colors.lightBlue,
                    fontWeight: FontWeight.bold,
                    fontSize: MediaQuery.of(context).size.height / 50))
          ],
        ));
  }

  Widget OverrideButton() {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 14,
      width: MediaQuery.of(context).size.height / 4,
      child: ElevatedButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    side: const BorderSide(color: Colors.black)))),
        onPressed: () {},
        child: Stack(children: <Widget>[
          // Stroked text as border.
          Text(
            'OVERRIDE',
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.height / 35,
              foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = 1
                ..color = Colors.black,
            ),
          ),
          // Solid text as fill.
          Text(
            'OVERRIDE',
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.height / 35,
              color: Colors.white,
            ),
          ),
        ]),
      ),
    );
  }

  void InitializeCriticalErrorMessagesBubbles() {
    if (criticalErrorMessagesBubbles.length < 10) {
      criticalErrorMessagesBubbles.add(Bubble(
        alignment: Alignment.center,
        color: Colors.red,
        margin: const BubbleEdges.only(top: 7.5, bottom: 7.5),
        child: Text(
          messageText,
          style: TextStyle(color: Colors.white, fontSize: MediaQuery.of(context).size.width / 29),
          textAlign: TextAlign.center,
        ),
      ));
    }
  }

  // Code to showcase all the messages and Indicators


  Widget showcaseIndicators() {
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height / 10,
          width: MediaQuery.of(context).size.width,
        ),
        ElevatedButton(
          onPressed: () {
            switch (numCase) {
              case 0:
                {
                  trueToFalse();
                  hasProgressIndicator = true;
                  numCase++;
                }
                break;

              case 1:
                {
                  messageText = "Offline Success Indicator";
                  trueToFalse();
                  hasMessage = true;
                  hasIndicator = true;
                  offlineSuccessIndicator = true;
                  numCase++;
                }
                break;

              case 2:
                {
                  trueToFalse();
                  hasSavedScansIndicator = true;
                  numCase++;
                }
                break;

              case 3:
                {
                  messageText = "Visit Log Upload Timeout Message";
                  trueToFalse();
                  hasMessage = true;
                  visitLogUploadTimeoutMessage = true;
                  numCase++;
                }
                break;

              case 4:
                {
                  messageText = "Success Indicator";
                  trueToFalse();
                  successIndicator = true;
                  hasIndicator = true;
                  numCase++;
                }
                break;

              case 5:
                {
                  messageText = "Warning Indicator";
                  trueToFalse();
                  hasMessage = true;
                  hasIndicator = true;
                  warningIndicator = true;
                  numCase++;
                }
                break;
              case 6:
                {
                  messageText = "Error Indicator";
                  trueToFalse();
                  hasMessage = true;
                  hasIndicator = true;
                  errorIndicator = true;
                  numCase++;
                }
                break;
              case 7:
                {
                  messageText =
                      "This visitor has already been scanned.\nVisitor ID: 89f4ffe4-26dd-11ec-9621-0242ac130002";
                  trueToFalse();
                  InitializeCriticalErrorMessagesBubbles();
                  hasCriticalErrorMessage = true;
                  numCase++;
                }
                break;
              default:
                {
                  numCase = 0;
                  trueToFalse();
                }
                break;
            }
            setState(() {});
          },
          child: const Text(
            "Indicators",
            style: TextStyle(fontSize: 10),
          ),
        ),
      ],
    );
  }

  void trueToFalse() {
    hasMessage = false;
    hasCriticalErrorMessage = false;
    hasIndicator = false;
    errorIndicator = false;
    warningIndicator = false;
    offlineSuccessIndicator = false;
    successIndicator = false;
    visitLogUploadTimeoutMessage = false;
    hasProgressIndicator = false;
    hasSavedScansIndicator = false;
  }
}
