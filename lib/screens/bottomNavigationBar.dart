import 'package:access_control_system/controllers/controllers.dart';
import 'package:access_control_system/screens/homeScreen.dart';
import 'package:access_control_system/screens/profile.dart';
import 'package:access_control_system/screens/students.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import '../global.dart';
import '../models/user_models.dart';

class Bottomnavigationbarscreen extends StatefulWidget {
  const Bottomnavigationbarscreen({super.key});

  @override
  State<Bottomnavigationbarscreen> createState() => _BottomnavigationbarState();
}

class _BottomnavigationbarState extends State<Bottomnavigationbarscreen> {

  int current_index = 0;
  late Future<void> firebaseDataLoader;

  List<Widget> widgets = <Widget>[
    Homescreen(),
    Students(),
    Profile(),
  ];

  Future<void> loadFirebaseData()async{
    var snap = await Controllers().readCurrentOnlineUserInfo();
      if(snap.snapshot.value!=null){
        userModelCurrrentInfo = usermodel.fromSnapshot(snap.snapshot);
      }
  }
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    firebaseDataLoader = loadFirebaseData();
  }
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<void>(
        future: firebaseDataLoader,
        builder: (context,snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(
              child: SpinKitWave(
                size: 25,
                color: Color.fromRGBO(255, 199, 0, 1),
              ),
            );
          }
          else if(snapshot.hasError){
            return Center(
              child: Text(
                "Data Error"
              ),
            );
          }
          else{
           return Center(
              child: widgets.elementAt(current_index),
            );
          }
        },
      ),

      bottomNavigationBar:Container(
        color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Container(
              decoration: BoxDecoration(
                  color: Color.fromRGBO(255, 199, 0, 1),
                  borderRadius: BorderRadius.circular(35)
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GNav(
                    backgroundColor: Colors.transparent,
                    rippleColor: Colors.grey[300]!,
                    hoverColor: Colors.grey[100]!,
                    gap: 8,
                    activeColor: Colors.black,
                    iconSize: 24,
                    haptic: true,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    duration: Duration(milliseconds: 400),
                    tabActiveBorder: Border.all(color: Colors.white),
                tabs: [
                    GButton(icon: Icons.list_alt_rounded,text: "Attendance",),
                    GButton(icon: Icons.man,text: "Students",),
                    GButton(icon: Icons.supervised_user_circle,text: "Profile",),
                  ],
                    color: Colors.white,
                    selectedIndex: current_index,
                    onTabChange: (index){
                    setState(() {
                      current_index = index;
                    });
                    },
                  ),
              ),
            ),
          ),
      ),
    );
  }
}
