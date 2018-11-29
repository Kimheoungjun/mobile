import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chatroom.dart';


class ListPage extends StatefulWidget{
  final FirebaseUser user;
  String theme;
  ListPage({Key key, @required this.user, @required this.theme});
  @override
  ListPageState createState() => ListPageState(user:user, theme:theme);
}

class ListPageState extends State<ListPage> {
  final FirebaseUser user;
  String theme;
  ListPageState({Key key, @required this.user, @required this.theme});
  Widget buildCards(BuildContext context, DocumentSnapshot document){
    return GestureDetector(
      onTap:(){Navigator.push(context,MaterialPageRoute(builder:(context)=>Chatroom(document:document,user:user)));},
      child: new Card(
        elevation: 2.0,

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
                              new Icon(Icons.access_alarm,color:Colors.blue),
                              SizedBox(width:5.0),
                              new Text(document['time']),
                            ]),
                        Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children:<Widget>[
                              new Icon(Icons.location_on,color:Colors.blue),
                              SizedBox(width:5.0),
                              new Text(document['region']),
                            ]),
                        Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children:<Widget>[
                              new Icon(Icons.person,color:Colors.blue),
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
            color:Color.fromRGBO(246, 239, 239, 1.0),
            child: Column(
              children: [
                SizedBox(height:30.0,width:500.0),
                Container(
                  width: 250.0,
                  height: 60.0,
                  decoration: BoxDecoration(
                      image:DecorationImage(
                          image: NetworkImage("https://firebasestorage.googleapis.com/v0/b/mobile-project-4ee9b.appspot.com/o/danolja.png?alt=media&token=190dadf5-ba05-4de3-aa96-934e704d5443"),
                          fit: BoxFit.fill
                      )
                  ),
                ),
                SizedBox(height: 10.0),
                Center(
                  child:Column(
                    children:[
                      Text(theme.toUpperCase()),
                      Text("Location"),
                    ]
                  )
                ),
                Flexible(
                child: StreamBuilder(
                  stream:theme=="All"?Firestore.instance.collection('list').snapshots():Firestore.instance.collection('list').where("theme",isEqualTo: theme).snapshots(),
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