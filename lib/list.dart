import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chatroom.dart';
import 'package:flutter/foundation.dart';
import 'home.dart';

enum LocationCharacter {All,Seoul,Daegu,Pohang}


class ListPage extends StatefulWidget{
  final FirebaseUser user;
  String theme;
  String location;
  ListPage({Key key, @required this.user, @required this.theme, @required this.location});
  @override
  ListPageState createState() => ListPageState(user:user, theme:theme, location: location);
}

class ListPageState extends State<ListPage> {
  LocationCharacter character = LocationCharacter.All;
  final FirebaseUser user;
  String theme;
  String location;
  ListPageState({Key key, @required this.user, @required this.theme, @required this.location});


  void _showDialog2() {
    // flutter defined function
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Location Select"),
          content: Column(
            children:[
              RadioListTile<LocationCharacter>(
                title:Text("전국"),
                value:LocationCharacter.All,
                groupValue: character,
                onChanged: (LocationCharacter value){
                  character = value;
                  Navigator.push(context,MaterialPageRoute(builder:(context)=>Home(user:user,i:4,location:"전국",theme:theme)));},
              ),
              RadioListTile<LocationCharacter>(
                title:Text("서울"),
                value:LocationCharacter.Seoul,
                groupValue: character,
                onChanged: (LocationCharacter value){
                  character = value;
                  Navigator.push(context,MaterialPageRoute(builder:(context)=>Home(user:user,i:4,location:"서울",theme:theme)));},
              ),
              RadioListTile<LocationCharacter>(
                title:Text("대구"),
                value:LocationCharacter.Daegu,
                groupValue: character,
                onChanged: (LocationCharacter value){
                  character = value;
                  Navigator.push(context,MaterialPageRoute(builder:(context)=>Home(user:user,i:4,location:"대구",theme:theme)));},
              ),
              RadioListTile<LocationCharacter>(
                title:Text("포항"),
                value:LocationCharacter.Pohang,
                groupValue: character,
                onChanged: (LocationCharacter value){
                  character = value;
                  Navigator.push(context,MaterialPageRoute(builder:(context)=>Home(user:user,i:4,location:"포항",theme:theme)));},
              ),
            ]
          ),

          actions: <Widget>[
            // usually buttons at the bottom of the dialog
          ],
        );
      },
    );
  }

  void _showDialog(DocumentSnapshot document) {
    // flutter defined function
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("JOIN"),
          content: new Text("방에 참여하시겠습니까?"),

          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Yes", style: TextStyle(fontWeight: FontWeight.bold)),
              onPressed: () {
                Map<String,dynamic> data={
                  'id':document['id'],
                  'name': user.displayName,
                  'uid':user.uid,
                  'url':user.photoUrl
                };
                Firestore.instance.collection('join').document('${user.uid}${document['id']}').setData(data).whenComplete((){
                  Firestore.instance.collection('list').document(document.documentID).updateData({'current':document['current']+1});
                  Navigator.push(context,MaterialPageRoute(builder:(context)=>Chatroom(document:document,user:user)));
                });
              },
            ),
            new FlatButton(
              child: new Text("No", style: TextStyle(fontWeight: FontWeight.bold)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget buildCards(BuildContext context, DocumentSnapshot document){
    return GestureDetector(
      onTap:(){
        Firestore.instance.collection('join').document('${user.uid}${document['id']}').snapshots().listen((snapshot){
          snapshot.exists?
          Navigator.push(context,MaterialPageRoute(builder:(context)=>Chatroom(document:document,user:user))):
          _showDialog(document);
        });
        // :
        //
        },
      child: new Card(
        elevation: 2.0,
        color: Color.fromRGBO(255,221,3,1.0),

        child: new Padding(
          padding: new EdgeInsets.all(10.0),
          child: new Column(

            children: <Widget>[

              new Row(
                children: <Widget>[
//                          new Padding(
//                            padding: new EdgeInsets.fromLTRB(16.0,30.0,16.0,30.0),
//                            child: new Text(f.format(new DateTime.now())),
//                          ),
                  new Container(
                      width: 100.0,
                      height: 120.0,
                      decoration: new BoxDecoration(
                          shape: BoxShape.rectangle,
                          image: new DecorationImage(
                            fit: BoxFit.fill,

                            image: new NetworkImage(
                                document['photo']),
                          )
                      )),
                  //Image.network('https://images.rapgenius.com/1a433cd9963fc4da8eec5c5e10119d2c.1000x713x1.jpg'),
//                          new Container(
//                            height: 30.0,
//                            width: 2.0,
//                            color: Colors.orangeAccent,
//                            margin: const EdgeInsets.only(left: 10.0, right: 10.0),
//                          ),
                  SizedBox(width:10.0),
                  Column(

                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:<Widget>[

//                          new Padding(
//                            padding: new EdgeInsets.all(5.0),
                        new Container(
                            child: new Text(
                                "[${document['region']}] ${document['name']}",
                                style: new TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                )
                              //textAlign: TextAlign.left,
                            )),
                        Row(
                            children:<Widget>[
                              new Icon(Icons.access_alarm,color:Colors.black),
                              SizedBox(width:5.0),
                              new Text(document['time']),
                            ]),
                        Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children:<Widget>[
                              new Icon(Icons.location_on,color:Colors.black),
                              SizedBox(width:5.0),
                              new Text(document['region']),
                            ]),
                        Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children:<Widget>[
                              new Icon(Icons.person,color:Colors.black),
                              SizedBox(width:5.0),
                              new Text("${document['current']}/${document['total']}명"),
                            ]),

                        //  ),
                      ]),
                ],
              ),

            ],
          ), ////
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    final f = new DateFormat('yyyy-MM-dd hh:mm');

    return MaterialApp(

      home: Scaffold(

          body:Container(
            color:Color.fromRGBO(251, 252, 212, 1.0),
            child: Column(
              children: [
                SizedBox(height:30.0,width:500.0),
                Container(
                  width: 250.0,
                  height: 60.0,
                  decoration: BoxDecoration(
                      image:DecorationImage(
                          image: NetworkImage("https://firebasestorage.googleapis.com/v0/b/mobile-project-4ee9b.appspot.com/o/danolja2.png?alt=media&token=d83043a9-e005-4c44-bb02-95d639ef70f2"),
                          fit: BoxFit.fill
                      )
                  ),
                ),
                SizedBox(height: 10.0),
                Center(
                  child:Column(
                    children:[
                      Text(theme.toUpperCase()),
                      GestureDetector(
                        onTap:(){
                          _showDialog2();
                        },
                          child: Text(location==null?"전 국":'${location}')
                      ),
                    ]
                  )
                ),
                Flexible(
                child: StreamBuilder(
                  stream:theme=="All"?location=='전국'?Firestore.instance.collection('list').snapshots():Firestore.instance.collection('list').where('region',isEqualTo: location).snapshots():Firestore.instance.collection('list').where("theme",isEqualTo: theme).where('location',isEqualTo: location).snapshots(),
                  builder:(context,snapshot){
                    if(!snapshot.hasData) return const Text('\n\n\n\nLoading...',style:TextStyle(fontSize: 20.0));
                    return ListView.builder(
                        padding: EdgeInsets.all(15.0),
                        itemCount: snapshot.data.documents.length,

                        itemBuilder: (context,index) =>
                            buildCards(context,snapshot.data.documents[index]),

                    );
                  }

                ),
              ),

              ]
            ),
          )
      ),
    );
  }
}

var list = ["[강남]직장인모임","[영화]신비한동물사전","[악기]통기타 스터디","[게임]배그 한판","[한강]산책 하실 분"];
var location = ["강남","홍대","잠실","선릉","한강"];

