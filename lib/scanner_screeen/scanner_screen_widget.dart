import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:masjid_pass/scanner_screeen/scanner_screen_controller.dart';
import 'package:masjid_pass/utilities/screen_size_config.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QrScannerView extends StatelessWidget {
  const QrScannerView({Key? key, required this.controller}) : super(key: key);

  final ScannerPageController controller;

  @override
  Widget build(BuildContext context) => Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: Stack(
              children: [
                QRView(
                  key: controller.qrKey,
                  onQRViewCreated: controller.onQRViewCreated,
                ),
                Center(
                  child: Container(
                    width: 250,
                    height: 250,
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

class ScanHistory extends StatelessWidget {
  const ScanHistory({Key? key, required this.controller}) : super(key: key);

  final ScannerPageController controller;

  @override
  Widget build(BuildContext context) {
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
              if (controller.hasCriticalErrorMessage ||
                  controller.hasScanErrorMessage)
                CriticalErrorMessage(controller: controller),
              AnimatedPositioned(
                width: SizeConfig.screenWidth,
                height: controller.scanHistoryFlag
                    ? drawerHeightMax
                    : drawerHeightMin,
                top: controller.scanHistoryFlag
                    ? drawerHeightMin
                    : drawerHeightMax,
                duration: const Duration(seconds: 1),
                curve: Curves.fastOutSlowIn,
                child: Container(
                  color: Colors.white,
                  child: ListView.builder(
                    itemCount: controller.ScanHistoryBubbles.length,
                    itemBuilder: (BuildContext context, int index) =>
                        controller.ScanHistoryBubbles[index],
                  ),
                ),
              ),
              AnimatedPositioned(
                width: SizeConfig.screenWidth,
                height: SizeConfig.blockSizeVertical * 6,
                top: controller.scanHistoryFlag
                    ? drawerHeightMin
                    : drawerHeightMax,
                duration: const Duration(seconds: 1),
                curve: Curves.fastOutSlowIn,
                child: ElevatedButton.icon(
                  onPressed: () {
                    controller.scanHistoryDrawerOnPressed();
                  },
                  label: Text(
                    'SCAN HISTORY',
                    style:
                        TextStyle(fontSize: SizeConfig.blockSizeVertical * 2),
                  ),
                  icon: controller.scanHistoryFlag ? iconDown : iconUp,
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
        // TODO: Move this into the main widget tree
        SettingPageNavigationButton(
          controller: controller,
        ),
      ],
    );
  }
}

class CriticalErrorMessage extends StatelessWidget {
  const CriticalErrorMessage({Key? key, required this.controller})
      : super(key: key);

  final ScannerPageController controller;

  @override
  Widget build(BuildContext context) => Column(
        children: [
          SizedBox(
            height: SizeConfig.blockSizeVertical * 20,
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              border: Border.all(
                color: Colors.red,
              ),
            ),
            alignment: Alignment.center,
            margin: const EdgeInsets.all(20),
            child: AutoSizeText(
              controller.messageText,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: SizeConfig.blockSizeHorizontal * 3.5),
              textAlign: TextAlign.center,
              maxLines: 2,
            ),
          ),
        ],
      );
}

class SettingPageNavigationButton extends StatelessWidget {
  const SettingPageNavigationButton({Key? key, required this.controller})
      : super(key: key);

  final ScannerPageController controller;

  @override
  Widget build(BuildContext context) => Stack(
        children: [
          Container(
            width: double.infinity,
            height: SizeConfig.blockSizeVertical * 5.9,
            margin: EdgeInsets.all(SizeConfig.blockSizeVertical * 1.67),
            child: ElevatedButton(
              onPressed: () {
                controller.settingPageButtonOnPressed();
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

class ShowMessage extends StatelessWidget {
  const ShowMessage({Key? key, required this.controller}) : super(key: key);

  final ScannerPageController controller;

  @override
  Widget build(BuildContext context) {
    Color messageColor = Colors.black;

    if (controller.errorIndicator) {
      messageColor = Colors.red;
    } else if (controller.warningIndicator) {
      messageColor = Colors.amberAccent;
    } else if (controller.offlineSuccessIndicator) {
      messageColor = Colors.lightGreen;
    } else if (controller.visitLogUploadTimeoutMessage) {
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
              child: Text(controller.messageText,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: SizeConfig.blockSizeVertical * 2)))
        ],
      ),
    );
  }
}

class OutcomeIndicator extends StatelessWidget {
  const OutcomeIndicator({Key? key, required this.controller})
      : super(key: key);

  final ScannerPageController controller;

  @override
  Widget build(BuildContext context) {
    Color indicatorColor = Colors.black;
    Widget indicatorIcon = const Icon(Icons.error_outline);

    if (controller.errorIndicator) {
      indicatorColor = Colors.red;
      indicatorIcon = const Icon(Icons.block_outlined, color: Colors.white);
    } else if (controller.successIndicator) {
      indicatorColor = Colors.green;
      indicatorIcon =
          const Icon(Icons.check_circle_outline, color: Colors.white);
    } else if (controller.warningIndicator) {
      indicatorColor = Colors.amberAccent;
      indicatorIcon = const Icon(Icons.error_outline, color: Colors.white);
    } else if (controller.offlineSuccessIndicator) {
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
}

class CustomProgressIndicator extends StatelessWidget {
  const CustomProgressIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
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

class SavedScansIndicator extends StatelessWidget {
  const SavedScansIndicator({Key? key, required this.controller})
      : super(key: key);

  final ScannerPageController controller;

  @override
  Widget build(BuildContext context) => Container(
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
              Text(controller.uploadPercentageText,
                  style: TextStyle(
                      color: Colors.lightBlue,
                      fontWeight: FontWeight.bold,
                      fontSize: SizeConfig.blockSizeVertical * 2)),
              SizedBox(
                width: SizeConfig.blockSizeHorizontal * 25,
              ),
              Text(controller.savedVisitLogsNumberText,
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

class OverrideButton extends StatelessWidget {
  const OverrideButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => SizedBox(
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

class ScanHistoryMessagesBubbles extends StatelessWidget {
  const ScanHistoryMessagesBubbles(
      {Key? key,
      required this.scanHistoryBubbleColor,
      required this.messageText})
      : super(key: key);

  final Color scanHistoryBubbleColor;
  final String messageText;

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: scanHistoryBubbleColor,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border: Border.all(
            color: Colors.red,
          ),
        ),
        margin: EdgeInsets.only(
            left: SizeConfig.blockSizeHorizontal * 5,
            right: SizeConfig.blockSizeHorizontal * 5,
            top: SizeConfig.blockSizeHorizontal * 2,
            bottom: SizeConfig.blockSizeHorizontal * 2),
        child: AutoSizeText(
          messageText,
          style: const TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
          maxLines: 2,
        ),
      );
}

class ShowcaseIndicators extends StatelessWidget {
  const ShowcaseIndicators({Key? key, required this.controller})
      : super(key: key);

  final ScannerPageController controller;

  @override
  Widget build(BuildContext context) => Column(
        children: [
          SizedBox(
            height: SizeConfig.blockSizeVertical * 10,
            width: SizeConfig.screenWidth,
          ),
          ElevatedButton(
            onPressed: () {
              controller.showcaseIndicatorsOnPressed();
            },
            child: const Text(
              'Indicators',
              style: TextStyle(fontSize: 10),
            ),
          )
        ],
      );
}
