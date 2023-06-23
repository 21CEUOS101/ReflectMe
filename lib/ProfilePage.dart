
import 'package:flutter/material.dart';
import 'package:journal/BasePage.dart';
import 'package:journal/crud.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget{

  final int userId;
  ProfilePage({required this.userId});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  late final JournalServices js;

  late int userId;
  String? name;
  String? email;

  @override
  void initState() {
    // TODO: implement initState
    js = JournalServices();
    userId = widget.userId;
    getValues();
    super.initState();
  }

  Future getValues() async{
    try{
      User user = await js.getUser(userId: userId);
      setState(() {
        email = user.email;
        name = user.username;
      });
    }
    catch(e)
    {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context){
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              SizedBox(
                height : MediaQuery.of(context).size.height*0.17,
                child: Container(
                  margin: const EdgeInsets.only(left: 14),
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(Icons
                        .subdirectory_arrow_left_rounded,
                      color: Color(0xFFE4E8EE), size: 30,),
                  ),
                  ),
              ),

              Container(
                height: MediaQuery.of(context).size.height/2.5,
                alignment: Alignment.center,
                child: const CircleAvatar(
                  radius: 80,
                  backgroundImage: AssetImage('assests/images/60111.jpg'),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height/4,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'UserId : $userId',
                      style: const TextStyle(
                        color: Color(0xFFE4E8EE),
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        fontFamily: 'CascadiaCode',
                        height: 1.5,
                      ),textAlign: TextAlign.center,
                    ),
                    if (name != null)
                      Text(
                        'Name : $name',
                        style: const TextStyle(
                          color: Color(0xFFE4E8EE),
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          fontFamily: 'CascadiaCode',
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      )
                    else
                      const CircularProgressIndicator(), // Display a loading indicator while fetching the name
                    if (email != null)
                      Text(
                        'Email : $email',
                        style: const TextStyle(
                          color: Color(0xFFE4E8EE),
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          fontFamily: 'CascadiaCode',
                          height: 1.5,
                        ),textAlign: TextAlign.center,
                      )
                    else
                      const CircularProgressIndicator(), // Display a loading indicator while fetching the email
                  ],
                ),
              ),
              Container(
                alignment: Alignment.center,
                child: InkWell(
                  onTap: () async{
                    var pref = await SharedPreferences.getInstance();
                    pref.remove('userId');
                    Navigator.push(context, MaterialPageRoute(builder: (context) => BasePage()));
                  },
                  child: Container(

                    height: MediaQuery.of(context).size.height*0.06,
                    width: MediaQuery.of(context).size.width*0.3,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.red,
                    ),
                    child: const Text('Log Out' , style: TextStyle(
                        color: Color(0xFFE4E8EE),
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    fontFamily: 'CascadiaCode',
                    height: 1.5,
                  ),),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}