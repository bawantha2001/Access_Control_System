import 'package:firebase_database/firebase_database.dart';

class usermodel{
  String? phone;
  String? name;
  String? id;
  String? email;
  String? profilepic;

  usermodel({
    this.email,
    this.id,
    this.name,
    this.phone,
    this.profilepic
  });

  usermodel.fromSnapshot(DataSnapshot snapshot){
    phone=(snapshot.value as dynamic)['phone'];
    email=(snapshot.value as dynamic)['email'];
    id=(snapshot.value as dynamic)['id'];
    name=(snapshot.value as dynamic)['name'];
    profilepic=(snapshot.value as dynamic)['profilepic'];
  }
}