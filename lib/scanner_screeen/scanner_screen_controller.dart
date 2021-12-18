import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:masjid_pass/models/visitor.dart';
import 'package:masjid_pass/scanner_screeen/scanner_screen_view.dart';
import 'package:masjid_pass/scanner_screeen/scanner_screen_widget.dart';
import 'package:masjid_pass/setting_page/settings_page_controller.dart';
import 'package:masjid_pass/utilities/screen_size_config.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:uuid/uuid.dart';

import '../db/masjid_database.dart';
import '../models/visitor.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  ScannerPageController createState() => ScannerPageController();
}

class ScannerPageController extends State<ScannerPage> {
  @override
  Widget build(BuildContext context) => ScannerPageView(this);

  final GlobalKey _qrKey = GlobalKey(debugLabel: 'QR');
  late QRViewController QrController;
  late List<Widget> ScanHistoryBubbles;
  String _messageText = 'Initial Text';
  String _uploadPercentageText = '100%';
  String _savedVisitLogsNumberText = '30/50';
  bool _hasMessage = false;
  bool _hasScanErrorMessage = false;
  bool _visitLogUploadTimeoutMessage = false;
  bool _hasIndicator = false;
  bool _errorIndicator = false;
  bool _warningIndicator = false;
  bool _offlineSuccessIndicator = false;
  bool _successIndicator = false;
  bool _scanHistoryFlag = false;
  bool _hasProgressIndicator = false;
  bool _hasSavedScansIndicator = false;
  bool _hasCriticalErrorMessage = false;

  // Visit Info
  late String organization;
  late String door;
  late bool directionIn;
  int scannerMode = 1;

  @override
  void initState() {
    super.initState();
    // Initializes the list where the saved scans are stored on the Scanner UI
    ScanHistoryBubbles = [];
  }

  @override
  void dispose() {
    QrController.dispose();
    super.dispose();
  }

  GlobalKey get qrKey => _qrKey;

  bool get hasCriticalErrorMessage => _hasCriticalErrorMessage;

  set hasCriticalErrorMessage(bool value) {
    _hasCriticalErrorMessage = value;
  }

  bool get hasProgressIndicator => _hasProgressIndicator;

  set hasProgressIndicator(bool value) {
    _hasProgressIndicator = value;
  }

  bool get hasSavedScansIndicator => _hasSavedScansIndicator;

  set hasSavedScansIndicator(bool value) {
    _hasSavedScansIndicator = value;
  }

  bool get hasMessage => _hasMessage;

  set hasMessage(bool value) {
    _hasMessage = value;
  }

  String get uploadPercentageText => _uploadPercentageText;

  set uploadPercentageText(String value) {
    _uploadPercentageText = value;
  }

  String get savedVisitLogsNumberText => _savedVisitLogsNumberText;

  set savedVisitLogsNumberText(String value) {
    _savedVisitLogsNumberText = value;
  }

  bool get hasScanErrorMessage => _hasScanErrorMessage;

  set hasScanErrorMessage(bool value) {
    _hasScanErrorMessage = value;
  }

  bool get visitLogUploadTimeoutMessage => _visitLogUploadTimeoutMessage;

  set visitLogUploadTimeoutMessage(bool value) {
    _visitLogUploadTimeoutMessage = value;
  }

  bool get hasIndicator => _hasIndicator;

  set hasIndicator(bool value) {
    _hasIndicator = value;
  }

  bool get errorIndicator => _errorIndicator;

  set errorIndicator(bool value) {
    _errorIndicator = value;
  }

  bool get warningIndicator => _warningIndicator;

  set warningIndicator(bool value) {
    _warningIndicator = value;
  }

  bool get offlineSuccessIndicator => _offlineSuccessIndicator;

  set offlineSuccessIndicator(bool value) {
    _offlineSuccessIndicator = value;
  }

  bool get successIndicator => _successIndicator;

  set successIndicator(bool value) {
    _successIndicator = value;
  }

  bool get scanHistoryFlag => _scanHistoryFlag;

  set scanHistoryFlag(bool value) {
    _scanHistoryFlag = value;
  }

  String get messageText => _messageText;

  set messageText(String value) {
    _messageText = value;
  }

  late final AudioCache _audioCache = AudioCache(
    fixedPlayer: AudioPlayer()..setReleaseMode(ReleaseMode.STOP),
  );

  _navigateToSettingsPage() async {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => const SettingsPage(
                  title: 'Settings Page',
                )));
  }

  void onQRViewCreated(QRViewController controller) {
    this.QrController = controller;
    controller.scannedDataStream.listen((scanData) {
      controller.pauseCamera();
      IncomingScan(scanData.code.toString()).then((value) async {
        await Future.delayed(const Duration(seconds: 5));
        setFlagsToFalse();
        setState(() {});
        return controller.resumeCamera();
      });
    });
  }

  IncomingScan(String scan) async {
    bool validScan = false;
    String visitorId = '8e170c8a-58aa-11ec-bf63-0242ac130002';
    bool validUuid = Uuid.isValidUUID(fromString: scan);

    if (!validScan || !validUuid) {
      messageText = !validUuid
          ? 'ERROR: Invalid QR code - No valid UUID \n VisitorId: N/A'
          : 'ERROR: Invalid Scan \n VisitorId: $visitorId';
      hasMessage = true;
      hasIndicator = true;
      errorIndicator = true;
      initializeMessageBubbles();
      _audioCache.play('sounds/failure_notification.mp3');
    } else if (validScan) {
      messageText = 'Successful Scan: VisitorId: $visitorId';
      successIndicator = true;
      hasIndicator = true;
      initializeMessageBubbles();
      _audioCache.play('sounds/success_notification.mp3');
    }
    setState(() {});
  }
  
  void setFlagsToFalse() {
    hasMessage = false;
    hasScanErrorMessage = false;
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

  void initializeMessageBubbles() {
    // This function adds all critical error message bubbles to a list(criticalErrorMessagesBubbles), which will show in the scanner history.

    // TODO: Add - When there is 10 bubbles remove the the last one
    Color scanHistoryBubbleColor;

    if (errorIndicator || hasScanErrorMessage)
      scanHistoryBubbleColor = Colors.red;
    else if (successIndicator)
      scanHistoryBubbleColor = Colors.green;
    else if (warningIndicator)
      scanHistoryBubbleColor = Colors.amberAccent;
    else if (offlineSuccessIndicator)
      scanHistoryBubbleColor = Colors.lightGreen;
    else {
      scanHistoryBubbleColor = Colors.black;
    }

    if (ScanHistoryBubbles.isEmpty) {
      ScanHistoryBubbles.add(SizedBox(
        height: SizeConfig.blockSizeHorizontal * 6,
      ));
    }
    if (ScanHistoryBubbles.length < 11) {
      ScanHistoryBubbles.add(ScanHistoryMessagesBubbles(
          scanHistoryBubbleColor: scanHistoryBubbleColor,
          messageText: messageText));
    } else {
      ScanHistoryBubbles.removeAt(1);
      ScanHistoryBubbles.add(ScanHistoryMessagesBubbles(
          scanHistoryBubbleColor: scanHistoryBubbleColor,
          messageText: messageText));
    }
  }

  void scanHistoryDrawerOnPressed() {
    setState(() {
      scanHistoryFlag = !scanHistoryFlag;
    });
  }

  void settingPageButtonOnPressed() {
    _navigateToSettingsPage();
  }

  Future<void> showcaseIndicatorsOnPressed() async {
    messageText =
        'ERROR: This visitor has already been scanned.\n Visitor ID: 8e170c8a-58aa-11ec-bf63-0242ac130002';

    hasScanErrorMessage = true;
    initializeMessageBubbles();

    setState(() {});
    await Future.delayed(const Duration(seconds: 5));
    setFlagsToFalse();
    setState(() {});
  }

  Future<void> permissions() async {
    var cameraStatus = await Permission.camera.status;

    if (cameraStatus.isDenied) {
      messageText =
          'ERROR: Camera permissions was denied - Please enable to continue';
      hasCriticalErrorMessage = true;
    } else if (await Permission.locationWhenInUse.serviceStatus.isDisabled) {
      messageText =
          'ERROR: Location services are disabled - Please enable location services ';
      hasCriticalErrorMessage = true;
    } else if (await Permission.locationWhenInUse.isDenied) {
      messageText =
          'ERROR: Location permissions are denied - Please enable *PRECISE LOCATION* permissions';
      hasCriticalErrorMessage = true;
    } else {
      hasCriticalErrorMessage = false;
    }
    setState(() {});
  }
}
