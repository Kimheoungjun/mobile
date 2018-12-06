import 'package:flutter/material.dart';
import 'main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyPage extends StatefulWidget {
  final FirebaseUser user;
  MyPage({Key ky, @required this.user});
  @override
  _MyPageState createState() => _MyPageState(user:user);
}

class _MyPageState extends State<MyPage> {
  //////// Indicator
  final FirebaseUser user;
  _MyPageState({Key ky, @required this.user});
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
          content: new Text("자기 자신은 평가 할 수 없습니다."),

          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Yes", style: TextStyle(fontWeight: FontWeight.bold,color: Color.fromRGBO(255, 221, 3, 1.0))),
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
      height: 600.0,
      color:Colors.grey[100],
      child: Center(
        child: Column(
          children: <Widget>[
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
            Image.network(user.photoUrl,width: 200.0,height:200.0,),
            SizedBox(height: 10.0),
            Text(user.displayName, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0)),
            Text(progressIndicatorValue>=80?'Reliable Guy':progressIndicatorValue>=60?'Nice Guy':'Cool Guy'),
            Text('Recent ${document['current']}', style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey)),
            SizedBox(height: 10.0),
            Row(
              //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FloatingActionButton(
                  backgroundColor: Color.fromRGBO(255, 221, 3, 1.0),
                  child: IconButton(
                    icon: Icon(Icons.add_alert,color: Colors.black),
                    onPressed: null,
                  ),
                ),
                SizedBox(width: 20.0),
                FloatingActionButton(
                  backgroundColor:Color.fromRGBO(255, 221, 3, 1.0),
                  child: IconButton(
                    icon: Icon(Icons.calendar_today,color: Colors.black),
                    onPressed: null,
                  ),
                ),
                SizedBox(width: 20.0),
                FloatingActionButton(
                  backgroundColor: Color.fromRGBO(255, 221, 3, 1.0),
                  child: IconButton(
                    icon: Icon(Icons.map,color: Colors.black),
                    onPressed: null,
                  ),
                ),
              ],
            ),
            SizedBox(height: 15.0),
            Card(
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  color:Color.fromRGBO(255, 221, 3, 1.0),
                ),
              ),
              child: Container(
                height:130.0,
                width: 300.0,
                color: Colors.grey[100],
                child: Center(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding:EdgeInsets.fromLTRB(50.0, 20.0, 50.0, 5.0),
                        child: Row(
                            children: [
                              Icon(Icons.assignment_ind,color: Colors.black,size: 50.0,),
                              Flexible(
                                child: new GestureDetector(
                                    onTap: (){
                                      _showDialog();
                                    },
                                    child: new Container(
                                      decoration: new BoxDecoration(  //튀어나와보이게 하는 효과. 터치할 수 있음을 유저에게 시각적으로 알려줌.
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.5),
                                            offset: Offset(3.0, 3.0),
                                            blurRadius: 2.0,
                                          ),
                                        ],
                                      ),
                                      child: SizedBox(
                                        height:15.0,
                                        child: new LinearProgressIndicator(
                                          valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                                          backgroundColor: Colors.black.withOpacity(0.1),
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
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: Firestore.instance.collection('user').where('uid',isEqualTo: user.uid).snapshots(),
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