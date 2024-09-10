import 'dart:io';

import 'package:access_control_system/controllers/controllers.dart';
import 'package:access_control_system/screens/bottomNavigationBar.dart';
import 'package:access_control_system/screens/homeScreen.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import '../widgets/progress_dialog.dart';

class Profiledetails extends StatefulWidget {

  const Profiledetails({super.key,required this.phoneNumber,required this.currentUser});
  final String phoneNumber;
  final User? currentUser;

  @override
  State<Profiledetails> createState() => _ProfiledetailsState();
}

class _ProfiledetailsState extends State<Profiledetails> {

  final nameTextEdittingcont = TextEditingController();
  final emailTextEdittingcont = TextEditingController();
  final formkey = GlobalKey<FormState>();
  File? _profilePhoto = null;

  Future<void> pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
          _profilePhoto = File(pickedFile.path);
      });
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
          profilePhotoUrl = await Controllers.uploadImage(_profilePhoto!, "instructors/${widget.currentUser!.uid}/profile_photo.jpg");
        }
        else{
          Navigator.pop(context);
          Fluttertoast.showToast(msg: "Please select an image");
          return;
        }

        if(widget.currentUser!=null && profilePhotoUrl!=null){
          Map userMap={
            "id":widget.currentUser!.uid,
            "name":nameTextEdittingcont.text.trim(),
            "email":emailTextEdittingcont.text.trim(),
            "phone":widget.phoneNumber,
            "profilepic":profilePhotoUrl,
          };

          DatabaseReference userRef=FirebaseDatabase.instance.ref().child("instructors");

          userRef.child(widget.currentUser!.uid).set(userMap).then((onValue) async {
            Fluttertoast.showToast(msg: "Welcome ${nameTextEdittingcont.text.trim()}");
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (c) => Bottomnavigationbarscreen()));

          }).catchError((error){
            Navigator.pop(context);
            Fluttertoast.showToast(msg: "Verification error");
            print("Error ocured : $error");
          });
        }else{
          Navigator.pop(context);
          Fluttertoast.showToast(msg: "Registration error");
        }
    }
    else{
      Fluttertoast.showToast(msg: "Saving Error");
    }

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage('assets/imgs/background.png'),
            fit: BoxFit.cover,
          ),
        ),

        child: ListView(
          children: [
            Padding(padding: EdgeInsets.fromLTRB(5,(MediaQuery.of(context).size.height)/6,5,5),

            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(15,0,15,0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Enter your details",
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold
                    ),
                  ),

                  SizedBox(height: 50,),

                  Form(
                    key: formkey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [

                        Align(alignment: Alignment.centerLeft,child: Text("Name",style: TextStyle(fontWeight: FontWeight.bold),)),

                        
                        TextFormField(
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(50)
                          ],
                          decoration: InputDecoration(
                            hintText: 'Your name',
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

                        SizedBox(height: 25,),


                        Align(alignment: Alignment.centerLeft,child: Text("Email",style: TextStyle(fontWeight: FontWeight.bold),)),

                        TextFormField(
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(100)
                          ],
                          decoration: InputDecoration(
                            hintText: 'Your email',
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

                      ],
                    ),
                  ),

                  SizedBox(height: 25,),

                  Align(alignment: Alignment.centerLeft,child: Text("Profile picture",style: TextStyle(fontWeight: FontWeight.bold),)),

                  GestureDetector(
                    onTap: (){
                      pickImage(ImageSource.gallery);
                    },
                    child: CircleAvatar(
                      radius: 70,
                      backgroundImage: _profilePhoto != null?FileImage(_profilePhoto!):AssetImage("assets/imgs/profile.png"),
                    ),
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
                        child: Text("Done",
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
            ),

          ],
        ),
      ),
    );
  }
}
