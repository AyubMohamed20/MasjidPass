import 'package:flutter/material.dart';
import 'package:masjid_pass/settingspage.dart';
//hello 
class ScannerPage extends StatefulWidget {
  const ScannerPage({Key? key, required this.title}) : super(key: key);

  final String title;


  @override
  State<ScannerPage> createState() => _ScannerPageState();
}



class _ScannerPageState extends State<ScannerPage> {
 // @override
  //_navigateToSettingsPage() async {
    //Navigator.push(
   //    context,
      //  MaterialPageRoute(
      //      builder: (context) => SettingsPage(
      //       title: "Settings Page",
     //       )));
  //}
  @override
  _navigateToSettingsPage() async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SettingsPage(
              title: "Settings Page",
            )));
  }
  @override
  Widget build(BuildContext context) {
    int _selectedIndex = 0;
    return Scaffold(
      backgroundColor: Color.fromRGBO(116, 178, 196, 1),
      appBar: AppBar(
          title: Text('      Scanner Page\nCapacity Count (0/10)'),
          centerTitle: true,
          backgroundColor: Colors.transparent

      ),

      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        //crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 35),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Image.asset(
                'assets/scanner.jpeg',
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
                ),
            ],
          ),
          SizedBox(height: 300.0,),
          Row(
           //mainAxisAlignment: MainAxisAlignment.,
           // crossAxisAlignment: CrossAxisAlignment.baseline,
            children: [
              Expanded(
                  flex: 5,
                    child: Container(
                  margin: EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Expanded(
                            child: ElevatedButton(
                              onPressed: () {_navigateToSettingsPage();},
                              child: const Text('Settings Page'),
                              style: ButtonStyle(
                                backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.blue),
                              ),
                            )),
                      ],
                    ),
                  ),
                ),
            ],
          )

          ],
    // child: Image.asset(
        //'assets/scanner.jpeg',
       // fit: BoxFit.cover,
      // alignment: Alignment.topCenter,
      //  ),
      ),


    );
  }
}
