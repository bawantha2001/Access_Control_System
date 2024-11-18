import 'package:access_control_system/screens/wrapper.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

  Future<void> main() async {
    WidgetsFlutterBinding.ensureInitialized();

    await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: "AIzaSyCN3zIwa-fSL2jWrgPgk-8cr7J7GEeqBIw",
          appId: "1:507776540765:android:5ff51a04b26283425c6db4",
          messagingSenderId: "507776540765",
          projectId: "access-control-system-28125",
          databaseURL: 'https://access-control-system-28125-default-rtdb.asia-southeast1.firebasedatabase.app',
        )
    );

    await FirebaseAppCheck.instance.activate(
      webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),
      androidProvider: AndroidProvider.debug,
      appleProvider: AppleProvider.appAttest,
    );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Access Control System',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),

      home: Wrapper(),
    );
  }
}

