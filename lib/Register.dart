import 'package:flutter/material.dart';
import 'package:journal/crud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'HomePage.dart';

import 'dart:math';

class Register extends StatefulWidget{
  const Register({super.key});


  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  late final JournalServices js;

  @override
  void initState() {
    // TODO: implement initState
    js = JournalServices();
    super.initState();
  }
  var userName = TextEditingController();

  var email = TextEditingController();

  var password = TextEditingController();

  var confirmPass = TextEditingController();

  var showPassword = false;

  var iconChange = Icons.remove_red_eye;

  @override
  Widget build(BuildContext context){

    return Scaffold(

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
                child:Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 30,left: 10),
                      child: SizedBox(
                        child: InkWell(
                          onTap: (){
                            Navigator.pop(context);
                          },
                          child: const Icon(Icons.subdirectory_arrow_left_rounded , color: Color(0xFFE4E8EE),size: 30,),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height/3,
                      child: Center(
                        child: Container(
                          child: RichText(
                            text: const TextSpan(
                              children: [
                                TextSpan(text: 'Unlock ' , style: TextStyle(color: Color(0xFFFF8800),fontFamily: 'um',fontSize: 45)),
                                TextSpan(text: 'your \n' , style: TextStyle(color: Color(0xFFE4E8EE),fontFamily: 'um',fontSize: 35)),
                                TextSpan(text: 'Inner' , style: TextStyle(color: Color(0xFFE4E8EE),fontFamily: 'um',fontSize: 35)),
                                TextSpan(text: ' Self ' , style: TextStyle(color: Color(0xFFFFFF00),fontFamily: 'um',fontSize: 45)),
                              ]
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height/2,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 80,
                            child: Container(
                              padding: const EdgeInsets.only(bottom : 15, right: 15 , left: 15),
                              child: TextField(
                                cursorRadius: const Radius.circular(10),

                                style: const TextStyle(color: Color(0xFFE4E8EE), fontSize: 15,
                                    fontFamily: 'cl'),
                                controller: userName,
                                decoration: InputDecoration(
                                  hintStyle: const TextStyle(color: Color(0xFFBDC1C6),fontFamily: 'ul'),
                                  hintText: 'Name',
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
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 80,
                            child: Container(
                              padding: const EdgeInsets.only(bottom : 15, right: 15 , left: 15),
                              child: TextField(
                                cursorRadius: const Radius.circular(10),

                                style: const TextStyle(color: Color(0xFFE4E8EE), fontSize: 15,
                                    fontFamily: 'cl'),
                                controller: email,
                                decoration: InputDecoration(
                                  hintStyle: const TextStyle(color: Color(0xFFBDC1C6),fontFamily: 'ul'),
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
                              padding: const EdgeInsets.only(right: 15 , left: 15),
                              child: TextField(
                                cursorRadius: const Radius.circular(10),

                                style: const TextStyle(color: Color(0xFFE4E8EE), fontSize: 15,
                                    fontFamily: 'cl'),
                                controller: password,
                                obscureText: showPassword,
                                obscuringCharacter: '*',
                                decoration: InputDecoration(
                                  hintStyle: const TextStyle(color: Color(0xFFBDC1C6),fontFamily: 'ul'),
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
                                    icon: Icon(iconChange,color: const Color(0xFFBDC1C6)),
                                    onPressed: (){
                                      setState(() {
                                        showPassword = !showPassword;
                                        if(!showPassword)
                                        {
                                          iconChange = Icons.remove_red_eye;
                                        }
                                        else
                                        {
                                          iconChange = Icons.visibility_off;
                                        }
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 80,
                            child: Container(
                              padding: const EdgeInsets.only(right: 15 , left: 15),
                              child: TextField(
                                cursorRadius: const Radius.circular(10),

                                style: const TextStyle(color: Color(0xFFE4E8EE), fontSize: 15,
                                    fontFamily: 'cl'),
                                controller: confirmPass,
                                obscureText: showPassword,
                                obscuringCharacter: '*',
                                decoration: InputDecoration(
                                  hintStyle: const TextStyle(color: Color(0xFFBDC1C6),fontFamily: 'ul'),
                                  hintText: 'Confirm Password',
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
                                    icon: Icon(iconChange,color: const Color(0xFFBDC1C6)),
                                    onPressed: (){
                                      setState(() {
                                        showPassword = !showPassword;
                                        if(!showPassword)
                                        {
                                          iconChange = Icons.remove_red_eye;
                                        }
                                        else
                                        {
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
                    SizedBox(
                      height: 50,
                      child: InkWell(

                        onTap: () async{
                          String name = userName.text.toString();
                          String emailId = email.text.toString();
                          String Password = password.text.toString();
                          String cpassword = confirmPass.text.toString();
                          
                          if(Password != cpassword)
                            {
                              return;
                            }

                          if(emailId != '')
                          {
                            await createUser(name : name , email : emailId , password : Password);
                            Navigator.push(context, MaterialPageRoute(builder: (context){ return HomePage();}));
                          }

                        },
                        child:Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Color(0xFFE4E8EE),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text('Register' , style : TextStyle(color: Color(0xFF050406), fontSize: 18,), textAlign: TextAlign.center,),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Storing user Info to database
  Future createUser({required String name, required String email, required String password}) async{

    var pref = await SharedPreferences.getInstance();
    var random = Random();
    var userId = random.nextInt(1000);
    pref.setInt('userId', userId);
    final user = await js.createUser(userId: userId, name: name, email: email, password: password);
    print(user);
  }
}