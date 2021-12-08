import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:bubble/bubble.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:masjid_pass/models/visitor.dart';
import 'package:masjid_pass/utilities/screen_size_config.dart';
import 'package:masjid_pass/setting_page/settings_page_controller.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:url_launcher/url_launcher.dart';

import '../db/masjid_database.dart';
import '../models/visitor.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage>
    with SingleTickerProviderStateMixin {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late QRViewController controller;

  List<Widget> criticalErrorMessagesBubbles = [];

  String messageText = "Initial Text";
  String uploadPercentageText = "100%";
  String savedVisitLogsNumberText = "30/50";
  String saveScan = "";

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

  // Visit Info
  late String organization;
  late String door;
  late bool directionIn;
  late String scannerVersion;

  // Saved Scan List
  late List<Visitor> savedScans;

  late final AudioCache _audioCache = AudioCache(
    fixedPlayer: AudioPlayer()..setReleaseMode(ReleaseMode.STOP),
  );

  @override
  void initState() {
    super.initState();
    // Initializes the list where the saved scans are stored on the Scanner UI
    savedScans = [];
    //Get visit info from DB
    getVisitInfo();
  }

  Future<void> getVisitInfo() async {
    final db = await MasjidDatabase.instance.database;
    final result = await db.query(tableVisitors,
        where: '${VisitorFields.visitorId} = ?', whereArgs: [1]);
    Map<String, dynamic> data = json.decode(jsonEncode(result.toList()[0]));

    if (data.isNotEmpty) {
      organization = data["organization"];
      door = data["door"];
      directionIn = (data["direction"] == "IN") ? true : false;
      scannerVersion = data["scannerVersion"];
    }
  }

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
            //showcaseIndicators(),
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
        IncomingScan(scanData.code).then((value) => controller.resumeCamera());
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

    Color scanHistoryBubbleColor = Colors.black;

    if (errorIndicator || hasCriticalErrorMessage)
      scanHistoryBubbleColor = Colors.red;
    else if (successIndicator)
      scanHistoryBubbleColor = Colors.green;
    else if (warningIndicator)
      scanHistoryBubbleColor = Colors.amberAccent;
    else if (offlineSuccessIndicator)
      scanHistoryBubbleColor = Colors.lightGreen;

    if (criticalErrorMessagesBubbles.isEmpty) {
      criticalErrorMessagesBubbles.add(SizedBox(
        height: SizeConfig.blockSizeHorizontal * 6,
      ));
    }
    if (criticalErrorMessagesBubbles.length < 10) {
      criticalErrorMessagesBubbles.add(Bubble(
        alignment: Alignment.center,
        color: scanHistoryBubbleColor,
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
                  setFlagsToFalse();
                  hasProgressIndicator = true;
                  numCase++;
                }
                break;

              case 1:
                {
                  messageText = "Offline Success Indicator";
                  setFlagsToFalse();
                  hasMessage = true;
                  hasIndicator = true;
                  offlineSuccessIndicator = true;
                  numCase++;
                }
                break;

              case 2:
                {
                  setFlagsToFalse();
                  hasSavedScansIndicator = true;
                  numCase++;
                }
                break;

              case 3:
                {
                  messageText = "Visit Log Upload Timeout Message";
                  setFlagsToFalse();
                  hasMessage = true;
                  visitLogUploadTimeoutMessage = true;
                  numCase++;
                }
                break;

              case 4:
                {
                  messageText = "Success Indicator";
                  setFlagsToFalse();
                  successIndicator = true;
                  hasIndicator = true;
                  numCase++;
                }
                break;

              case 5:
                {
                  messageText = "Warning Indicator";
                  setFlagsToFalse();
                  hasMessage = true;
                  hasIndicator = true;
                  warningIndicator = true;
                  numCase++;
                }
                break;
              case 6:
                {
                  messageText = "Error Indicator";
                  setFlagsToFalse();
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
                  setFlagsToFalse();
                  initializeCriticalErrorMessagesBubbles();
                  hasCriticalErrorMessage = true;
                  numCase++;
                }
                break;
              default:
                {
                  numCase = 0;
                  setFlagsToFalse();
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

  void setFlagsToFalse() {
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

  ///Queries the DB using the eventID ,firstName, lastName of the visitor scan to the DB table. Returns true or false.

  Future<bool> validateQRWithDb(int visitorId) async {
    final db = await MasjidDatabase.instance.database;
    final result = await db.query(
      tableVisitors,
      where: '${VisitorFields.visitorId} = ?',
      whereArgs: [visitorId],
    );

    if (result.length > 0) {
      print('successful query was $result');

      return true;
    }
    return false;
  }

  IncomingScan(String scan) async {
    final visitorScan = jsonDecode(scan);
    int visitorId = visitorScan["visitorId"];

    bool? validScan = await validateQRWithDb(visitorId);
    setFlagsToFalse();

    if (validScan) {
      messageText = "Successful Scan: VisitorId: $visitorId";
      successIndicator = true;
      hasIndicator = true;
      initializeCriticalErrorMessagesBubbles();
      _audioCache.play('success_notification.mp3');
    } else if (!validScan) {
      messageText = "Invaild Scan: VisitorId: $visitorId ";
      hasMessage = true;
      hasIndicator = true;
      errorIndicator = true;
      initializeCriticalErrorMessagesBubbles();
      _audioCache.play('failure_notification.mp3');
    }
    setState(() {});
    await Future.delayed(Duration(seconds: 5));
    setFlagsToFalse();
    setState(() {});
  }
}