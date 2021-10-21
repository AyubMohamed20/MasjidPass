import 'package:flutter/material.dart';

import 'package:masjid_pass/main.dart';
import 'package:masjid_pass/models/user.dart';
import 'package:masjid_pass/models/event.dart';
import 'package:masjid_pass/models/visitor.dart';
import 'package:masjid_pass/db/masjid_database.dart';

import 'loginscreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  //holds the objects from each table
  late List<User> users;
  late List<Event> events;
  late List<Visitor> visitors;


  @override
  void initState(){
    super.initState();
    //addUser();
    //addEvent();
    //updateUser();
    //displayUsers();
    //displayEvents();
    //deleteUser();
    //deleteEvent();
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
    int i=1;
    int j=12;

    final updateUser = User(
      id: i,
      username: 'changed username',
      password: 'changed password',
      organizationId: j

    );

    await MasjidDatabase.instance.update(updateUser);
  }

  Future addUser() async{
    final testUser = User(
      username: 'testname',
      password: 'testpassword',
      organizationId: 11
    );

    await MasjidDatabase.instance.create(testUser);
  }

  Future displayUsers() async{

    users = await MasjidDatabase.instance.readAllUsers();
    print(users);
  }

  Future displayEvents() async{

    events = await MasjidDatabase.instance.readAllEvents();
    print(events);
  }

  Future deleteEvent() async{
    int i =16;
    await MasjidDatabase.instance.deleteEvent(1);
  }

  Future addEvent() async{
    final testEvent = Event(
      organizationId: 1,
      eventDateTime: DateTime.now(),
      hall: 'north',
      capacity: 100,
    );

    await MasjidDatabase.instance.createEvent(testEvent);
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