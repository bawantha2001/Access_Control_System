import 'package:access_control_system/controllers/controllers.dart';
import 'package:access_control_system/global.dart';
import 'package:access_control_system/models/attendance_data_model.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {

  List<DateTime?> _singleDatePickerValueWithDefaultValue = [
    DateTime.now().add(const Duration(days: 1)),
  ];

  bool _isCalendarVisible = false;

  String? _formattedDate;

  void _formatSelectedDate(DateTime date) {
    setState(() {
      _formattedDate = DateFormat('MM-dd-yyyy').format(date);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _formatSelectedDate(DateTime.now());
  }

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
                  Text("Students Attendance",
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold
                    ),
                  ),

                  SizedBox(height: 30,),


                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromRGBO(255, 199, 0, 1),
                      foregroundColor: Colors.black
                    ),
                    icon: Icon(_isCalendarVisible ? Icons.close : Icons.calendar_today,),
                      onPressed: (){
                        setState(() {
                          _isCalendarVisible = !_isCalendarVisible;
                        });
                      },
                      label: Text(_formattedDate.toString())),

                  _isCalendarVisible?CalendarDatePicker2(
                      config: CalendarDatePicker2Config(),
                      value: _singleDatePickerValueWithDefaultValue,
                    onValueChanged: (dates){
                        setState(() {
                          _formatSelectedDate(dates.first?? DateTime.now());
                          _isCalendarVisible = false;
                        });
                    },
                  ):

                  SizedBox(height: 10,),

                  FutureBuilder(
                      future: Controllers.fetchAllStudentData(_formattedDate.toString()),
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
                          List<AttendanceDataModel> attendanceList = snap.data!;

                          return SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                                columnSpacing: 25,
                                horizontalMargin: 15,
                                showBottomBorder: true,
                                columns: [
                                  DataColumn(
                                    label: Text('Student ID'),
                                  ),
                                  DataColumn(
                                    label: Text('Time In'),
                                  ),
                                  DataColumn(
                                    label: Text('Time Out'),
                                  ),
                                  DataColumn(
                                    label: Text('Gate No'),
                                  ),
                                ],
                                rows: attendanceList.map((attendance){
                                  return DataRow(
                                      cells: [
                                        DataCell(Text(attendance.studentId??''),onTap: (){
                                          Fluttertoast.showToast(msg:attendance.studentId!);
                                        }),
                                        DataCell(Text(attendance.timeIn??'')),
                                        DataCell(Text(attendance.timeOut??'')),
                                        DataCell(Text(attendance.gateNo??'')),
                                      ]
                                  );
                                }).toList(),
                            ),
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
