import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//import 'package:flutter/services.dart';
//import 'dart:io';
import 'dart:async';
//import 'package:shared_preferences/shared_preferences.dart';

void main() {
  StartUp().dataParser();
  Saved().printFriends();


  runApp(MyApp());
}

class LocalNotif extends StatefulWidget {
  @override
  _LocalNotifState createState() => _LocalNotifState();
}

class _LocalNotifState extends State<LocalNotif> {
  FlutterLocalNotificationsPlugin notifPlug = FlutterLocalNotificationsPlugin();
  AndroidInitializationSettings androidInitializationSettings;
  InitializationSettings initializationSettings;

  @override
  void initState()
  {
    super.initState();
    initializing();
  }
  void initializing()async
  {
    androidInitializationSettings = AndroidInitializationSettings('Assets/IMG_0810.JPG');
    initializationSettings = InitializationSettings(androidInitializationSettings,null);
    await notifPlug.initialize((initializationSettings, onSelectNotification: onSelectNotification));
  }

  Widget build(BuildContext context) {
    return Container();
  }
}


class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SelectPage(),
    );
  }
}

class DataSaver extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class StartUp {
  //var myFile = new File('Assets/Friends.txt');

  dataParser() {
    String data = readStart();

    String temp = '';
    String n = '';
    List<String> g = List<String>();
    String l = '';
    int c = 0;
    //0 is nothing 1 is name 2 is group and 3 is level

    for (int i = 0; i < data.length; i++) {
      if (data[i] == '[') {
        c++;
      } else if (data[i] == '|') {
        if (c == 1) {
          n = temp;
          c++;
          temp = '';
        } else if (c == 2) {
          g.add(temp);
          c++;
          temp = '';
        } else if (c == 3) {
          l = temp;
          c = 0;
          temp = '';
        }
      } else if (data[i] == ',') {
        g.add(temp);

        temp = '';
      } else if (data[i] == ']') {
        Saved().addFriend(n, g, int.parse(l));
        n = '';
        g = new List<String>();
        l = '';
      } else {
        temp += data[i].toString();
        //temp = temp + data[i].toString();
        //print('Logged letter');

      }
    }


  }
  //Doesn't update groups when adding a new person
  String readStart() {
    /*new File('Assets/Friends.txt').readAsString().then((String contents) {
     return (contents);
   });*/
    return ('[Liam|Family|9|][Katie|Friend,VT|3|][Matthew A|Aquantaince,School|2|][Addison|Friend,School|9|][AJ|Friend,School|2|][Kush|Friend,School|6|][Akhila|Friend,School|3|][Amber|Coworker|4|][Ashley|Friend|3|][Matthew|Friend|6|][Anjali|Friend,School|2|][Anvi|Friend|6|][Ares|Family,Friend|10|][Finn|Family,Friend|10|][Mom|Family|10|][Dad|Family|10|][Dan|Friend|10|][Will|Friend,School|10|][test|test|0|]');
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class FriendInfo extends StatefulWidget {
  @override
  _FriendInfoState createState() => _FriendInfoState();
}

//Custom Item classes
class Saved {
  static var friends = List<Friend>();
  static int numFriends = friends.length;
  static var groups = List<String>();

  addFriend(String name, List<String> group, int level) {
    friends.add(Friend(name: name, group: group, level: level));

    //print(friends.length);
    /*for(int i = 0; i < friends.length;i++)
   {


     print(friends[i].name + friends[i].group + friends[i].level.toString());
   }*/
  }

  List<String> GroupList(String type) {
    print('1');
    var g = List<String>();
    if (type == 'group') {
      print('2');
      for (int i = 0; i < friends.length; i++) { //Loops the # of friends there are
        print('3');
        /* if (i == 0) {
         g.add(friends[i].group);
       }*/
        for (int j = 0; j < friends[i].group.length; j++) { //Loops the length of i's group list
          print('4');
          if (!g.contains(friends[i].group[j])) {
            g.add(friends[i].group[j]);
          }
        }
      }
    }
    if (type == 'name') {
      for (int i = 0; i < friends.length; i++) {
        if (i == 0) {
          g.add(friends[i].name);
        } else if (!g.contains(friends[i].name)) {
          g.add(friends[i].name);
        }
      }
    }
    if (type == 'level') {
      for (int i = 0; i < friends.length; i++) {
        if (i == 0) {
          g.add(friends[i].level.toString());
        } else if (!g.contains(friends[i].level.toString())) {
          g.add(friends[i].level.toString());
        }
      }
    }
    g.sort();
    print(g);
    return g;
  }

  List<int> SortedFriendList(List<int> sList) {

    var nameList = List<String>();
    var tempList = List<int>();

    for (int i = 0; i < sList.length; i++) {
      nameList.add(friends[sList[i]].name);
    }
    nameList.sort();

    for (int i = 0; i < sList.length; i++) {
      if (nameList[i] != friends[sList[i]].name) {
        for (int j = 0; j < sList.length; j++) {
          if (nameList[i] == friends[sList[j]].name) {
            tempList.add(sList[j]);
          }
        }
      } else {
        tempList.add(sList[i]);
      }
    }
    print(tempList);
    return tempList;
  }

  List<int> SearchList(String type, String key) {
    var list = List<int>();
    if (type == 'name') {
      for (int i = 0; i < friends.length; i++) {
        if (friends[i].name == key) {
          list.add(i);
        }
      }
    }
    if (type == 'group') {

      for (int i = 0; i < friends.length; i++) {


        for(int j = 0; j < friends[i].group.length;j++) {

          if (friends[i].group[j] == key) {
            print(friends[i].group[j] + " " + friends[i].name);
            list.add(i);
          }
        }
      }
    }
    if (type == 'level') {
      for (int i = 0; i < friends.length; i++) {
        if (friends[i].level.toString() == key) {
          list.add(i);
        }
      }
    }

    //list.sort();
    //return list;

    return SortedFriendList(list);
  }

  int NumOfFriends() {
    return friends.length;
  }

  String FriendInfo(int num, int part) {

    if (part == 1) {

      return friends[num].name;
    } else if (part == 2) {
    } else if (part == 3) {


      return (friends[num].level).toString();
    }
  }

  List<String> FriendInfoGroup(int num) {
    var temp = List<String>();
    for (int i = 0; i < friends[num].group.length; i++) {
      temp.add(friends[num].group[i]);
    }

    return temp;
  }

  printFriends() {
    //print('hello');
    for (int i = 0; i < friends.length; i++) {
      print(friends[i].name + friends[i].level.toString());
      print(friends[i].group);

    }
  }
}

class Friend {
  final String name;
  final List<String> group;
  final int level;

  Friend({
    this.name,
    this.group,
    this.level,
  });
}

//Custom Input box
class CusInput extends StatelessWidget {
  final TextEditingController cont;

  CusInput({
    this.cont,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: cont,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.red,
            width: 5,
          ),
        ),
      ),
    );
  }
}

//Custom Text
class TextWid extends StatelessWidget {
  final String widText;

  TextWid({
    this.widText,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      widText,
      style: TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.bold,
        color: Colors.blue,
      ),
    );
  }
}

//Card that shows info
class DisplaySquare extends StatelessWidget {
  final String name;
  final List<String> group;
  final int level;

  String gText = '';
  DisplaySquare({this.name, this.group, this.level});

  String makeGroupText() {

    for (int i = 0; i < group.length; i++) {

      gText += group[i] + ',';


    }

    return gText;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 250,
              width: 350,
              padding: EdgeInsets.all(0),
              margin: EdgeInsets.all(20),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      FlatButton(
                        onPressed: () {},
                        padding: EdgeInsets.all(0),
                        child: Icon(Icons.more_horiz),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        width: 30,
                      ),
                      CircleAvatar(
                        backgroundColor: Colors.grey,
                        radius: 40,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            name,
                            style: TextStyle(fontSize: 18),
                          ),
                          Text(
                            makeGroupText(),
                            style: TextStyle(fontSize: 15),
                          ),
                          Text(
                            '05/08/2002',
                            style:
                            TextStyle(fontSize: 15, color: Colors.black45),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 35,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      FlatButton(
                        color: Colors.lightBlueAccent,
                        onPressed: () {},
                        child: Text('#'),
                      ),
                      FlatButton(
                        color: Colors.redAccent,
                        onPressed: () {},
                        child: Text('Deny'),
                      ),
                    ],
                  ),
                ],
              ),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ],
        ),
      ),
      /*child: Row(
         mainAxisAlignment: MainAxisAlignment.start,
         crossAxisAlignment: CrossAxisAlignment.start,
         children: <Widget>[
           Container(
             width: 100,
             decoration: BoxDecoration(
               color: Colors.grey,
               boxShadow: [

                 BoxShadow(
                   color: Colors.black,
                   blurRadius: 25,
                   spreadRadius: 2,
                   offset: Offset(
                     2,
                     2,
                   )
                 )
               ]
             ),
             child: Column(
               children: <Widget>[
                 FlatButton(
                   onPressed: (){},

                   color: Colors.blue,
                   child: Text("Add"),
                 ),
                 FlatButton(
                   onPressed: (){},
                   color: Colors.blue,
                   child: Icon(Icons.search),
                 ),
                 FlatButton(
                   onPressed: (){},
                   color: Colors.blue,
                   child: Icon(Icons.arrow_back),
                 ),



               ],
             ),
           )
         ],
       ),
     ),*/
    );
  }
}

//Button you click to view for example family group 3rd
class GroupButton extends StatelessWidget {
  final String prompt;
  final String type;
  final String keyWord;

  GroupButton({this.prompt, this.type, this.keyWord});

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      padding: EdgeInsets.all(0),
      color: Colors.blue,
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ViewPage(
                  fList: Saved().SearchList(type, keyWord),
                  type: keyWord,
                )));
      },
      child: Text(prompt),
    );
  }
}
//4th
class ViewPage extends StatelessWidget {
  final List<int> fList;
  final String type;

  ViewPage({this.fList, this.type});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(type),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            for (int i = 0; i < fList.length; i++)
              DisplaySquare(
                name: Saved().FriendInfo(fList[i], 1),
                group: Saved().FriendInfoGroup(fList[i]),
                level: int.parse(Saved().FriendInfo(fList[i], 3)),
              )

            /*DisplaySquare(
           name: Saved().FriendInfo(1, 1),
           group: Saved().FriendInfo(1, 2),
           level: int.parse(Saved().FriendInfo(1, 3)),
         ),*/
          ],
        ),
      ),
    );
  }
}

//End of Custom item Classes

class _MainPageState extends State<MainPage> {
  //String strFriends = loadAsset();
  final List<int> fList;

  _MainPageState({this.fList});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Socialite"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            for (int i = 0; i < fList.length; i++)
              DisplaySquare(
                name: Saved().FriendInfo(fList[i], 1),
                group: null,
                level: int.parse(Saved().FriendInfo(fList[i], 3)),
              )

            /*DisplaySquare(
           name: Saved().FriendInfo(1, 1),
           group: Saved().FriendInfo(1, 2),
           level: int.parse(Saved().FriendInfo(1, 3)),
         ),*/
          ],
        ),
      ),
    );
  }
}

class _FriendInfoState extends State<FriendInfo> {
  final nameCont = TextEditingController();
  final groupCont = TextEditingController();
  final levelCont = TextEditingController();

  String finalData = '';

  bool check(TextEditingController tCont) {
    if (tCont.text == '' || tCont.text == 'Please enter data') {
      tCont.text = 'Please enter data';
      return false;
    }
    return true;
  }

  void assebleData() {
    /*finalData = "[" + nameCont.text + "|" + groupCont.text + "|" +
   levelCont.text + "]";
   print(finalData);*/
    var conts = List<TextEditingController>();
    conts.add(nameCont);
    conts.add(groupCont);
    conts.add(levelCont);

    bool ok = true;

    for (TextEditingController te in conts) {
      if (!check(te)) {
        ok = false;
      }
    }
    if (ok) {
      var temp = List<String>();
      String wrd = '';
      for (int i = 0; i < groupCont.text.length; i++) {
        if (groupCont.text[i] == ',') {
          temp.add(wrd);
        } else {
          wrd += groupCont.text[i];
        }
      }

      Saved().addFriend(nameCont.text, temp, int.parse(levelCont.text));
      nameCont.text = '';
      groupCont.text = '';
      levelCont.text = '';
    }
  }

  void cancelData() {
    print(finalData);
    nameCont.text = '';
    groupCont.text = '';
    levelCont.text = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add/Edit'),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            /*Text(
             'Name',
             style: TextStyle(
               fontSize: 25,
               fontWeight: FontWeight.bold,
               color: Colors.blue,
             ),
           ),*/
            TextWid(
              widText: 'Name',
            ),
            SizedBox(
              height: 10,
            ),
            CusInput(
              cont: nameCont,
            ),
            SizedBox(
              height: 20,
            ),
            TextWid(
              widText: 'Group',
            ),
            SizedBox(
              height: 10,
            ),
            CusInput(
              cont: groupCont,
            ),
            SizedBox(
              height: 10,
            ),
            TextWid(
              widText: 'Level 1-10',
            ),
            SizedBox(
              height: 10,
            ),
            CusInput(
              cont: levelCont,
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                FlatButton(
                  color: Colors.greenAccent,
                  child: Text('Save'),
                  onPressed: () {
                    assebleData();
                  },
                ),
                FlatButton(
                  color: Colors.redAccent,
                  child: Text('Cancel'),
                  onPressed: () {
                    //cancelData();
                    Saved().printFriends();
                  },
                )
              ],
            ),
            FlatButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MainPage()));
              },
              child: Text('here'),
            ),
          ],
        ),
      ),
    );
  }
}

//Home Screen, shows selections like name, group, and level. 1st goes to search page
class SelectPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.grey,
          height: 800,
          padding: EdgeInsets.all(0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              FlatButton(
                color: Colors.blue,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SearchPage(
                            type: 'name',
                          )));
                },
                child: Text('Search by Name'),
              ),
              FlatButton(
                color: Colors.blue,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SearchPage(
                            type: 'group',
                          )));
                },
                child: Text('Search by Group'),
              ),
              FlatButton(
                color: Colors.blue,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SearchPage(
                            type: 'level',
                          )));
                },
                child: Text('Search by Level'),
              ),
              FlatButton(
                color: Colors.blue,
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => FriendInfo()));
                },
                child: Text('Add Friend'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//Is specific to category, example: shows the available groups. 2nd goes to group button
class SearchPage extends StatelessWidget {
  final String type;

  SearchPage({this.type});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Groups'),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.grey,
          height: 800,
          padding: EdgeInsets.all(0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              for (int i = 0; Saved().GroupList(type).length > i; i++)
                GroupButton(
                  prompt: Saved().GroupList(type)[i],
                  type: type,
                  keyWord: Saved().GroupList(type)[i],
                ),

              //GroupButton(prompt: Saved().GroupList(type)[0], type: type, keyWord: Saved().GroupList(type)[0],),
            ],
          ),
        ),
      ),
    );
  }
}

class GroupPage extends StatefulWidget {
  @override
  _GroupPageState createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Groups'),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.grey,
          height: 800,
          padding: EdgeInsets.all(0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              for (int i = 0; Saved().GroupList('group').length > i; i++)
                GroupButton(
                  prompt: Saved().GroupList('group')[i],
                  type: 'group',
                  keyWord: Saved().GroupList('group')[i],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

