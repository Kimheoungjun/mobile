import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'chatroom.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home.dart';

class User {
  const User(this.region);
  final String region;
}

class Hobby{
  const Hobby(this.activity);
  final String activity;
}


class AddPage extends StatefulWidget {
  final FirebaseUser user;
  AddPage({Key key, @required this.user});
  State createState() => new AddPageState(user:user);
}



class AddPageState extends State<AddPage> {
  final FirebaseUser user;
  AddPageState({Key key, @required this.user});
//  @override
//  Widget build(BuildContext context) {
//    return MaterialApp(
//      title: 'Package Fonts',
//      home: MyHomePage(),
//    );
//}
  DateTime _date = new DateTime.now();
  TimeOfDay _time = new TimeOfDay.now();
  var formattedDate = DateFormat('yyyy-MM-dd');
  final nameController = TextEditingController();
  final dregionController = TextEditingController();
  final totalController = TextEditingController();
  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context:context,
      initialDate: _date,
      firstDate: new DateTime(2018),
      lastDate: new DateTime(2022)
    );

    if(picked != null && picked != _date){
      print("Date selected : ${_date.toString()}");
      setState((){
        _date = picked;
      });
    }
  }
  Future<Null> _selectTime(BuildContext context) async{
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: _time
    );
    if(picked != null && picked!=_time){
      setState((){
        _time=picked;
      });
    }
  }
  User selectedUser;
  Hobby selectedHobby;
  String theme;
  List<User> users = <User>[const User('서울'), const User('대구'), const User('포항')];
  List<Hobby> hobbies = <Hobby>[const Hobby('Overwatch'),const Hobby('Taxi'),const Hobby('Bowling'),const Hobby('LeagueOfLegend'),const Hobby('Soccer'),const Hobby('Game'),const Hobby('Study'),const Hobby('Sport')];

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
            iconTheme: IconThemeData(color:Colors.black),
            title: Text('모임 만들기',style: TextStyle(color:Colors.black),),backgroundColor: Color.fromRGBO(251, 252, 212, 1.0)),
    body: SafeArea(
        child: Container(
          color:Color.fromRGBO(251, 252, 212, 1.0),
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            children: <Widget>[
              SizedBox(height: 12.0),
              new Container(

                decoration: new BoxDecoration(
                  border: new Border.all(color: Colors.black54, width: 1.0),
                  borderRadius: new BorderRadius.circular(3.0),
                ),
                child:
                new DropdownButton<Hobby>(
                  hint: new Text("테마선택"),
                  iconSize: 0.0,
                  value: selectedHobby,
                  onChanged: (Hobby newValue) {
                    setState(() {
                      selectedHobby = newValue;
                      theme = newValue.toString();
                    });
                  },
                  items: hobbies.map((Hobby hobby) {
                    return new DropdownMenuItem<Hobby>(

                      value: hobby,
                      child: new Text(
                        hobby.activity,
                        style: new TextStyle(color: Colors.black),
                      ),
                    );
                  }).toList(),
                )
              ),
              SizedBox(height: 12.0),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  //icon: Icon(Icons.supervisor_account),
                  labelText: '모임 이름',
                ),
              ),
              SizedBox(height: 12.0),
      new Container(
          decoration: new BoxDecoration(
            border: new Border.all(color: Colors.black54, width: 1.0),
            borderRadius: new BorderRadius.circular(3.0),
          ),
          child:
              new DropdownButton<User>(
          hint: new Text("  활동 지역"),
          iconSize: 0.0,
          value: selectedUser,
          onChanged: (User newValue) {
            setState(() {
              selectedUser = newValue;
            });
          },
          items: users.map((User user) {
            return new DropdownMenuItem<User>(

              value: user,
              child: new Text(
                user.region,
                style: new TextStyle(color: Colors.black),
              ),
            );
          }).toList(),
      )
      ),
              SizedBox(height: 12.0),
              // TODO: Wrap Password with AccentColorOverride (103)
              TextField(
                controller: dregionController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  //icon: Icon(Icons.perm_identity),
                  labelText: '정확한 동네 입력(읍/면/동)',
                ),
              ),
              SizedBox(height: 12.0),
              // TODO: Wrap Password with AccentColorOverride (103)
              TextField(
                controller: totalController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  //icon: Icon(Icons.perm_identity),
                  labelText: '모임 정원(숫자만)',
                ),
              ),
              SizedBox(height: 12.0),

              Text('Date selected : ${formattedDate.format(_date)}'),
              SizedBox(height: 12.0),
                  RaisedButton(
                    child: Text('Select Date'),
                    onPressed: (){
                      _selectDate(context);
                    },
                    color: Color.fromRGBO(255,221,3,1.0),
                  ),
              SizedBox(height: 12.0),
              Text('Time selected : ${_time.hour} : ${_time.minute}'),
              SizedBox(height: 12.0),

              RaisedButton(
                child: Text('Select Time'),
                onPressed: (){
                  _selectTime(context);
                },
                color: Color.fromRGBO(255,221,3,1.0),
              ),




              SizedBox(height: 12.0),
                  RaisedButton(
                    child: Text('등록'),
                    elevation: 8.0,
                    color: Color.fromRGBO(255,221,3,1.0),
                    shape: BeveledRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(2.0)),
                    ),
                    onPressed: () {
                      String url = '';
                      selectedHobby.activity=='Overwatch'?
                      url = 'https://firebasestorage.googleapis.com/v0/b/mobile-project-4ee9b.appspot.com/o/Overwatch_circle_logo.svg.png?alt=media&token=b7c7f7f1-7efa-4d5f-bcbf-070b1fd75357':
                      selectedHobby.activity=='Taxi'?
                          url = 'https://firebasestorage.googleapis.com/v0/b/mobile-project-4ee9b.appspot.com/o/kisspng-logo-brand-font-product-line-taxi-465-kb-latest-version-for-free-downloa-5bf89303d4a5a9.599261051543017219871.png?alt=media&token=dffe0d55-33e9-418c-9a2f-381bae3e8490':
                      selectedHobby.activity=='Bowling'?
                          url = 'https://firebasestorage.googleapis.com/v0/b/mobile-project-4ee9b.appspot.com/o/kisspng-bowling-pin-sport-clip-art-5b00bde4d47840.6393476415267752688703.png?alt=media&token=45707691-8b00-4bf4-ab9d-945c410de669':
                      selectedHobby.activity=='LeagueOfLegend'?
                          url = 'https://firebasestorage.googleapis.com/v0/b/mobile-project-4ee9b.appspot.com/o/kisspng-league-of-legends-computer-icons-riven-riot-games-legends-5aeb2a5fea9ef1.395510301525361247961.png?alt=media&token=a8d93e49-c1ee-462d-9884-66333103fc0b':
                      selectedHobby.activity=='Soccer'?
                          url = 'https://firebasestorage.googleapis.com/v0/b/mobile-project-4ee9b.appspot.com/o/kisspng-football-player-stock-photography-royalty-free-man-playing-soccer-5a8e79a2b27b47.2951134815192866907311.png?alt=media&token=f2eb6b87-a274-4e01-9a48-35532c4cc3e0':
                      selectedHobby.activity=='Game'?
                          url = 'https://firebasestorage.googleapis.com/v0/b/mobile-project-4ee9b.appspot.com/o/kisspng-video-game-monster-hunter-world-game-controllers-gaming-vector-5adc397f5aedd2.7636681115243820793725.png?alt=media&token=764db092-7c49-426f-855b-b973c9ad3ef8':
                      selectedHobby.activity=='Study'?
                          url = 'https://firebasestorage.googleapis.com/v0/b/mobile-project-4ee9b.appspot.com/o/study-icon-7864.png?alt=media&token=7992c724-95e8-45ef-ba33-e27eb71bf8da':
                          url = 'https://firebasestorage.googleapis.com/v0/b/mobile-project-4ee9b.appspot.com/o/sport-1.png?alt=media&token=fba83a82-aaf1-402c-9734-e5eecffffa1a';
                      Map<String,dynamic> data={
                        'current':1,
                        'dregion':dregionController.text,
                        'id':DateTime.now().toString(),
                        'name':nameController.text,
                        'photo':url,
                        'region':selectedUser.region,
                        'theme': selectedHobby.activity,
                        'time':'${formattedDate.format(_date)} ${_time.hour}:${_time.minute}',
                        'total':int.parse(totalController.text),
                      };
                      final collRef = Firestore.instance.collection('list');
                      DocumentReference docReferance = collRef.document();
                      docReferance.setData(data).then((doc){
                        print('${docReferance.documentID}');
                        Firestore.instance.collection('list').document(docReferance.documentID).collection('chat').document().setData({'content':'방이 생성되었습니다','name':user.displayName,'time':'${DateTime.now().month}.${DateTime.now().day} ${DateTime.now().hour}:${DateTime.now().minute}'});
                        Firestore.instance.collection('list').document(docReferance.documentID).snapshots().listen((snapshot){
                          DocumentSnapshot document = snapshot;
                          Map<String,dynamic> data={
                            'id':document['id'],
                            'name': user.displayName,
                            'uid':user.uid,
                            'url':user.photoUrl
                          };
                          Firestore.instance.collection('join').document('${user.uid}${document['id']}').setData(data).whenComplete((){
                            Navigator.push(context,MaterialPageRoute(builder:(context)=>Home(i:4,user: user,theme:selectedHobby.activity,location: selectedUser.region,)));
                          });
                        });
                      });
                      //Navigator.pop(context);
                    },
                  ),


            ],
          ),
        ),
      ),
    );
  }
}



//class MyHomePage extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      // The AppBar will use the app-default Raleway font
//      appBar: AppBar(title: Text('모임 만들기'),backgroundColor: Colors.orangeAccent,),
//      body: SafeArea(
//        child: ListView(
//          padding: EdgeInsets.symmetric(horizontal: 24.0),
//          children: <Widget>[
//            SizedBox(height: 120.0),
//            TextField(
//              decoration: InputDecoration(
//                border: OutlineInputBorder(),
//                //icon: Icon(Icons.supervisor_account),
//                labelText: '모임 이름',
//              ),
//            ),
//            SizedBox(height: 12.0),
//             DropdownButton<String>(
//               hint: Text("활동 지역"),
//              items: <String>['서울', '부산', '대구', '인천'].map((String value) {
//                return new DropdownMenuItem<String>(
//                  value: value,
//                  child: new Text(value),
//                );
//              }).toList(),
//               onChanged: (User newValue) {
//                 setState(() {
//                   selectedUser = newValue;
//                 });
//               },
//            ),
//            // TODO: Wrap Password with AccentColorOverride (103)
//            TextField(
//              decoration: InputDecoration(
//                border: OutlineInputBorder(),
//                //icon: Icon(Icons.perm_identity),
//                labelText: '모임 정원(숫자만)',
//              ),
//            ),
//            SizedBox(height: 12.0),
//            new Container(
//
//                height: 100.0,
//                width: 50.0,
//                decoration: new BoxDecoration(
//                    border: new Border.all(color: Colors.black),
//                  borderRadius: BorderRadius.circular(5.0),
//                ),
//
//                child: new Column(
//                    crossAxisAlignment: CrossAxisAlignment.start,
//
//                children:<Widget>[
//                  Text("모임 한줄 소개(20자 제한)",style: TextStyle(fontSize: 15.0),),
//                Divider(height: 10.0,color: Colors.grey,),
//
//                TextField(
//
//                  decoration: InputDecoration(
//                      border: InputBorder.none,
//                      hintText: 'ex)라이딩! 하실 분'
//                  ),
//                  inputFormatters: [
//                    new LengthLimitingTextInputFormatter(40),
//                  ],
//                ),
//
//                ]),
//            ),
//
//
//
//                RaisedButton(
//                  child: Text('등록'),
//                  elevation: 8.0,
//                  color: Colors.orangeAccent,
//                  shape: BeveledRectangleBorder(
//                    borderRadius: BorderRadius.all(Radius.circular(2.0)),
//                  ),
//                  onPressed: () {
//                    //Navigator.pop(context);
//                  },
//                ),
//
//
//          ],
//        ),
//      ),
//    );
//  }
//}

