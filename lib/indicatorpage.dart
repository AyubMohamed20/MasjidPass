import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:masjid_pass/scannerscreen.dart';

class IndicatorPage extends StatefulWidget {
  const IndicatorPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<IndicatorPage> createState() => _IndicatorPageState();
}

class _IndicatorPageState extends State<IndicatorPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white.withOpacity(1),
        appBar: AppBar(
          title: const Text("QR Scanner Indicator"),
        ),
        body: Center(
          child: Container(
              decoration: const BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
              ),
              width: SizeConfig.blockSizeVertical * 20,
              height: SizeConfig.blockSizeVertical * 20,
              child: IconButton(
                padding: const EdgeInsets.all(0.0),
                icon: const Icon(
                  Icons.check_circle_outline,
                  color: Colors.white,
                  size: 100,
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ScannerPage(
                            title: "Scanner Page",
                          )));
                },
              )),
        ));
  }
}
