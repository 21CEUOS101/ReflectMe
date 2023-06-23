import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:journal/crud.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MakePage extends StatefulWidget{

  @override
  State<MakePage> createState() => _MakePageState();
}

class _MakePageState extends State<MakePage> {

  late final JournalServices js;
  @override
  void initState() {
    // TODO: implement initState
    js = JournalServices();
    super.initState();
  }

  var date = DateTime.now().toString();

  var title = TextEditingController();

  var subtitle = TextEditingController();

  var content = TextEditingController();

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          color: Color(0xFF050406),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [Container(
                  margin: const EdgeInsets.only(top: 15),
                  alignment: Alignment.topLeft,
                  height: 60,
                  child: IconButton(onPressed: (){
                    Navigator.pop(context);
                  }, icon: const Icon(Icons.arrow_back_ios_new_rounded , color: Color(0xFFE4E8EE),),),
          ),
                  SizedBox(width: MediaQuery.of(context).size.width-100,),

                  Container(
                    margin: EdgeInsets.only(top: 15),
                    alignment: Alignment.topRight,
                    height: 60,
                    child: IconButton(onPressed: () async{

                      await createJournal(title : title.text.toString() , subtitle : subtitle.text.toString() , content : content.text.toString() , date : date);
                      Navigator.pop(context);
                    }, icon: const Icon(Icons.save , color: Color(0xFFE4E8EE),),),
                  ),
              ]),
              SizedBox(
                height: 70,
                child: TextField(
                  cursorRadius: const Radius.circular(10),

                  style: const TextStyle(color: Color(0xFFE4E8EE), fontSize: 15,
                      fontFamily: 'cl'),
                  controller: title,
                  decoration: InputDecoration(
                    hintStyle: const TextStyle(color: Color(0xFFBDC1C6),fontFamily: 'ul'),
                    hintText: 'Title',
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
              SizedBox(
                height: 70,
                child: TextField(
                  cursorRadius: Radius.circular(10),

                  style: const TextStyle(color: Color(0xFFE4E8EE), fontSize: 15,
                      fontFamily: 'cl'),
                  controller: subtitle,
                  decoration: InputDecoration(
                    hintStyle: const TextStyle(color: Color(0xFFBDC1C6),fontFamily: 'ul'),
                    hintText: 'SubTitle',
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
              SizedBox(
                child: TextField(
                  maxLines: null,
                  minLines: 1,
                  cursorRadius: const Radius.circular(10),

                  style: const TextStyle(color: Color(0xFFE4E8EE), fontSize: 15,
                      fontFamily: 'cl'),
                  controller: content,
                  decoration: InputDecoration(
                    hintStyle: const TextStyle(color: Color(0xFFBDC1C6),fontFamily: 'ul'),
                    hintText: 'Content',
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(
                          color: Color(0xFF050406),
                          width: 2,
                        )
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(
                          color: Color(0xFF050406),
                        )
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future createJournal({required title, required subtitle, required content, required date}) async{
    var pref = await SharedPreferences.getInstance();

    int userid = pref.getInt('userId') as int;
    final note = await js.createJournal(ownerId: userid, title: title, subTitle: subtitle, content: content, dateAndtime: date);
    print(note);
  }
}