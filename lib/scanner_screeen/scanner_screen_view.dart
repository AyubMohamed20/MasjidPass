import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:masjid_pass/scanner_screeen/scanner_screen_controller.dart';
import 'package:masjid_pass/scanner_screeen/scanner_screen_widget.dart';
import 'package:masjid_pass/utilities/screen_size_config.dart';
import 'package:widget_view/widget_view.dart';

class ScannerPageView
    extends StatefulWidgetView<ScannerPage, ScannerPageController> {
  const ScannerPageView(ScannerPageController controller) : super(controller);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
        backgroundColor: const Color.fromRGBO(116, 178, 196, 1),
        appBar: null,
        body: Stack(
          children: [
            QrScannerView(controller: controller),
            ScanHistory(controller: controller),
            if (controller.hasIndicator ||
                controller.hasMessage ||
                controller.hasProgressIndicator ||
                controller.hasSavedScansIndicator)
              Container(
                width: SizeConfig.screenWidth,
                height: SizeConfig.screenHeight,
                color: const Color(0x00000000).withOpacity(.8),
                child: Column(
                  children: [
                    SizedBox(
                      height: SizeConfig.blockSizeVertical * 3.5,
                    ),
                    if (controller.hasMessage)
                      ShowMessage(controller: controller),
                    Center(
                      child: Column(
                        children: [
                          SizedBox(
                            height: SizeConfig.blockSizeVertical * 15,
                          ),
                          if (controller.hasIndicator)
                            OutcomeIndicator(controller: controller),
                          if (controller.hasProgressIndicator)
                            const CustomProgressIndicator(),
                          if (controller.hasSavedScansIndicator)
                            SavedScansIndicator(controller: controller),
                          SizedBox(
                            height: SizeConfig.blockSizeVertical * 6,
                          ),
                          if ((controller.errorIndicator ||
                                  controller.warningIndicator) &&
                              controller.hasIndicator)
                            const OverrideButton(),
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
}