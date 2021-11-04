import 'package:bubble/bubble.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:masjid_pass/settingspage.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:url_launcher/url_launcher.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class SizeConfig {
  static MediaQueryData _mediaQueryData = 0 as MediaQueryData;
  static double screenWidth = 0;
  static double screenHeight = 0;
  static double blockSizeHorizontal = 0;
  static double blockSizeVertical = 0;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    blockSizeHorizontal = screenWidth / 100;
    blockSizeVertical = screenHeight / 100;
  }
}

class _ScannerPageState extends State<ScannerPage>
    with SingleTickerProviderStateMixin {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late QRViewController controller;

  List<Widget> criticalErrorMessagesBubbles = [];

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

  // Temporary for showcasing All messages and Indicator
  bool hasProgressIndicator = false;
  bool hasSavedScansIndicator = false;
  int numCase = 0;

  _navigateToSettingsPage() async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const SettingsPage(
                  title: "Settings Page",
                )));
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
        backgroundColor: const Color.fromRGBO(116, 178, 196, 1),
        appBar: null,
        body: Stack(
          children: [
            qrScannerView(),
            scanHistory(),
            if (hasIndicator ||
                hasMessage ||
                hasProgressIndicator ||
                hasSavedScansIndicator)
              Container(
                width: SizeConfig.screenWidth,
                height: SizeConfig.screenHeight,
                color: const Color(0x00000000).withOpacity(.8),
                child: Column(
                  children: [
                    SizedBox(
                      height: SizeConfig.blockSizeVertical * 3.5,
                    ),
                    if (hasMessage) showMessage(),
                    Center(
                      child: Column(
                        children: [
                          SizedBox(
                            height: SizeConfig.blockSizeVertical * 15,
                          ),
                          if (hasIndicator) outcomeIndicator(),
                          if (hasProgressIndicator) progressIndicator(),
                          if (hasSavedScansIndicator) savedScansIndicator(),
                          SizedBox(
                            height: SizeConfig.blockSizeVertical * 6,
                          ),
                          if ((errorIndicator || warningIndicator) &&
                              hasIndicator)
                            overrideButton(),
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

  Widget qrScannerView() {
    return Column(
      children: <Widget>[
        Expanded(
          flex: 5,
          child: Stack(
            children: [
              QRView(
                key: qrKey,
                onQRViewCreated: onQRViewCreated,
              ),
              Center(
                child: Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.red,
                      width: 4,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  void onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      controller.pauseCamera();
      if (await canLaunch(scanData.code)) {
        await launch(scanData.code);
        controller.resumeCamera();
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('QR Code Scan Result'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text('Barcode Type: ${describeEnum(scanData.format)}'),
                    Text('Data: ${scanData.code}'),
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
        ).then((value) => controller.resumeCamera());
      }
    });
  }

  Widget scanHistory() {
    double drawerHeightMax = SizeConfig.blockSizeVertical * 31;
    double drawerHeightMin = SizeConfig.blockSizeVertical * 6;

    Widget iconUp =
        Icon(Icons.keyboard_arrow_up, size: SizeConfig.blockSizeVertical * 3);
    Widget iconDown =
        Icon(Icons.keyboard_arrow_down, size: SizeConfig.blockSizeVertical * 3);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(
          height: SizeConfig.blockSizeVertical * 37,
          child: Stack(
            children: <Widget>[
              if (hasCriticalErrorMessage) criticalErrorMessage(),
              AnimatedPositioned(
                width: SizeConfig.screenWidth,
                height: scanHistoryFlag ? drawerHeightMax : drawerHeightMin,
                top: scanHistoryFlag ? drawerHeightMin : drawerHeightMax,
                duration: const Duration(seconds: 1),
                curve: Curves.fastOutSlowIn,
                child: Container(
                  color: Colors.white,
                  child: ListView.builder(
                    itemCount: criticalErrorMessagesBubbles.length,
                    itemBuilder: (BuildContext context, int index) {
                      return criticalErrorMessagesBubbles[index];
                    },
                  ),
                ),
              ),
              AnimatedPositioned(
                width: SizeConfig.screenWidth,
                height: SizeConfig.blockSizeVertical * 6,
                top: scanHistoryFlag ? drawerHeightMin : drawerHeightMax,
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
                    style:
                        TextStyle(fontSize: SizeConfig.blockSizeVertical * 2),
                  ),
                  icon: scanHistoryFlag ? iconDown : iconUp,
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
        settingPageNavigationButton(),
      ],
    );
  }

  Widget criticalErrorMessage() {
    return Column(
      children: [
        SizedBox(
          height: SizeConfig.blockSizeVertical * 20,
        ),
        Bubble(
          alignment: Alignment.center,
          color: Colors.red,
          margin: const BubbleEdges.all(10),
          child: Text(
            messageText,
            style: TextStyle(
                color: Colors.white,
                fontSize: SizeConfig.blockSizeHorizontal * 3.5),
            textAlign: TextAlign.center,
          ),
        ),
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
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Icon(
              Icons.priority_high_rounded,
              color: Colors.white,
              size: SizeConfig.blockSizeVertical * 3,
            ),
          ),
          Flexible(
              child: Text(messageText,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: SizeConfig.blockSizeVertical * 2)))
        ],
      ),
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
      width: SizeConfig.blockSizeVertical * 25,
      height: SizeConfig.blockSizeVertical * 25,
      child: Container(
          color: Colors.white,
          margin: const EdgeInsets.all(50),
          child: const CircularProgressIndicator()),
    );
  }

  Widget savedScansIndicator() {
    return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(
            Radius.circular(20.0),
          ),
          border: Border.all(color: Colors.black),
        ),
        width: SizeConfig.blockSizeVertical * 40,
        height: SizeConfig.blockSizeVertical * 25,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const LinearProgressIndicator(
              semanticsLabel: 'Linear progress indicator',
            ),
            SizedBox(
              height: SizeConfig.blockSizeVertical * 2,
              width: SizeConfig.blockSizeVertical * 2,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(uploadPercentageText,
                    style: TextStyle(
                        color: Colors.lightBlue,
                        fontWeight: FontWeight.bold,
                        fontSize: SizeConfig.blockSizeVertical * 2)),
                SizedBox(
                  width: SizeConfig.blockSizeHorizontal * 25,
                ),
                Text(savedVisitLogsNumberText,
                    style: TextStyle(
                        color: Colors.lightBlue,
                        fontWeight: FontWeight.bold,
                        fontSize: SizeConfig.blockSizeVertical * 2))
              ],
            ),
            SizedBox(
              height: SizeConfig.blockSizeVertical * 2,
              width: SizeConfig.blockSizeVertical * 2,
            ),
            Text('Uploading Saved Visit Logs...',
                style: TextStyle(
                    color: Colors.lightBlue,
                    fontWeight: FontWeight.bold,
                    fontSize: SizeConfig.blockSizeVertical * 2))
          ],
        ));
  }

  Widget outcomeIndicator() {
    Color indicatorColor = Colors.black;
    Widget indicatorIcon = const Icon(Icons.error_outline);
    if (errorIndicator) {
      indicatorColor = Colors.red;
      indicatorIcon = const Icon(Icons.block_outlined, color: Colors.white);
    } else if (successIndicator) {
      indicatorColor = Colors.green;
      indicatorIcon =
          const Icon(Icons.check_circle_outline, color: Colors.white);
    } else if (warningIndicator) {
      indicatorColor = Colors.amberAccent;
      indicatorIcon = const Icon(Icons.error_outline, color: Colors.white);
    } else if (offlineSuccessIndicator) {
      indicatorColor = Colors.lightGreen;
      indicatorIcon = const Icon(Icons.wifi_off, color: Colors.white);
    }
    return Container(
      decoration: BoxDecoration(
        color: indicatorColor,
        borderRadius: const BorderRadius.all(
          Radius.circular(40.0),
        ),
        border: Border.all(color: Colors.black),
      ),
      width: SizeConfig.blockSizeVertical * 33,
      height: SizeConfig.blockSizeVertical * 33,
      child: FittedBox(child: indicatorIcon),
    );
  }

  Widget overrideButton() {
    return SizedBox(
      height: SizeConfig.blockSizeVertical * 7,
      width: SizeConfig.blockSizeVertical * 25,
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
              fontSize: SizeConfig.blockSizeVertical * 2.85,
              foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = SizeConfig.blockSizeVertical * 0.2
                ..color = Colors.black,
            ),
          ),
          // Solid text as fill.
          Text(
            'OVERRIDE',
            style: TextStyle(
              fontSize: SizeConfig.blockSizeVertical * 2.85,
              color: Colors.white,
            ),
          ),
        ]),
      ),
    );
  }

  Widget settingPageNavigationButton() {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: SizeConfig.blockSizeVertical * 5.9,
          margin: EdgeInsets.all(SizeConfig.blockSizeVertical * 1.67),
          child: ElevatedButton(
            onPressed: () {
              _navigateToSettingsPage();
            },
            child: Text('SETTINGS',
                style: TextStyle(fontSize: SizeConfig.blockSizeVertical * 2)),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
            ),
          ),
        ),
      ],
    );
  }

  void initializeCriticalErrorMessagesBubbles() {
    // This function adds all critical error message bubbles to a list(criticalErrorMessagesBubbles), which will show in the scanner history.

    if (criticalErrorMessagesBubbles.isEmpty) {
      criticalErrorMessagesBubbles.add(SizedBox(
        height: SizeConfig.blockSizeHorizontal * 6,
      ));
    }
    if (criticalErrorMessagesBubbles.length < 10) {
      criticalErrorMessagesBubbles.add(Bubble(
        alignment: Alignment.center,
        color: Colors.red,
        margin: BubbleEdges.only(
            top: SizeConfig.blockSizeHorizontal * 2,
            bottom: SizeConfig.blockSizeHorizontal * 2),
        child: Text(
          messageText,
          style: TextStyle(
              color: Colors.white,
              fontSize: SizeConfig.blockSizeHorizontal * 3.4),
          textAlign: TextAlign.center,
        ),
      ));
    }
  }

  // Temporary Code to showcase all the messages and Indicators

  Widget showcaseIndicators() {
    return Column(
      children: [
        SizedBox(
          height: SizeConfig.blockSizeVertical * 10,
          width: SizeConfig.screenWidth,
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
                  initializeCriticalErrorMessagesBubbles();
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
