import 'package:flutter/material.dart';
import 'home.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'dart:io';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'danolja',
      theme: new ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
        // counter didn't reset back to zero; the application is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: new LoginPage(title: 'Danolja'),
    );
  }
}

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {


  Future<String> _testSignInWithGoogle() async {
    final GoogleSignInAccount googleUser = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
    await googleUser.authentication;
    FirebaseUser user = await auth.signInWithGoogle(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    assert(user.email != null);
    assert(user.displayName != null);
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await auth.currentUser();
    assert(user.uid == currentUser.uid);

    print(user.uid);
    DateTime now = DateTime.now();
    var formattedDate = DateFormat('yyyy.MM.dd');
    Map<String,dynamic> data={
      'current' : formattedDate.format(now),
      'count':0,
      'name': user.displayName,
      'rel':0,
      'uid':user.uid,
      'url':user.photoUrl
    };
    Map<String,dynamic> data2={
      'current' : formattedDate.format(now),
      'name': user.displayName,
      'url':user.photoUrl
    };
    Firestore.instance.collection('user').document(user.uid).snapshots().isEmpty==true?
    Firestore.instance.collection('user').document(user.uid).setData(data,merge:true).whenComplete((){
      Navigator.push(context,MaterialPageRoute(builder:(context)=>Home(user:user,i:0)));
    }):
    Firestore.instance.collection('user').document(user.uid).updateData(data2).whenComplete((){
      Navigator.push(context,MaterialPageRoute(builder:(context)=>Home(user:user,i:0)));
    });
    
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Center(
        child: Container(
          color: Color.fromRGBO(246, 239, 239, 1.0),
          child: Column(
              children: [
                SizedBox(height:100.0,width:500.0),
                Image.network('https://firebasestorage.googleapis.com/v0/b/mobile-project-4ee9b.appspot.com/o/danolja.png?alt=media&token=190dadf5-ba05-4de3-aa96-934e704d5443',width:320.0),
                SizedBox(height:180.0),
                MaterialButton(
                  child: button('Google'),
                  onPressed:(){
                    setState((){
                      _testSignInWithGoogle();
                    });
                  },
                  color:Colors.white,
                ),
                SizedBox(height:5.0),
                MaterialButton(
                  child: button2('Facebook'),
                  onPressed:(){},
                  color:Color.fromRGBO(58,89,152,1.0),
                ),

              ]
          ),
        )
    );
  }
}

Widget button(title, [ color = const Color.fromRGBO(68, 68, 76, .8) ]) {
  return Container(
    width: 220.0,
    child: Center(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.network(
            'https://firebasestorage.googleapis.com/v0/b/mobile-project-4ee9b.appspot.com/o/google.png?alt=media&token=ef8cf6f7-9e14-4db7-baf9-2fc3b4fcf1fe',
            width: 30.0,
          ),
          Padding(
            child: Text(
              "Sign in with $title",
              style:  TextStyle(
                fontFamily: 'Roboto',
                color: color,
                fontSize: 20.0
              ),
            ),
            padding: new EdgeInsets.only(left: 15.0),
          ),
        ],
      ),
    ),
  );
}
Widget button2(title, [ color = const Color.fromRGBO(68, 68, 76, .8) ]) {
  return Container(
    width: 220.0,
    child: Center(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.network(
            'https://firebasestorage.googleapis.com/v0/b/mobile-project-4ee9b.appspot.com/o/facebook.png?alt=media&token=b1581425-3585-4214-ba54-909f068127b0',
            width: 30.0,
          ),
          Padding(
            child: Text(
              "Sign in with $title",
              style:  TextStyle(
                  fontFamily: 'Roboto',
                  color: Colors.white,
                  fontSize: 17.0
              ),
            ),
            padding: new EdgeInsets.only(left: 15.0),
          ),
        ],
      ),
    ),
  );
}