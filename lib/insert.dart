import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void insert() => runApp(MyApp());

class User {
  const User(this.region);
  final String region;
}

class Hobby{
  const Hobby(this.activity);
  final String activity;
}


class MyApp extends StatefulWidget {
  State createState() => new MyAppState();
}



class MyAppState extends State<MyApp> {

//  @override
//  Widget build(BuildContext context) {
//    return MaterialApp(
//      title: 'Package Fonts',
//      home: MyHomePage(),
//    );
//}
  User selectedUser;
  Hobby selectedHobby;
  List<User> users = <User>[const User('서울'), const User('부산'), const User('대구')];
  List<Hobby> hobbies = <Hobby>[const Hobby('게임'),const Hobby('스포츠'),const Hobby('여행')];

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: AppBar(title: Text('모임 만들기'),backgroundColor: Colors.orangeAccent),
    body: SafeArea(
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
                hint: new Text("  관심사"),
                iconSize: 0.0,
                value: selectedHobby,
                onChanged: (Hobby newValue) {
                  setState(() {
                    selectedHobby = newValue;
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
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                //icon: Icon(Icons.perm_identity),
                labelText: '모임 정원(숫자만)',
              ),
            ),
            SizedBox(height: 12.0),
            new Container(

                height: 100.0,
                width: 50.0,
                decoration: new BoxDecoration(
                    border: new Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(5.0),
                ),

                child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                children:<Widget>[
                  Text("모임 한줄 소개(20자 제한)",style: TextStyle(fontSize: 15.0),),
                Divider(height: 10.0,color: Colors.grey,),

                TextField(

                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'ex)라이딩! 하실 분'
                  ),
                  inputFormatters: [
                    new LengthLimitingTextInputFormatter(40),
                  ],
                ),

                ]),
            ),


            SizedBox(height: 12.0),
                RaisedButton(
                  child: Text('등록'),
                  elevation: 8.0,
                  color: Colors.orangeAccent,
                  shape: BeveledRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(2.0)),
                  ),
                  onPressed: () {
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

