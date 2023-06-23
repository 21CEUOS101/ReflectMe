import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:journal/DisplayPage.dart';
import 'package:journal/MakePage.dart';
import 'package:intl/intl.dart';
import 'package:journal/ProfilePage.dart';
import 'package:journal/Register.dart';
import 'package:journal/crud.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget{

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late final JournalServices js;

  String formatDate(String dateString) {
    dateString = dateString.toString().substring(0,10);
    DateTime date = DateTime.parse(dateString);
    String formattedDate = DateFormat('EEE dd').format(date);
    return formattedDate;
  }

  int userId = 0;

  @override
  void initState() {
    super.initState();
    getId();
    js = JournalServices();
  }
  
  final CollectionReference _journals = FirebaseFirestore.instance.collection('journals');
  @override
  Widget build(BuildContext context)
  {
    DateTime? date = DateTime.now();

    return Scaffold(

      body:SingleChildScrollView(
        child: Stack(

          alignment: Alignment.bottomRight,
          children: [

            Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
            color: Color(0xFF050406),
            ),

                child:Container(
                  child: ListView(
                      children: [

                        SizedBox(
                          height: 100,
                          child:  Row(
                            children: [
                              IconButton(onPressed: (){
                                Navigator.pop(context);
                              }, icon: const Icon(Icons.arrow_back_ios_new_rounded , color: Color(0xFFE4E8EE),),),
                              SizedBox(
                                width : MediaQuery.of(context).size.width - 110,
                                child: const Center(
                                  child: Text('Your Journals',style: TextStyle(color: Color(0xFFE4E8EE) , fontWeight: FontWeight.bold , fontSize: 25,
                                          fontFamily: 'um' , height: 1.5),textAlign: TextAlign.center),
                                ),
                              ),
                              InkWell(onTap: () async{
                                  if(userId != null)
                                    {
                                      await Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage(userId: userId,)));
                                    }
                                  else
                                    {
                                      const CircularProgressIndicator(color: Colors.white,);
                                    }
                              },
                                  child: Container(alignment: Alignment.center,width : 50,child: const CircleAvatar(
                                    backgroundImage: AssetImage('assests/images/60111.jpg'),
                                    radius: 20,
                                  )))
                            ],
                          ),
                        ),
                        SizedBox(
                                height: MediaQuery.of(context).size.height,
                                width: MediaQuery.of(context).size.width,
                                child: FutureBuilder(
                                  future: js.getUser(userId: userId),
                                  builder: (context , snapshot){

                                    if(snapshot.connectionState == ConnectionState.done)
                                      {
                                        return StreamBuilder(
                                          stream: js.allJournalsById(userId),
                                          builder: (context,journalsnapshot){
                                            print(journalsnapshot);
                                            switch (journalsnapshot.connectionState) {
                                              case ConnectionState.waiting :
                                              case ConnectionState.active :
                                                if(journalsnapshot.hasData)
                                                {
                                                  return ListView.separated(itemBuilder: (context,index){
                                                    final List<Journal> data = journalsnapshot.data as List<Journal>;
                                                    return InkWell(
                                                      onTap: (){
                                                        Navigator.push(context, MaterialPageRoute(builder: (context)=> DisplayPage(journal: data[index],)));
                                                      },
                                                      child: Container(
                                                        decoration: BoxDecoration(

                                                            borderRadius: BorderRadius.circular(10),
                                                            border: Border.all(
                                                                color: Colors.deepPurple
                                                            ),
                                                            gradient: const LinearGradient(
                                                                colors: [
                                                                  Color(0xFFd4fc79),Color(0xFF96e6a1)
                                                                ]
                                                            )
                                                        ),
                                                        child: ListTile(
                                                          leading: Container(
                                                            width: 40,
                                                            decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.circular(10),
                                                                border: Border.all(
                                                                    color: const Color(0xFF050406),
                                                                    width: 1
                                                                )
                                                            ),
                                                            child: Column(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              children: [
                                                                Text(formatDate(data[index].dateAndtime)!.toString().substring(0,3),style: const TextStyle(color: Color(0xFF050406), fontFamily: 'um' , fontSize: 15)),
                                                                Text(formatDate(data[index].dateAndtime)!.toString().substring(4),style: const TextStyle(color: Color(0xFF050406), fontFamily: 'um' , fontSize: 15)),
                                                              ],
                                                            ),
                                                          ),
                                                          title: Text(data[index].title,style: const TextStyle(color: Color(0xFF050406)) , maxLines: 1, softWrap: true, overflow: TextOverflow.fade,),
                                                          subtitle: Text(data[index].subTitle,style: const TextStyle(color: Color(0xFF050406)) , maxLines: 1, softWrap: true, overflow: TextOverflow.fade,),
                                                          trailing: const Icon(Icons.arrow_forward_ios_rounded,color: Color(0xFF050406),),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                      separatorBuilder: (context,index){
                                                        return const Divider(height: 9, thickness: 0,);
                                                      },
                                                      itemCount: journalsnapshot.data!.length);
                                                }
                                                else
                                                {
                                                  return Center(
                                                    child: SizedBox(
                                                        width: MediaQuery.of(context).size.width*0.2,
                                                        height: MediaQuery.of(context).size.height*0.1,
                                                        child: const CircularProgressIndicator(color: Colors.blue,)),
                                                  );
                                                }
                                              default :
                                                return Center(
                                                  child: SizedBox(
                                                      width: MediaQuery.of(context).size.width*0.2,
                                                      height: MediaQuery.of(context).size.height*0.1,
                                                      child: const CircularProgressIndicator(color: Colors.white,)),
                                                );
                                            }

                                          },
                                        );
                                      }
                                      return Container(width: MediaQuery.of(context).size.width*0.2,
                                          height: MediaQuery.of(context).size.height*0.1,
                                          child: const CircularProgressIndicator(color: Colors.greenAccent,));

                                  }
                                )
                            ),
                      ],
                    ),
                ),
            ),

            Padding(
              padding: const EdgeInsets.only(bottom: 18 , right: 18),
              child: InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> MakePage()));
                },
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.black87,
                      width: 1,
                    ),
                    color: Colors.blue,
                  ),
                  child: const Icon(Icons.add),
                ),
              ),
            )
        ]),
      ),
    );
  }

  void getId() async{
    var pref = await SharedPreferences.getInstance();
    setState(() {
      userId = pref.getInt('userId')!;
      print('$userId ---------------------------');
    });

  }

}