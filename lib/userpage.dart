import 'package:flutter/material.dart';
import 'main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home.dart';
import 'mypage.dart';

class UserPage extends StatefulWidget {
  final String user1;
  final FirebaseUser user;
  UserPage({Key ky, @required this.user, @required this.user1});
  @override
  _UserState createState() => _UserState(user:user,user1:user1);
}

class _UserState extends State<UserPage> {
  int i = 10;
  //////// Indicator
  final String user1;
  final FirebaseUser user;
  _UserState({Key ky, @required this.user, @required this.user1});
  double progressIndicatorValue = 0.0;
  void _showDialog() {
    // flutter defined function
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("신뢰도 평가"),
          content: new Text("해당 유저는 신뢰할만 합니까?"),

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

  void _onChanged(double value) {
    setState((){
      progressIndicatorValue = value;
    });
  }

  Widget _buildprofile(BuildContext context, DocumentSnapshot document){
    progressIndicatorValue = document['rel'].toDouble();
    return Container(
      color:Color.fromRGBO(246, 239, 239, 1.0),
      child: Center(
        child: Column(
          children: <Widget>[
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
            Image.network(document['url'],width: 200.0,height:200.0,),
            SizedBox(height: 10.0),
            Text(document['name'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0)),
            Text(progressIndicatorValue>=80?'Reliable Guy':progressIndicatorValue>=60?'Nice Guy':'Cool Guy'),
            Text('Recent ${document['current']}', style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey)),
            SizedBox(height: 10.0),
            Row(
              //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FloatingActionButton(
                  backgroundColor: Colors.redAccent,
                  child: IconButton(
                    icon: Icon(Icons.add_alert),
                    onPressed: null,
                  ),
                ),
                SizedBox(width: 20.0),
                FloatingActionButton(
                  backgroundColor: Colors.redAccent,
                  child: IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: null,
                  ),
                ),
                SizedBox(width: 20.0),
                FloatingActionButton(
                  backgroundColor: Colors.redAccent,
                  child: IconButton(
                    icon: Icon(Icons.map),
                    onPressed: null,
                  ),
                ),
              ],
            ),
            SizedBox(height: 15.0),
            Container(
              height:130.0,
              color: Color.fromRGBO(249, 247, 182, 1.0),
              child: Center(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding:EdgeInsets.fromLTRB(100.0, 20.0, 100.0, 5.0),
                      child: Row(
                          children: [
                            Icon(Icons.assignment_ind,color: Colors.red,size: 50.0,),
                            Flexible(
                              child: new GestureDetector(
                                onTap: (){
                                  _showDialog();
                                },
                                child: new Container(
                                  decoration: new BoxDecoration(  //튀어나와보이게 하는 효과. 터치할 수 있음을 유저에게 시각적으로 알려줌.
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.redAccent.withOpacity(0.5),
                                        offset: Offset(3.0, 3.0),
                                        blurRadius: 2.0,
                                      ),
                                    ],
                                  ),
                                  child: SizedBox(
                                    height:15.0,
                                    child: new LinearProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                                      backgroundColor: Colors.redAccent.withOpacity(0.5),
                                      value: progressIndicatorValue*.01,

                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ]
                      ),
                    ),
                    SizedBox(height: 5.0),
                    new Text('유저의 신뢰도는 ${document['rel'].toString()} 입니다.',
                      style: TextStyle(fontSize: 20.0,fontFamily: "Allura"),),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        iconTheme: IconThemeData(color:Colors.black),
        title:Text("유저평가",style: TextStyle(color: Colors.black),),
        backgroundColor:Color.fromRGBO(246, 239, 239, 1.0),
      ),
      body: StreamBuilder(
          stream: Firestore.instance.collection('user').where('uid',isEqualTo: user1).snapshots(),
          builder:(context,snapshot){
            if(!snapshot.hasData) return const Text('Loading...');
            return Center(
                child:ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) =>
                      _buildprofile(context, snapshot.data.documents[index]),
                )
            );
          }
      ),
    );
  }
}