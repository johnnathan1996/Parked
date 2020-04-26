import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:parkly/constant.dart';
import 'package:speech_bubble/speech_bubble.dart';
import '../setup/globals.dart' as globals;

class ChatPage extends StatefulWidget {
  final String conversationID;

  ChatPage({
    @required this.conversationID,
  });
  @override
  _ChatPageState createState() =>
      _ChatPageState(conversationID: conversationID);
}

class _ChatPageState extends State<ChatPage> {
  final String conversationID;
  _ChatPageState({Key key, this.conversationID});

  final _formKey = new GlobalKey<FormState>();
  final TextEditingController controller = TextEditingController();
  ScrollController _scrollController = new ScrollController();

  String sendName, message;

  @override
  void initState() {
    Firestore.instance
        .collection('users')
        .document(globals.userId)
        .snapshots()
        .listen((snapshot) {
      sendName = snapshot.data["voornaam"];
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Message"),
        actions: <Widget>[
          new IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {
              print("signaler");
            },
          )
        ],
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: Firestore.instance
            .collection('conversation')
            .document(conversationID)
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasData) {
            WidgetsBinding.instance
                .addPostFrameCallback((_) => _scrollDown(context));
            return Form(
                    key: _formKey,
                    child: Column(children: <Widget>[
                      Expanded(
                          child: ListView.builder(
                        controller: _scrollController,
                        itemCount: snapshot.data.data['chat'].length,
                        itemBuilder: (_, index) {
                          return checkmessage(
                              snapshot.data.data['chat'][index]['auteur'],
                              snapshot.data.data['chat'][index]['message']);
                        },
                      )),
                      Padding(
                          padding: EdgeInsets.only(
                              left: 10.0, right: 10.0, bottom: 10.0),
                          child: TextFormField(
                            controller: controller,
                            onSaved: (input) => message = input,
                            decoration: InputDecoration(
                                hintText: 'Send a message',
                                border: OutlineInputBorder(),
                                prefixIcon: IconButton(
                                  icon: Icon(Icons.camera_alt),
                                  onPressed: () {},
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(Icons.send),
                                  onPressed: (){
                                    print("create message");
                                  },
                                )),
                          ))
                    ]));
          } else {
            return CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(Blauw));
          }
        },
      ),
    );
  }

  _scrollDown(BuildContext context) {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  checkmessage(String auteurName, String message) {
    if (sendName == auteurName) {
      return Padding(
          padding: EdgeInsets.only(right: 20.0, bottom: 5.0, top: 5.0),
          child: SpeechBubble(
            color: Colors.blue,
            nipLocation: NipLocation.RIGHT,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  message,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                  ),
                ),
              ],
            ),
          ));
    } else {
      return Padding(
          padding: EdgeInsets.only(left: 20.0, bottom: 5.0, top: 5.0),
          child: SpeechBubble(
              color: Colors.grey,
              nipLocation: NipLocation.LEFT,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    message,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                    ),
                  ),
                ],
              )));
    }
  }
}
