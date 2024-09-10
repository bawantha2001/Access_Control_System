import 'package:access_control_system/models/students_detail_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../controllers/controllers.dart';
import '../global.dart';

class Students extends StatefulWidget {
  const Students({super.key});

  @override
  State<Students> createState() => _StudentsState();
}

class _StudentsState extends State<Students> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage('assets/imgs/background_3.png'),
            fit: BoxFit.cover,
          ),
        ),

        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage:  userModelCurrrentInfo!.profilepic !=null?NetworkImage(userModelCurrrentInfo!.profilepic!):AssetImage("assets/imgs/profile.png"),
                    backgroundColor: Colors.white,
                    radius: 20,
                  ),
                  SizedBox(width: 5,),
                  Text("Hi, ",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  Text(userModelCurrrentInfo!.name!,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.normal
                    ),
                  ),
                ],
              ),
            ),

            Padding(padding: EdgeInsets.fromLTRB(5,30,5,5),),

            Padding(
              padding: const EdgeInsets.fromLTRB(15,0,15,0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Students List",
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold
                    ),
                  ),

                  SizedBox(height: 10,),

                  FutureBuilder(
                      future: Controllers.fetchAllStudentsdetailsData(),
                      builder: (context,snap){
                        if(snap.connectionState == ConnectionState.waiting){
                          return Column(
                            children: [
                              SizedBox(height: 150,),
                              Center(
                                child: SpinKitWave(
                                  size: 25,
                                  color: Color.fromRGBO(255, 199, 0, 1),
                                ),
                              ),
                            ],
                          );
                        }

                        else if(snap.hasError){
                          return Column(
                            children: [
                              SizedBox(height: 150,),
                              Center(
                                child: Text(
                                    "${snap.error.toString()}"
                                ),
                              ),
                            ],
                          );
                        }

                        else if(!snap.hasData || snap.data!.isEmpty){
                          return Column(
                            children: [
                              SizedBox(height: 150,),
                              Center(
                                child: Text(
                                  "No Data",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          );
                        }

                        else{
                          List<StudentsDetailModel> studentDetailList = snap.data!;

                          return ListView.builder(
                            itemCount: studentDetailList.length,
                            itemBuilder: (context, index){

                              Card(
                                margin: EdgeInsets.symmetric(vertical: 6, horizontal: 15),
                                elevation: 2,
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    backgroundImage: AssetImage("assets/imgs/profile.png"),
                                    radius: 20,
                                  ),

                                  title: Text(
                                    "${studentDetailList[index].firstName} ${studentDetailList[index].lastName}" ?? "No name",
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),

                                  subtitle: Text(
                                    "${studentDetailList[index].phone}" ?? "No name",
                                    style: TextStyle(fontWeight: FontWeight.normal),
                                  ),

                                  trailing: Text(
                                    "${studentDetailList[index].undergraduateYear} year" ?? "No name",
                                    style: TextStyle(fontWeight: FontWeight.normal),
                                  ),
                                ),
                              );

                            },
                          );
                        }
                      }
                  ),

                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}
