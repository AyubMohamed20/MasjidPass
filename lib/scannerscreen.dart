import 'package:flutter/material.dart';
//hello 
class ScannerPage extends StatefulWidget {
  const ScannerPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(116, 178, 196, 1),
      appBar: AppBar(
          title: Text('Scanner Page'),
          centerTitle: true,
          backgroundColor: Colors.transparent),
      body: Center(),
    );
  }
}
