import 'package:flutter/material.dart';
import 'package:journal/Register.dart';

import 'SignIn.dart';

class BasePage extends StatelessWidget{
  const BasePage({super.key});


  @override
  Widget build(BuildContext context)
  {
    width: MediaQuery.of(context).size.width;
    height: MediaQuery.of(context).size.height;

    return Scaffold(

      resizeToAvoidBottomInset: false,
      body: Container(
        height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          color: Color(0xFF050406),
        ),
        child: Column(
          children:[
            SizedBox(
                height: MediaQuery.of(context).size.height/1.8,
                child: Center(
              child: Container(
                padding: const EdgeInsets.all(15),
                child: Image.asset('assests/images/base.png'),
              ),
            )),
            SizedBox(
                height: MediaQuery.of(context).size.height/3.9,
                child: Center(
              child: Column(
                children: [
                  Container(
                    child: const Text(
                      'Embrace the Power of Journaling',
                      style: TextStyle(color: Color(0xFFE4E8EE) , fontWeight: FontWeight.bold , fontSize: 25,
                          fontFamily: 'um' , height: 1.5),textAlign: TextAlign.center
                    ),
                  ),
                  
                  Container(
                      padding: EdgeInsets.all(20),
                      child: Text('Journaling app designed for everyone seeking personal growth, self-discovery, and mindfulness. Capture your thoughts, feelings, and experiences each day in a secure and private space. ' ,
                    style: TextStyle(color: Color(0xFFBDC1C6), fontFamily: 'ul', height: 1.4),textAlign: TextAlign.center,))

                ],
              ),
            )),
            SizedBox(
              width: MediaQuery.of(context).size.width*0.68,
              height: MediaQuery.of(context).size.height*0.18,
                child: Center(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: const Color(0xFFBDC1C6),
                ),

                child: Row(

                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: ()=>{
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const Register(),))
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width*0.35,
                        height: 60,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                        ),
                        child: const Text('Register', style: TextStyle(color: Color(0xFF050406), fontSize: 15,), textAlign: TextAlign.center),
                      ),
                    ),
                    InkWell(
                      onTap: ()=>{
                        Navigator.push(context, MaterialPageRoute(builder: (context) => SignIn(),))
                      },
                      child: Container(
                        width: 125,
                        height: 60,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: const Color(0xFFBDC1C6),
                        ),
                        child: const Text('Sign In', style: TextStyle(color: Color(0xFF050406), fontSize: 15 ,), textAlign: TextAlign.center),
                      ),
                    )
                  ],
                ),
              ),
            ))
          ]
        ),
      ),
    );
  }
}