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
      body: Center(
        child: ListView(
          children: [
            ListTile(
              title: Center(
                child: Text(
                  'MasjidPass',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24
                  ),
                ),
              ),
              onTap: () => null,
            ),
            ListTile(
              title: Center(
                child: Text(
                  'System Information',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            ListTile(
              title: Text(
                'Device ID',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                  'f774690826290hd832'
              ),
              onTap: () => null,
            ),
            Divider(
              thickness: 2,
            ),
            ListTile(
              title: Text(
                'Scanner Version',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                  '2.8'
              ),
              onTap: () => null,
            ),
            Divider(
              thickness: 2,
            ),
            ListTile(
              title: Text(
                'Authentication API Version',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                  '1.0'
              ),
              onTap: () => null,
            ),
            Divider(
              thickness: 2,
            ),
            ListTile(
              title: Text(
                'Backend API Version',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                  '1.0'
              ),
              onTap: () => null,
            ),
            Divider(
              thickness: 2,
            ),
          ],
        ),
      ),
    );
  }
}
