import 'dart:io';

import 'package:email_validator/email_validator.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pinput/pinput.dart';

import '../controllers/controllers.dart';
import '../global.dart';
import '../models/user_models.dart';
import '../widgets/progress_dialog.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  final nameTextEdittingcont = TextEditingController();
  final emailTextEdittingcont = TextEditingController();
  final phoneCont = TextEditingController();
  final formkey = GlobalKey<FormState>();
  late Future<void> firebaseDataLoader;
  File? _profilePhoto = null;

  Future<void> pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _profilePhoto = File(pickedFile.path);
      });
    }
  }

  void loadData(){
    nameTextEdittingcont.setText(userModelCurrrentInfo!.name!);
    emailTextEdittingcont.setText(userModelCurrrentInfo!.email!);
    phoneCont.setText(userModelCurrrentInfo!.phone!);
  }

  Future<void> loadFirebaseData()async{
    var snap = await Controllers().readCurrentOnlineUserInfo();
    if(snap.snapshot.value!=null){
      userModelCurrrentInfo = usermodel.fromSnapshot(snap.snapshot);
    }
  }

  void submit() async{

    if(formkey.currentState!.validate()){
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) => ProgressDialog()
      );

      String? profilePhotoUrl;

      if (_profilePhoto != null) {
        profilePhotoUrl = await Controllers.uploadImage(_profilePhoto!, "instructors/${currentUser!.uid}/profile_photo.jpg");
      }

      if(currentUser!=null){
        Map<String, String> userMap={
          "name":nameTextEdittingcont.text.trim(),
          "email":emailTextEdittingcont.text.trim(),
          "phone":phoneCont.text.trim(),
          "profilepic":profilePhotoUrl !=null?profilePhotoUrl:userModelCurrrentInfo!.profilepic!,
        };

        DatabaseReference userRef=FirebaseDatabase.instance.ref().child("instructors");

        userRef.child(currentUser!.uid).update(userMap).then((onValue) async {
          Navigator.pop(context);
          firebaseDataLoader = loadFirebaseData();
          Fluttertoast.showToast(msg: "Data saved");

        }).catchError((error){
          Navigator.pop(context);
          Fluttertoast.showToast(msg: "Verification error");
          print("Error ocured : $error");
        });
      }

    }
    else{
      Fluttertoast.showToast(msg: "Saving Error");
    }

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((callback){
      loadData();
    });
    firebaseDataLoader = loadFirebaseData();
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
              padding: const EdgeInsets.fromLTRB(20,50,20,0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("My Profile",
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold
                    ),
                  ),

                  SizedBox(height: 50,),

                  FutureBuilder(
                      future: firebaseDataLoader,
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

                        else{
                          return Form(
                            key: formkey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                GestureDetector(
                                  child: CircleAvatar(
                                    backgroundImage:  userModelCurrrentInfo!.profilepic !=null? _profilePhoto!=null?FileImage(_profilePhoto!):NetworkImage(userModelCurrrentInfo!.profilepic!):AssetImage("assets/imgs/profile.png"),
                                    backgroundColor: Colors.white,
                                    radius: 50,
                                  ),
                                  onTap: (){
                                    pickImage(ImageSource.gallery);
                                  },
                                ),

                                SizedBox(height: 15,),

                                Align(alignment: Alignment.centerLeft,child: Text("Personal Details",style: TextStyle(fontWeight: FontWeight.bold),)),

                                SizedBox(height: 15,),

                                TextFormField(
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(50)
                                  ],
                                  controller: nameTextEdittingcont,
                                  decoration: InputDecoration(
                                    hintText: 'Waiting.....',
                                    hintStyle: TextStyle(
                                        color: Colors.grey
                                    ),
                                    filled: true,
                                    fillColor:Colors.grey.shade200,

                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25),
                                      borderSide: BorderSide(
                                        color: Colors.transparent, // Set the color you want for the enabled border
                                        width: 1.0,
                                      ),
                                    ),

                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25),
                                      borderSide: BorderSide(
                                        color: Colors.black, // Set the color you want for the focused border
                                        width: 1.0,
                                      ),
                                    ),

                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25),
                                      borderSide: BorderSide(
                                        color: Colors.red, // Set the color you want for the focused border
                                        width: 1.0,
                                      ),
                                    ),

                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25),
                                      borderSide: BorderSide(
                                        color: Colors.red, // Set the color you want for the focused border
                                        width: 1.0,
                                      ),
                                    ),

                                    prefixIcon: Icon(Icons.person,color: Colors.grey,),
                                  ),

                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  validator: (text){
                                    if(text==null || text.isEmpty){
                                      return 'Name can\'t be empty';
                                    }
                                    if(text.length<2){
                                      return 'Please enter a valid Name';
                                    }
                                    if(text.length>50){
                                      return 'Name can\'t be more than 50';
                                    }
                                  },
                                  onChanged: (text)=>setState(() {
                                    nameTextEdittingcont.text=text;
                                  }),
                                ),

                                SizedBox(height: 10,),

                                TextFormField(
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(100)
                                  ],
                                  controller: emailTextEdittingcont,
                                  decoration: InputDecoration(
                                    hintText: 'Waiting......',
                                    hintStyle: TextStyle(
                                        color: Colors.grey
                                    ),
                                    filled: true,
                                    fillColor:Colors.grey.shade200,
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25),
                                      borderSide: BorderSide(
                                        color: Colors.transparent, // Set the color you want for the focused border
                                        width: 1.0,
                                      ),
                                    ),

                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25),
                                      borderSide: BorderSide(
                                        color: Colors.black, // Set the color you want for the focused border
                                        width: 1.0,
                                      ),
                                    ),

                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25),
                                      borderSide: BorderSide(
                                        color: Colors.red, // Set the color you want for the focused border
                                        width: 1.0,
                                      ),
                                    ),

                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25),
                                      borderSide: BorderSide(
                                        color: Colors.red, // Set the color you want for the focused border
                                        width: 1.0,
                                      ),
                                    ),

                                    prefixIcon: Icon(Icons.email,color: Colors.grey,),
                                  ),
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  validator: (text){
                                    if(text==null || text.isEmpty){
                                      return 'Email can\'t be empty';
                                    }

                                    if(EmailValidator.validate(text)==true){
                                      return null;
                                    }
                                    if(text.length<2){
                                      return 'Please enter a valid Email';
                                    }
                                    if(text.length>90){
                                      return 'Email can\'t be more than 90';
                                    }
                                  },
                                  onChanged: (text)=>setState(() {
                                    emailTextEdittingcont.text=text;
                                  }),
                                ),

                                SizedBox(height: 10,),

                                TextFormField(
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(50)
                                  ],
                                  controller: phoneCont,
                                  decoration: InputDecoration(
                                    hintText: 'Waiting.....',
                                    hintStyle: TextStyle(
                                        color: Colors.grey
                                    ),
                                    filled: true,
                                    fillColor:Colors.grey.shade200,

                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25),
                                      borderSide: BorderSide(
                                        color: Colors.transparent, // Set the color you want for the enabled border
                                        width: 1.0,
                                      ),
                                    ),

                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25),
                                      borderSide: BorderSide(
                                        color: Colors.black, // Set the color you want for the focused border
                                        width: 1.0,
                                      ),
                                    ),

                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25),
                                      borderSide: BorderSide(
                                        color: Colors.red, // Set the color you want for the focused border
                                        width: 1.0,
                                      ),
                                    ),

                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25),
                                      borderSide: BorderSide(
                                        color: Colors.red, // Set the color you want for the focused border
                                        width: 1.0,
                                      ),
                                    ),

                                    prefixIcon: Icon(Icons.phone,color: Colors.grey,),
                                  ),

                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  validator: (text){
                                    if(text==null || text.isEmpty){
                                      return 'Phone No can\'t be empty';
                                    }
                                    if(text.length!=12){
                                      return 'Phone No not correct';
                                    }
                                  },
                                  onChanged: (text)=>setState(() {
                                    phoneCont.text = text;
                                  }),
                                ),

                                SizedBox(height: 100,),

                                Center(
                                  child: SizedBox(
                                    width: 335,
                                    height: 55,

                                    child: ElevatedButton(
                                      onPressed: (){
                                        submit();
                                      },
                                      child: Text("Save",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16
                                        ),),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Color.fromRGBO(255, 199, 0, 1),
                                      ),
                                    ),
                                  ),
                                ),

                              ],
                            ),
                          );
                        }
                      }),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}
