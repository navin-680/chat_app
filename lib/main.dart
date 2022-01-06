import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'views/splash.dart';


Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(GetMaterialApp(
    theme: ThemeData(
      primaryColor: const Color(0xFF21BFBD),
      appBarTheme: const AppBarTheme(iconTheme:  IconThemeData(color: Colors.white)),
      textTheme: const TextTheme(
          headline1: TextStyle(
              fontSize: 30, color: Colors.black, fontWeight: FontWeight.bold),
          bodyText1: TextStyle(
              color: Colors.grey,
              fontSize: 16,
              fontWeight: FontWeight.normal),
          button:  TextStyle(color: Colors.white, fontSize: 18)),
      buttonTheme: ButtonThemeData(
          buttonColor: const Color(0xFF21BFBD),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
            // side: BorderSide(color: Colors.greenAccent)
          )),

      //inputDecorationTheme: InputDecorationTheme()
    ),
    title: 'Chat Application',
    home:  SplashScreen(),
  ));
}
