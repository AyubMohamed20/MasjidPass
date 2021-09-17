import 'package:flutter/material.dart';

class InfoPage extends StatefulWidget {
  const InfoPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(116, 178, 196, 1),
      appBar: AppBar(
          title: Text('Info Page'),
          centerTitle: true,
          backgroundColor: Colors.transparent),
      body: Center(),
    );
  }
}
