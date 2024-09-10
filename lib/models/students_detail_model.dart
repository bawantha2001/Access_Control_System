import 'package:firebase_database/firebase_database.dart';

class StudentsDetailModel{
  String? studentId;
  String? firstName;
  String? lastName;
  String? phone;
  String? undergraduateYear;

  StudentsDetailModel({
    this.studentId,
    this.firstName,
    this.lastName,
    this.phone,
    this.undergraduateYear,
  });

  StudentsDetailModel.fromSnapshot(DataSnapshot snapshot){
    studentId=(snapshot.value as dynamic)['studentId'];
    firstName=(snapshot.value as dynamic)['firstName'];
    lastName=(snapshot.value as dynamic)['lastName'];
    phone=(snapshot.value as dynamic)['phone'];
    undergraduateYear=(snapshot.value as dynamic)['undergraduateYear'];
  }
}