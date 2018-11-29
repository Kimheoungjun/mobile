import 'main.dart';
import 'package:flutter/material.dart';
import 'userpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

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

  ChatroomState({Key key, @required this.document, @required this.user});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: ListView(
            children: [Container(

                color: Color.fromRGBO(246, 239, 239, 1.0),
                child: Column(
                    children: [
                      SizedBox(height: 15.0, width: 500.0),
                      Container(
                        width: 250.0,
                        height: 60.0,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(
                                    "https://firebasestorage.googleapis.com/v0/b/mobile-project-4ee9b.appspot.com/o/danolja.png?alt=media&token=190dadf5-ba05-4de3-aa96-934e704d5443"),
                                fit: BoxFit.fill
                            )
                        ),
                      ),
                      SizedBox(height: 15.0),
                      Container(
                          color: Color.fromRGBO(252, 223, 179, 1.0),
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
                          height: 380.0,
                          child: StreamBuilder(
                            stream:Firestore.instance.collection('list').document(document.documentID).collection('chat').orderBy('time',descending: false).snapshots(),
                            builder: (context, snapshot){
                              if(!snapshot.hasData) return Text("Loading....");
                              return ListView.builder(
                                itemCount: snapshot.data.documents.length,
                                itemBuilder: (context,index)=>
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children:[
                                      Padding(
                                        padding:EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
                                        child: Row(children:[
                                          Expanded(child: Text("${snapshot.data.documents[index]['name']} : ${snapshot.data.documents[index]['content']}",style: TextStyle(fontSize: 18.0,color: Colors.black),overflow: TextOverflow.clip,softWrap: true,)),
                                          Text(snapshot.data.documents[index]['time'],style: TextStyle(fontSize: 13.0,color: Colors.grey),overflow: TextOverflow.clip,softWrap: true,)
                                        ]),
                                      )
                                    ]
                                  ),
                              );
                            },
                          )
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
                              onPressed: () {},
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