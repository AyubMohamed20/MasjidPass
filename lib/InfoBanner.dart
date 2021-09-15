import 'package:flutter/material.dart';

class InfoBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Center(child: Text('MasjidPass Check-In Scanner')),
            ),
            ListTile(
              title: Text(
                'Device ID',
                style: TextStyle(fontWeight: FontWeight.bold),
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
              onTap: () => null,
            ),
          ], //children
        ),
      ),
      appBar: AppBar(
        //change this late when finalizing what client wants
        //backgroundColor: Colors.amber,
        centerTitle: true,
        title: Text('MasjidPass'),
      ),
      body: Center(),
    );
  }
}
