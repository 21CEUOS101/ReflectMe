import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:journal/crud.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'HomePage.dart';
import 'Register.dart';

class SignIn extends StatefulWidget{

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  late final JournalServices js;

  @override
  void initState() {
    check();
    js = JournalServices();
    super.initState();
  }

  void check() async{
    var pref = await SharedPreferences.getInstance();

    int? userId = pref.getInt('userId');

    if(userId != null)
      {
        Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
      }
  }

  var iconChange = Icons.remove_red_eye;
  var showPassword = true;
  var email = TextEditingController();
  var password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      resizeToAvoidBottomInset: false,

      body: SingleChildScrollView(

        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            color: Color(0xFF050406),
          ),
          child: Column(
            children: [

              SizedBox(
                height: MediaQuery
                    .of(context)
                    .size
                    .height / 3,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Icon(Icons
                              .subdirectory_arrow_left_rounded,
                            color: Color(0xFFE4E8EE), size: 30,),
                        ),
                      ),
                      const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Let\'s Sign you in', style: TextStyle(
                                color: Color(0xFFE4E8EE),
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                                fontFamily: 'CascadiaCode',
                                height: 1.5),),
                            Text('Welcome Back.', style: TextStyle(
                                color: Color(0xFFE4E8EE), fontSize: 25,
                                fontFamily: 'cl', height: 1.5),),
                            Text('You\'ve been missed', style: TextStyle(
                                color: Color(0xFFE4E8EE), fontSize: 25,
                                fontFamily: 'cl', height: 1.5),)
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery
                    .of(context)
                    .size
                    .height / 2,
                child: Column(
                  children: [
                    SizedBox(
                      height: 80,
                      child: Container(
                        padding: const EdgeInsets.only(
                            bottom: 15, right: 15, left: 15),
                        child: TextField(
                          cursorRadius: Radius.circular(10),

                          style: const TextStyle(color: Color(0xFFE4E8EE),
                              fontSize: 15,
                              fontFamily: 'cl'),
                          controller: email,
                          decoration: InputDecoration(
                            hintStyle: const TextStyle(
                                color: Color(0xFFBDC1C6), fontFamily: 'ul'),
                            hintText: 'Email Id',
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: const BorderSide(
                                  color: Color(0xFFE4E8EE),
                                  width: 2,
                                )
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: const BorderSide(
                                  color: Color(0xFFBDC1C6),
                                )
                            ),
                            suffixIcon: const Icon(Icons.email),
                            suffixIconColor: const Color(0xFFBDC1C6),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(
                      height: 80,
                      child: Container(
                        padding: const EdgeInsets.only(right: 15, left: 15),
                        child: TextField(
                          cursorRadius: const Radius.circular(10),

                          style: const TextStyle(color: Color(0xFFE4E8EE),
                              fontSize: 15,
                              fontFamily: 'cl'),
                          controller: password,
                          obscureText: showPassword,
                          obscuringCharacter: '*',
                          decoration: InputDecoration(
                            hintStyle: const TextStyle(
                                color: Color(0xFFBDC1C6), fontFamily: 'ul'),
                            hintText: 'Password',
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: const BorderSide(
                                  color: Color(0xFFE4E8EE),
                                  width: 2,
                                )
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: const BorderSide(
                                  color: Color(0xFFBDC1C6),
                                )
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(iconChange, color: Color(0xFFBDC1C6)),
                              onPressed: () {
                                setState(() {
                                  showPassword = !showPassword;
                                  if (!showPassword) {
                                    iconChange = Icons.remove_red_eye;
                                  }
                                  else {
                                    iconChange = Icons.visibility_off;
                                  }
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 50,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Don\'t have an Account ?', style: TextStyle(
                                  color: Color(0xFFBDC1C6),
                                  fontSize: 14,
                                  fontFamily: 'ul')),
                              TextButton(onPressed: () =>
                              {
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) => Register(),))
                              }, child: Text('Register')),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 50,
                          child: InkWell(

                            onTap: () async {
                              var emailId = email.text.toString();
                              var pass = password.text.toString();

                              var pref = await SharedPreferences.getInstance();

                              try{
                                User user = await js.getUserByemail(email: emailId);
                                print(user);
                                pref.setInt('userId', user.userId);
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (context) => HomePage()));
                              }
                              catch(e)
                              {
                                print(e.toString());
                                Navigator.push(context, MaterialPageRoute(builder: (context) => Register()));
                              }
                            },
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Color(0xFFE4E8EE),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text('Sign In', style: TextStyle(
                                color: Color(0xFF050406), fontSize: 18,),
                                textAlign: TextAlign.center,),
                            ),
                          ),
                        )
                      ],
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
