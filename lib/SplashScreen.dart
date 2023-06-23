import 'dart:async';

import 'package:flutter/material.dart';
import 'package:journal/BasePage.dart';

class SplashScreen extends StatefulWidget{
  const SplashScreen({super.key});


  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 2) , (){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const BasePage()));
    });
  }
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Color(0xFF050406),

        child: const Center(
          child: Text('ReflectMe' , style: TextStyle(color: Color(0xFFE4E8EE) , fontWeight: FontWeight.bold , fontSize: 25,
              fontFamily: 'CascadiaCode'),),
        ),
      ),
    );
  }
}