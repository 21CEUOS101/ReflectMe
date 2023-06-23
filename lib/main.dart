import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:journal/HomePage.dart';
import 'package:journal/SplashScreen.dart';
import 'BasePage.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget{

  @override
  Widget build(BuildContext context)
  {
    return const MaterialApp(
      title: 'Journal',
      debugShowCheckedModeBanner: false,

      home: SplashScreen(),
    );
  }
}