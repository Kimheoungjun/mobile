import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'chatroom.dart';
import 'mypage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'main.dart';
import 'dart:async';
import 'list.dart';
import 'package:flutter/foundation.dart';


class Home extends StatefulWidget {
  int i;
  String theme;
  String location;
  final FirebaseUser user;
  Home({Key ky, @required this.user, @required this.i,@required this.location,@required this.theme});
  @override
  _HomeState createState() => new _HomeState(user:user,i:i,location:location,theme:theme);
}

class _HomeState extends State<Home> {
  final FirebaseUser user;
  int i;
  String theme;
  String location;
  _HomeState({Key ky, @required this.user, @required this.i,@required this.location,@required this.theme});


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
                    backgroundColor: Color.fromRGBO(255,221, 3, 1.0),
                    radius: 60.0,
                    child: Image.network(list[index]['url'],width: 70.0,height:70.0)
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
              theme = list[index]['name'];
            });
          },
        );
      },
    );

    return new Scaffold(

      body: i==0?Container(
        color:Color.fromRGBO(251, 252, 212, 1.0),
        child: Column(
          children: [
            SizedBox(height:60.0,width:500.0),
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
            SizedBox(height:20.0,width:500.0),
            Flexible(
            child: Container(
              color:Color.fromRGBO(251, 252, 212, 1.0),
                child: myGridView),
          ),
          ]
        ),
      ):i==1?MyPage(user:user):i==4?ListPage(user:user,theme:theme,location: location,):null,
      bottomNavigationBar: Theme(
        data:Theme.of(context).copyWith(
          canvasColor: Color.fromRGBO(251,196, 3, 1.0),
          primaryColor: Colors.black,
        ),
        child: BottomNavigationBar(
          currentIndex: 0, // this will be set when a new tab is tapped
          items: [
            BottomNavigationBarItem(
              icon: new Icon(Icons.home,color: Colors.black,size: 30.0,),
              title: new Text('Home'),
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
            index==2?auth.signOut().then((value){
              Navigator.push(context,MaterialPageRoute(builder:(context)=>LoginPage(title:'danolja')));
            }):
            setState((){
              i=index;
            });
          }
        ),
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
    "id": "Soccer",
    "name": "Soccer",
    "url": "https://firebasestorage.googleapis.com/v0/b/mobile-project-4ee9b.appspot.com/o/kisspng-football-player-stock-photography-royalty-free-man-playing-soccer-5a8e79a2b27b47.2951134815192866907311.png?alt=media&token=f2eb6b87-a274-4e01-9a48-35532c4cc3e0",
    "color": Colors.cyan
  },
  {
    "id": "Game",
    "name": "Game",
    "url": "https://firebasestorage.googleapis.com/v0/b/mobile-project-4ee9b.appspot.com/o/kisspng-video-game-monster-hunter-world-game-controllers-gaming-vector-5adc397f5aedd2.7636681115243820793725.png?alt=media&token=764db092-7c49-426f-855b-b973c9ad3ef8",
    "color": Colors.purple
  },
  {
    "id": "Study",
    "name": "Study",
    "url": "https://firebasestorage.googleapis.com/v0/b/mobile-project-4ee9b.appspot.com/o/study-icon-7864.png?alt=media&token=7992c724-95e8-45ef-ba33-e27eb71bf8da",
    "color": Colors.red
  },
  {
    "id": "Sport",
    "name": "Sport",
    "url": "https://firebasestorage.googleapis.com/v0/b/mobile-project-4ee9b.appspot.com/o/sport-1.png?alt=media&token=fba83a82-aaf1-402c-9734-e5eecffffa1a",
    "color": Colors.amber
  },
];
