import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'chatroom.dart';
import 'mypage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'main.dart';
import 'dart:async';
import 'list.dart';


class Home extends StatefulWidget {
  int i;
  final FirebaseUser user;
  Home({Key ky, @required this.user, @required this.i});
  @override
  _HomeState createState() => new _HomeState(user:user,i:i);
}

class _HomeState extends State<Home> {
  final FirebaseUser user;
  int i;
  _HomeState({Key ky, @required this.user, @required this.i});


  @override
  Widget build(BuildContext context) {
    //var spacecrafts = ["James Web","Enterprise","Hubble","Kepler","Juno","Casini","Columbia","Challenger"];
    var myGridView = new GridView.builder(
      itemCount: list.length,
      gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
      itemBuilder: (BuildContext context, int index) {
        return new GestureDetector(
          child:
          new Column(
            //elevation: 5.0,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new SizedBox(
                child: new Container(
                  child: new CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 60.0,
                    child: Image.network('https://firebasestorage.googleapis.com/v0/b/mobile-project-4ee9b.appspot.com/o/kisspng-league-of-legends-computer-icons-riven-riot-games-legends-5aeb2a5fea9ef1.395510301525361247961.png?alt=media&token=a8d93e49-c1ee-462d-9884-66333103fc0b',width: 70.0,height:70.0)
                  ),

                  padding: const EdgeInsets.only(
                      left: 10.0, right: 10.0),
                ),
              ),
            ],
//                  : new Container(
//              alignment: Alignment.centerLeft,
//              margin: new EdgeInsets.only(top: 10.0, bottom: 10.0,left: 10.0),
//              child: new Text(spacecrafts[index]),
//            ),

          ),
          onTap: () {
            setState((){
              i=4;
            });
          },
        );
      },
    );

    return new Scaffold(

      body: i==0?Container(
        color:Color.fromRGBO(246, 239, 239, 1.0),
        child: Column(
          children: [
            SizedBox(height:60.0,width:500.0),
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
            SizedBox(height:20.0,width:500.0),
            Flexible(
            child: Container(
              color:Color.fromRGBO(246, 239, 239, 1.0),
                child: myGridView),
          ),
          ]
        ),
      ):i==2?MyPage(user:user):i==4?ListPage(user:user):null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0, // this will be set when a new tab is tapped
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.home,color: Colors.black,size: 30.0,),
            title: new Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.navigation,color: Colors.black,size: 30.0),
            title: new Text('location'),
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.person,color: Colors.black,size: 30.0),
              title: Text('Profile'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.exit_to_app,color: Colors.black,size: 30.0),
            title: Text('Logout'),
          )
        ],
        onTap:(index){
          index==3?auth.signOut().then((value){
            Navigator.push(context,MaterialPageRoute(builder:(context)=>LoginPage(title:'danolja')));
          }):
          setState((){
            i=index;
          });
        }
      ),
    );
  }
}


List list = [
  {
    "id": "All",
    "name": "All",
    "url": "https://firebasestorage.googleapis.com/v0/b/mobile-project-4ee9b.appspot.com/o/Icon_all.png?alt=media&token=20a02233-91cb-4ff5-81de-ddd48c8e364a",
    "color": Colors.teal
  },
  {
    "id": "Overwatch",
    "name": "Overwatch",
    "url": "https://firebasestorage.googleapis.com/v0/b/mobile-project-4ee9b.appspot.com/o/Overwatch_circle_logo.svg.png?alt=media&token=b7c7f7f1-7efa-4d5f-bcbf-070b1fd75357",
    "color": Colors.grey[600]
  },
  {
    "id": "Taxi",
    "name": "Taxi",
    "url": "https://firebasestorage.googleapis.com/v0/b/mobile-project-4ee9b.appspot.com/o/kisspng-logo-brand-font-product-line-taxi-465-kb-latest-version-for-free-downloa-5bf89303d4a5a9.599261051543017219871.png?alt=media&token=dffe0d55-33e9-418c-9a2f-381bae3e8490",
    "color": Colors.green[600]
  },
  {
    "id": "Bowling",
    "name": "Bowling",
    "url": "https://firebasestorage.googleapis.com/v0/b/mobile-project-4ee9b.appspot.com/o/kisspng-bowling-pin-sport-clip-art-5b00bde4d47840.6393476415267752688703.png?alt=media&token=45707691-8b00-4bf4-ab9d-945c410de669",
    "color": Colors.deepOrange
  },
  {
    "id": "LeagueOfLegend",
    "name": "LeagueOfLegend",
    "url": "https://firebasestorage.googleapis.com/v0/b/mobile-project-4ee9b.appspot.com/o/kisspng-league-of-legends-computer-icons-riven-riot-games-legends-5aeb2a5fea9ef1.395510301525361247961.png?alt=media&token=a8d93e49-c1ee-462d-9884-66333103fc0b",
    "color": Colors.orange
  },
  {
    "id": "general",


    "name": "General",
    "url": Icons.people,
    "color": Colors.cyan
  },
  {
    "id": "entertainment",
    "name": "Entertainment",
    "url": Icons.local_movies,
    "color": Colors.purple
  },
  {
    "id": "health-and-medical",
    "name": "Health and Medical",
    "url": Icons.local_hospital,
    "color": Colors.red
  },
  {
    "id": "music",
    "name": "Music",
    "url": Icons.music_note,
    "color": Colors.amber
  },
];