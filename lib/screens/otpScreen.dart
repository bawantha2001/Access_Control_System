import 'package:access_control_system/screens/profileDetails.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pinput/pinput.dart';
import '../widgets/progress_dialog.dart';
import 'bottomNavigationBar.dart';

class Otpscreen extends StatefulWidget {

  const Otpscreen({super.key,required this.phoneNumber});
  final String phoneNumber;

  @override
  State<Otpscreen> createState() => _OtpscreenState();
}

class _OtpscreenState extends State<Otpscreen> {

  final otpTextEdittingcont = TextEditingController();
  late String getverificationId;

  final defaultPinTheme = PinTheme(
    width: 56,
    height: 56,
    textStyle: TextStyle(fontSize: 20, color: Color.fromRGBO(30, 60, 87, 1), fontWeight: FontWeight.w600),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.black),
      borderRadius: BorderRadius.circular(20),
    ),
  );

  Future<void> getCodeAuto() async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => ProgressDialog()
    );

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: widget.phoneNumber,

      verificationCompleted:(PhoneAuthCredential credentials){
        otpTextEdittingcont.setText(credentials.smsCode!);
        Fluttertoast.showToast(msg: "${credentials.smsCode!}");
      },

      verificationFailed: (error){
        Navigator.pop(context);
        print("Error ocured : $error");
        Fluttertoast.showToast(msg: "${error.message}");
      },

      codeSent: (verifcationId, forceResendingToken){
        Navigator.pop(context);
        Fluttertoast.showToast(msg: "Code sent");
        getverificationId=verifcationId;
      },

      codeAutoRetrievalTimeout: (error){

      },

      timeout: Duration(seconds: 60),
    );

  }

  void submit() async{
    if(!otpTextEdittingcont.text.trim().isEmpty && otpTextEdittingcont.text.trim().length==6){
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) => ProgressDialog()
      );

      final cred = PhoneAuthProvider.credential(
          verificationId: getverificationId,
          smsCode: otpTextEdittingcont.text.trim());

      await FirebaseAuth.instance.signInWithCredential(cred).then((onValue){

        checkDataAvailability(onValue.user!);

      }).catchError((error){
        Navigator.pop(context);
        print("Error ocured : $error");
      });

    }
    else{
      Fluttertoast.showToast(msg: "Please enter a correct OTP");
    }

  }

  void checkDataAvailability(User currentUser) async{

    DatabaseReference userRef=FirebaseDatabase.instance
        .ref()
        .child("instructors")
        .child(currentUser!.uid);

    userRef.once().then((snap){
      if(snap.snapshot.value!=null){
        Fluttertoast.showToast(msg: "Welcome ${(snap.snapshot.value as dynamic)["name"]}");
        // Showsnackbar.showsuccessSnackbar("Susscessfull", "Welcome ${(snap.snapshot.value as dynamic)["name"]}");
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (c)=> Bottomnavigationbarscreen()));
      }
      else{
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (c)=> Profiledetails(phoneNumber: widget.phoneNumber, currentUser: currentUser)));
      }
    }).catchError((onError){
      Navigator.pop(context);
      print("Error ocured : $onError");
    });

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((callback){
      getCodeAuto();
    });
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
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
                  Text("Verify your phone number",
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold
                    ),
                  ),

                  SizedBox(height: 10,),

                  Text("We’ve sent an SMS with an activation code to your phone ${widget.phoneNumber}",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal
                    ),
                  ),

                  SizedBox(height: 100,),

                  Pinput(
                    defaultPinTheme: defaultPinTheme,
                    pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                    showCursor: true,
                    onCompleted: (pin) => print(pin),
                    length: 6,
                    controller: otpTextEdittingcont,
                  ),

                  SizedBox(height: 150,),

                  Center(
                    child: SizedBox(
                      width: 335,
                      height: 55,

                      child: ElevatedButton(
                        onPressed: (){
                          submit();
                        },
                        child: Text("Verify",
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

                  SizedBox(height: 10,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("I didn't recieve a code ",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal
                        ),
                      ),

                      SizedBox(width: 2,),

                      GestureDetector(
                        onTap:(){
                          getCodeAuto();
                        },
                        child:Text(
                          'Resend',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18
                          ),
                        ),
                      ),
                    ],
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
