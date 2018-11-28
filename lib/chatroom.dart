import 'main.dart';
import 'package:flutter/material.dart';
import 'userpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Chatroom extends StatefulWidget {
  final FirebaseUser user;
  DocumentSnapshot document;
  Chatroom({Key key,@required this.document, @required this.user});
  @override
  ChatroomState createState() => new ChatroomState(document:document,user:user);
}

class ChatroomState extends State<Chatroom>{
  final FirebaseUser user;
  DocumentSnapshot document;
  ChatroomState({Key key,@required this.document, @required this.user});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView(
        children: [Container(

          color: Color.fromRGBO(246, 239, 239, 1.0),
          child: Column(
            children:[
              SizedBox(height:15.0,width:500.0),
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
              SizedBox(height:15.0),
              Container(
                color: Color.fromRGBO(252,223,179,1.0),
                child: Container(
                  width: 300.0,
                  child: Column(
                    children:[
                      SizedBox(height:5.0),
                      Text("${document['region']}, ${document['dregion']}",style:TextStyle(fontSize: 15.0,color: Colors.black,fontFamily: 'Roboto')),
                      SizedBox(height:5.0),
                      Text(document['time'],style:TextStyle(fontSize: 15.0,color: Colors.black,fontFamily: 'Roboto')),
                      SizedBox(height:5.0),
                      Text(document['theme'],style:TextStyle(fontSize: 15.0,color: Colors.black,fontFamily: 'Roboto')),
                      SizedBox(height:5.0),
                    ]
                  )
                )
              ),
              SizedBox(height:15.0),
              Container(
                color:Colors.white,
                width:350.0,
                height:380.0,
                child: Text("chat")
              ),
              SizedBox(height:20.0),
              /*Flexible(
                child: StreamBuilder(
                  stream:Firestore.instance.collection('join').where('id',isEqualTo: document['id']).snapshots(),
                  builder:(context,snapshot){
                    if(!snapshot.hasData) return const Text('Loading...');
                    return Center(
                      child:GridView.builder(
                        gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                        itemCount:snapshot.data.documents.length,
                        itemBuilder: (context, index) =>
                         buildUser(context,snapshot.data.documents[index]),
                      )
                    );
                  }
                ),
              ),*/
              Center(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [MaterialButton(
                      child:Text("Member"),
                      color:Colors.black,
                      textColor: Colors.white,
                      onPressed: (){},
                      ),
                  SizedBox(width:20.0),
                  MaterialButton(
                    child:Text("Exit"),
                    color:Colors.black,
                    textColor: Colors.white,
                    onPressed: (){},
                  )
                  ]
                ),
              ),
              SizedBox(height:20.0)
            ]
          )
        ),
        ]
      )
    );
  }

  Widget buildUser(BuildContext context, DocumentSnapshot document){
    return GestureDetector(
      onTap:(){
        Navigator.push(context,MaterialPageRoute(builder:(context)=>UserPage(user:user,user1:'qwRuRxMbDIbQrMRJ82jJz7eZwrL2')));
      },
      child: Container(
          width:60.0,
          height:60.0,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                  fit:BoxFit.fill,
                  image:NetworkImage(document['url']),
              )
          )
      ),
    );
  }
  void _showDialog() {
    // flutter defined function
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("신뢰도 평가"),
          content: Flex(
            direction: Axis.vertical,
            children: [Expanded(
              child: StreamBuilder(
                stream:Firestore.instance.collection('join').where('id',isEqualTo: document['id']).snapshots(),
                builder:(context,snapshot){
                  if(!snapshot.hasData) return const Text('Loading...');
                  return ListView.builder(
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (context,index)=>
                    buildUser(context, snapshot.data.documents[index]),
                  );
                }
              ),
            ),
            ]
          ),

          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Yes", style: TextStyle(fontWeight: FontWeight.bold)),
              onPressed: () {
                Navigator.of(context).pop();
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
}