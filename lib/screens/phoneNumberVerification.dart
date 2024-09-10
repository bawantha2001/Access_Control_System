import 'package:access_control_system/controllers/controllers.dart';
import 'package:access_control_system/screens/otpScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl_phone_number_field/intl_phone_number_field.dart';

class Phonenumberverification extends StatefulWidget {
  const Phonenumberverification({super.key});

  @override
  State<Phonenumberverification> createState() => _PhonenumberverificationState();
}

class _PhonenumberverificationState extends State<Phonenumberverification> {

  final phoneTextEdittingcont = TextEditingController();
   late String phoneNo;

  Future<void> submit() async {
    if(!phoneTextEdittingcont.text.trim().isEmpty && phoneNo.length==11){
          Navigator.push(context, MaterialPageRoute(builder: (c)=> Otpscreen(phoneNumber: "+$phoneNo")));
    }
    else{
      Fluttertoast.showToast(msg: "Enter a correct phone number");
    }
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
                  Text("What is your phone number",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold
                    ),
                  ),

                  SizedBox(height: 10,),

                  Text("Please confirm your country code and enter your phone number.",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal
                    ),
                  ),

                  SizedBox(height: 100,),

                  InternationalPhoneNumberInput(
                    height: 60,
                    controller: phoneTextEdittingcont,
                    inputFormatters: const [],
                    formatter: MaskedInputFormatter('## ### ####'),
                    initCountry: CountryCodeModel(
                        name: "Sri Lanka", dial_code: "+94", code: "LK",
                    ),
                    betweenPadding:10,

                    onInputChanged: (phone) =>setState(() {
                      phoneNo = phone.rawFullNumber;

                    }),

                    //loadFromJson: Controllers().loadFromJson,

                    dialogConfig: DialogConfig(
                      backgroundColor: const Color(0xFF444448),
                      searchBoxBackgroundColor: const Color(0xFF56565a),
                      searchBoxIconColor: const Color(0xFFFAFAFA),
                      countryItemHeight: 55,
                      topBarColor: const Color(0xFF1B1C24),
                      selectedItemColor: const Color(0xFF56565a),
                      selectedIcon: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Image.asset(
                          "assets/check.png",
                          width: 20,
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                      textStyle: TextStyle(
                          color: const Color(0xFFFAFAFA).withOpacity(0.7),
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                      searchBoxTextStyle: TextStyle(
                          color: const Color(0xFFFAFAFA).withOpacity(0.7),
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                      titleStyle: const TextStyle(
                          color: Color(0xFFFAFAFA),
                          fontSize: 18,
                          fontWeight: FontWeight.w700),
                      searchBoxHintStyle: TextStyle(
                          color: const Color(0xFFFAFAFA).withOpacity(0.7),
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                    ),
                    countryConfig: CountryConfig(
                        decoration: BoxDecoration(
                          border: Border.all(
                              width: 1, color: const Color.fromRGBO(255, 199, 0, 1)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        noFlag: false,
                        textStyle: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w600)),

                    validator: (number) {
                      if (number.number.isEmpty) {
                        return "The phone number cannot be left emptyssss";
                      }
                      return null;
                    },

                    phoneConfig: PhoneConfig(
                      focusedColor: const Color.fromRGBO(255, 199, 0, 1),
                      enabledColor: const Color.fromRGBO(255, 199, 0, 1),
                      errorColor: Colors.red,
                      labelStyle: null,
                      labelText: null,
                      floatingLabelStyle: null,
                      focusNode: null,
                      radius: 8,
                      hintText: "Phone Number",
                      borderWidth: 1,
                      backgroundColor: Colors.transparent,
                      decoration: null,
                      popUpErrorText: true,
                      autoFocus: false,
                      showCursor: false,
                      textInputAction: TextInputAction.done,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      errorTextMaxLength: 2,
                      errorPadding: const EdgeInsets.only(top: 14),
                      errorStyle: const TextStyle(
                          color: Colors.red, fontSize: 12, height: 1),
                      textStyle: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                      hintStyle: TextStyle(
                          color: Colors.black.withOpacity(0.5),
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                    ),
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
                          child: Text("Countinue",
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
                  )

                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}
