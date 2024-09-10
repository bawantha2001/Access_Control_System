import 'package:firebase_database/firebase_database.dart';

class AttendanceDataModel{
  String? studentId;
  String? timeIn;
  String? timeOut;
  String? gateNo;

  AttendanceDataModel({
    this.studentId,
    this.timeIn,
    this.timeOut,
    this.gateNo,
});

  AttendanceDataModel.fromSnapshot(DataSnapshot snapshot){
    studentId=(snapshot.value as dynamic)['studentId'];
    timeIn=(snapshot.value as dynamic)['timeIn'];
    timeOut=(snapshot.value as dynamic)['timeOut'];
    gateNo=(snapshot.value as dynamic)['gateNo'];
  }

}