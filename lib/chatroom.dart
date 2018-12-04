import 'main.dart';
import 'package:flutter/material.dart';
import 'userpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'home.dart';

final textController = TextEditingController();

class Chatroom extends StatefulWidget {
  final FirebaseUser user;
  DocumentSnapshot document;
  Chatroom({Key key,@required this.document, @required this.user});
  @override
  ChatroomState createState() => new ChatroomState(document:document,user:user);
}

class ChatroomState extends State<Chatroom> {
  final FirebaseUser user;
  DocumentSnapshot document;

  ScrollController controller = ScrollController();
  ChatroomState({Key key, @required this.document, @required this.user});

  void _showDialog(DocumentSnapshot document) {
    // flutter defined function
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("EXIT"),
          content: new Text("방에서 나가시겠습니까?"),

          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Yes", style: TextStyle(fontWeight: FontWeight.bold)),
              onPressed: () {
                Firestore.instance.collection('join').document('${user.uid}${document['id']}').delete().whenComplete((){
                  Firestore.instance.collection('list').document(document.documentID).updateData({'current':document['current']-1});
                  Navigator.push(context,MaterialPageRoute(builder:(context)=>Home(user:user,i:0,location:null,theme:null)));
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

  @override
  Widget build(BuildContext context) {
    return Center(
        child: ListView(
            children: [Container(

                color: Color.fromRGBO(251, 252, 212, 1.0),
                child: Column(
                    children: [
                      SizedBox(height: 15.0, width: 500.0),
                      Container(
                        width: 250.0,
                        height: 60.0,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(
                                    "https://firebasestorage.googleapis.com/v0/b/mobile-project-4ee9b.appspot.com/o/danolja2.png?alt=media&token=d83043a9-e005-4c44-bb02-95d639ef70f2"),
                                fit: BoxFit.fill
                            )
                        ),
                      ),
                      SizedBox(height: 15.0),
                      Container(
                          color: Color.fromRGBO(255, 221, 3, 1.0),
                          child: Container(
                              width: 300.0,
                              child: Column(
                                  children: [
                                    SizedBox(height: 5.0),
                                    Text(
                                        "${document['region']}, ${document['dregion']}",
                                        style: TextStyle(fontSize: 15.0,
                                            color: Colors.black,
                                            fontFamily: 'Roboto')),
                                    SizedBox(height: 5.0),
                                    Text(document['time'], style: TextStyle(
                                        fontSize: 15.0,
                                        color: Colors.black,
                                        fontFamily: 'Roboto')),
                                    SizedBox(height: 5.0),
                                    Text(document['theme'], style: TextStyle(
                                        fontSize: 15.0,
                                        color: Colors.black,
                                        fontFamily: 'Roboto')),
                                    SizedBox(height: 5.0),
                                  ]
                              )
                          )
                      ),
                      SizedBox(height: 15.0),
                      Container(
                          color: Colors.white,
                          width: 350.0,
                          height: 330.0,
                          child: StreamBuilder(
                            stream:Firestore.instance.collection('list').document(document.documentID).collection('chat').orderBy('time',descending: false).snapshots(),
                            builder: (context, snapshot){
                              if(!snapshot.hasData) return Text("Loading....");
                              return ListView.builder(
                                controller: controller,
                                reverse:true,
                                itemCount: snapshot.data.documents.length,
                                itemBuilder: (context,index)=>
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children:[
                                      SizedBox(height:10.0),
                                      Padding(
                                        padding:EdgeInsets.fromLTRB(2.0, 0.0, 2.0, 0.0),
                                        child: Container(
                                          width:300.0,
                                          decoration: BoxDecoration(
                                            color:Color.fromRGBO(251,196,3,1.0),
                                            borderRadius: BorderRadius.circular(10.0)
                                          ),
                                          child: Card(
                                            elevation: 10.0,
                                            color: Color.fromRGBO(251,196,3,1.0),
                                            child: Padding(
                                              padding:EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
                                              child: Row(children:[
                                                Expanded(child: Text("${snapshot.data.documents[index]['name']} : ${snapshot.data.documents[index]['content']}",style: TextStyle(fontSize: 18.0,color: Colors.black),overflow: TextOverflow.clip,softWrap: true,)),
                                                Text(snapshot.data.documents[index]['time'],style: TextStyle(fontSize: 13.0,color: Colors.grey),overflow: TextOverflow.clip,softWrap: true,)
                                              ]),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height:10.0)
                                    ]
                                  ),
                              );
                            },
                          )
                      ),
                      Container(
                        width:350.0,
                        color:Colors.white,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [SizedBox(
                            width:290.0,
                            child:TextField(
                              controller: textController,
                              decoration: InputDecoration(
                                filled:true,
                                labelText:'input message'
                              )
                            )
                          ),
                            SizedBox(
                              width:20.0,
                              child: IconButton(
                                iconSize: 30.0,
                                icon:Icon(Icons.send),
                                onPressed: (){
                                  var formattedDate = DateFormat('MM.dd hh:mm');
                                  DateTime now = DateTime.now();
                                  Map<String,dynamic> data={
                                    'time' : formattedDate.format(now),
                                    'content':textController.text,
                                    'name':user.displayName,
                                  };
                                  textController.text==""?null:
                                  Firestore.instance.collection('list').document(document.documentID).collection('chat').document().setData(data);
                                  textController.clear();
                                  setState((){
                                    print("yes");
                                  });
                                },
                              ),
                            )
                          ]
                        ),
                      ),
                      SizedBox(height: 20.0),

                      Center(
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [MaterialButton(
                              child: Text("Member"),
                              color: Colors.black,
                              textColor: Colors.white,
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder:(BuildContext context){
                                    return new MyAlertDialog(
                                      title:Text("참여멤버"),
                                      actions:<Widget>[
                                        RaisedButton(
                                          child:Text("OK"),
                                          onPressed: (){
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                      content: Column(
                                        children: [Flexible(
                                          child: StreamBuilder(
                                            stream:Firestore.instance.collection('join').where('id',isEqualTo: document['id']).snapshots(),
                                            builder:(context,snapshot){
                                              if(!snapshot.hasData) return const Text('Loading...');
                                              return ListView.builder(
                                                itemCount:snapshot.data.documents.length,
                                                itemBuilder: (context,index) =>
                                                buildUser(context,snapshot.data.documents[index]),
                                              );
                                            }
                                          ),
                                        ),
                                          Text("이름을 클릭하면 유저의 정보를 볼 수 있습니다.",style:TextStyle(fontSize: 13.0))
                                        ]
                                      ),
                                    );
                                  }
                                );
                              },
                            ),
                            SizedBox(width: 20.0),
                            MaterialButton(
                              child: Text("Exit"),
                              color: Colors.black,
                              textColor: Colors.white,
                              onPressed: () {
                                _showDialog(document);
                              },
                            )
                            ]
                        ),
                      ),
                      SizedBox(height: 20.0)
                    ]
                )
            ),
            ]
        )
    );
  }

  Widget buildUser(BuildContext context, DocumentSnapshot document) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) =>
            UserPage(user: user, user1: document['uid'])));
      },
      child: Padding(
        padding: EdgeInsets.fromLTRB(15.0, 20.0, 0.0, 0.0),
        child: Row(
          children: [SizedBox(
            width:60.0,
            height:60.0,
            child: Container(
                width: 60.0,
                height: 60.0,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: NetworkImage(document['url']),
                    )
                )
            ),
          ),
          SizedBox(
              width:20.0
          ),
            Text(document['name'],style:TextStyle(fontSize: 20.0))
          ]
        ),
      ),
    );
  }
}

class MyAlertDialog extends StatelessWidget {
  /// Creates an alert dialog.
  ///
  /// Typically used in conjunction with [showDialog].
  ///
  /// The [contentPadding] must not be null. The [titlePadding] defaults to
  /// null, which implies a default that depends on the values of the other
  /// properties. See the documentation of [titlePadding] for details.
  const MyAlertDialog({
    Key key,
    this.title,
    this.titlePadding,
    this.content,
    this.contentPadding = const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 24.0),
    this.actions,
    this.semanticLabel,
  }) : assert(contentPadding != null),
        super(key: key);

  /// The (optional) title of the dialog is displayed in a large font at the top
  /// of the dialog.
  ///
  /// Typically a [Text] widget.
  final Widget title;

  /// Padding around the title.
  ///
  /// If there is no title, no padding will be provided. Otherwise, this padding
  /// is used.
  ///
  /// This property defaults to providing 24 pixels on the top, left, and right
  /// of the title. If the [content] is not null, then no bottom padding is
  /// provided (but see [contentPadding]). If it _is_ null, then an extra 20
  /// pixels of bottom padding is added to separate the [title] from the
  /// [actions].
  final EdgeInsetsGeometry titlePadding;

  /// The (optional) content of the dialog is displayed in the center of the
  /// dialog in a lighter font.
  ///
  /// Typically, this is a [ListView] containing the contents of the dialog.
  /// Using a [ListView] ensures that the contents can scroll if they are too
  /// big to fit on the display.
  final Widget content;

  /// Padding around the content.
  ///
  /// If there is no content, no padding will be provided. Otherwise, padding of
  /// 20 pixels is provided above the content to separate the content from the
  /// title, and padding of 24 pixels is provided on the left, right, and bottom
  /// to separate the content from the other edges of the dialog.
  final EdgeInsetsGeometry contentPadding;

  /// The (optional) set of actions that are displayed at the bottom of the
  /// dialog.
  ///
  /// Typically this is a list of [FlatButton] widgets.
  ///
  /// These widgets will be wrapped in a [ButtonBar], which introduces 8 pixels
  /// of padding on each side.
  ///
  /// If the [title] is not null but the [content] _is_ null, then an extra 20
  /// pixels of padding is added above the [ButtonBar] to separate the [title]
  /// from the [actions].
  final List<Widget> actions;

  /// The semantic label of the dialog used by accessibility frameworks to
  /// announce screen transitions when the dialog is opened and closed.
  ///
  /// If this label is not provided, a semantic label will be infered from the
  /// [title] if it is not null.  If there is no title, the label will be taken
  /// from [MaterialLocalizations.alertDialogLabel].
  ///
  /// See also:
  ///
  ///  * [SemanticsConfiguration.isRouteName], for a description of how this
  ///    value is used.
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = <Widget>[];
    String label = semanticLabel;

    if (title != null) {
      children.add(new Padding(
        padding: titlePadding ?? new EdgeInsets.fromLTRB(24.0, 24.0, 24.0, content == null ? 20.0 : 0.0),
        child: new DefaultTextStyle(
          style: Theme.of(context).textTheme.title,
          child: new Semantics(child: title, namesRoute: true),
        ),
      ));
    } else {
      switch (defaultTargetPlatform) {
        case TargetPlatform.iOS:
          label = semanticLabel;
          break;
        case TargetPlatform.android:
        case TargetPlatform.fuchsia:
          label = semanticLabel ?? MaterialLocalizations.of(context)?.alertDialogLabel;
      }
    }

    if (content != null) {
      children.add(new Flexible(
        child: new Padding(
          padding: contentPadding,
          child: new DefaultTextStyle(
            style: Theme.of(context).textTheme.subhead,
            child: content,
          ),
        ),
      ));
    }

    if (actions != null) {
      children.add(new ButtonTheme.bar(
        child: new ButtonBar(
          children: actions,
        ),
      ));
    }

    Widget dialogChild = new Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: children,
    );

    if (label != null)
      dialogChild = new Semantics(
          namesRoute: true,
          label: label,
          child: dialogChild
      );

    return new Dialog(child: dialogChild);
  }
}