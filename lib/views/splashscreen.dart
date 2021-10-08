import 'package:flutter/material.dart';
import 'package:masjid_pass/main.dart';
import 'package:masjid_pass/models/user.dart';
import 'package:masjid_pass/db/masjid_database.dart';

import 'loginscreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late List<User> users;




  @override
  void initState(){
    super.initState();
   //deleteUser();
   // addUser();
    //refreshUsers();
    //updateUser();
   refreshUsers();
    _navigateToSettings();
  }

  Future deleteUser() async{
    int i =16;
    await MasjidDatabase.instance.delete(i);
  }
  Future deleteAll() async{

    await MasjidDatabase.instance.deleteAll();
  }

  Future updateUser() async{
    final note = User(
      id: 9,
      username: 'changed username',
      password: 'changed password',

    );

    await MasjidDatabase.instance.update(note);
  }

  Future addUser() async{
    final testUser = User(
      username: 'testname',
      password: 'testpassword',
    );

    await MasjidDatabase.instance.create(testUser);
  }

  Future refreshUsers() async{

    users = await MasjidDatabase.instance.readAllUsers();
    print(users);
  }



  _navigateToSettings()async{
    await Future.delayed(Duration(milliseconds: 4000));
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context)=> LoginPage(

            )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(color: Color.fromRGBO(116, 178, 196, 1)),
          ),
          Column(
            children: <Widget>[
              Expanded(
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Spacer(flex: 6),
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 50.0,
                        child: Icon(
                          Icons.qr_code_scanner,
                          color: Colors.black87,
                          size: 50.0,
                        ),
                      ),

                      Spacer(flex: 1),
                      Text(

                        "Masjid Check-in Scanner",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 24.0),
                      ),

                      Spacer(flex: 1),
                      //CircularProgressIndicator(),
                    ],

                  ),

                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(),
                    Padding(
                      padding: EdgeInsets.only(top: 20.0),
                    ),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}