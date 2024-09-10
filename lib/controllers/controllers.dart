import 'dart:io';

import 'package:access_control_system/models/students_detail_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../global.dart';
import '../models/attendance_data_model.dart';

class Controllers {

  static Future<bool> isLogedIn() async {
    var user = FirebaseAuth.instance.currentUser;
    return user != null;
  }

  Future<DatabaseEvent> readCurrentOnlineUserInfo() async {
    currentUser = FirebaseAuth.instance.currentUser;
    DatabaseReference userRef = FirebaseDatabase.instance
        .ref()
        .child("instructors")
        .child(currentUser!.uid);

    Future<DatabaseEvent> databaseEvent = userRef.once();

    return databaseEvent;
  }

  static Future<List<AttendanceDataModel>> fetchAllStudentData(String date) async {
    List<AttendanceDataModel> attendanceList = [];

    final snap = await FirebaseDatabase.instance
        .ref()
        .child('attendance')
        .child(date).once(); // Reference to the date node

    if (snap.snapshot.value != null) {
      Map data = snap.snapshot.value as Map;
      List<String> studentsIdList = [];

      data.forEach((key, value) {
        studentsIdList.add(key);
      });

      for (String eachKey in studentsIdList) {
        final snap = await FirebaseDatabase.instance.ref()
            .child("attendance")
            .child(date)
            .child(eachKey)
            .once();

        var eachattendance = AttendanceDataModel.fromSnapshot(snap.snapshot);

        attendanceList.add(eachattendance);
      }
    }
    return attendanceList;
  }

  static Future<List<StudentsDetailModel>> fetchAllStudentsdetailsData() async {
    List<StudentsDetailModel> studentDetailData = [];

    final snap = await FirebaseDatabase.instance
        .ref()
        .child('students')
        .once(); // Reference to the date node

    if (snap.snapshot.value != null) {
      Map data = snap.snapshot.value as Map;
      List<String> studentsIdList = [];

      data.forEach((key, value) {
        studentsIdList.add(key);
      });

      for (String eachKey in studentsIdList) {
        final snap = await FirebaseDatabase.instance.ref()
            .child("students")
            .child(eachKey)
            .once();

        var studentDetails = StudentsDetailModel.fromSnapshot(snap.snapshot);

        studentDetailData.add(studentDetails);
      }
    }
    return studentDetailData;
  }

  static Future<String?> uploadImage(File imageFile, String path) async {
    try {
      final storageRef = FirebaseStorage.instanceFor(bucket: "gs://access-control-system-28125.appspot.com").ref();
      final imagesRef = storageRef.child(path);
      await imagesRef.putFile(imageFile);
      final downloadUrl = await imagesRef.getDownloadURL();
      print('Upload complete! Image URL: $downloadUrl');
      return downloadUrl;
    } catch (e) {
      print("Error uploading image: $e");
      Fluttertoast.showToast(msg: "Error uploading image: $e");
      return null;
    }
  }

}