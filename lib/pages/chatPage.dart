import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:parkly/constant.dart';
import 'package:parkly/pages/detailGarage.dart';
import 'package:parkly/script/changeDate.dart';
import 'package:speech_bubble/speech_bubble.dart';
import '../setup/globals.dart' as globals;
import 'package:flutter_translate/flutter_translate.dart';
import 'package:parkly/localization/keys.dart';

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

  String sendName, message, lastMessageName;
  bool isSeen;

  void getSendName() {
    Firestore.instance
        .collection('users')
        .document(globals.userId)
        .snapshots()
        .listen((snapshot) {
      if (this.mounted) {
        setState(() {
          sendName = snapshot.data["voornaam"];
        });
      }
    });
  }

  void checkLastMessage() {
    Firestore.instance
        .collection('conversation')
        .document(conversationID)
        .snapshots()
        .listen((snapshot) {
      if (this.mounted) {
        setState(() {
          lastMessageName = snapshot.data["chat"].last["auteur"];
          isSeen = snapshot.data["seenLastMessage"];
        });
      }

      checkIsSeen();
    });
  }

  void checkIsSeen() {
    print("send " + sendName.toString());
    print("last " + lastMessageName.toString());
    print("seen " + isSeen.toString());

    if (sendName != lastMessageName) {
      if (isSeen == false) {
        Firestore.instance
            .collection('conversation')
            .document(conversationID)
            .updateData({"seenLastMessage": true});
      }
    }
  }

  @override
  void initState() {
    getSendName();
    checkLastMessage();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Zwart),
          backgroundColor: Wit,
          elevation: 0.0,
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
        body: SafeArea(
          child: StreamBuilder<DocumentSnapshot>(
            stream: Firestore.instance
                .collection('conversation')
                .document(conversationID)
                .snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasData) {
                WidgetsBinding.instance
                    .addPostFrameCallback((_) => _scrollDown(context));
                return Form(
                    key: _formKey,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          StreamBuilder<DocumentSnapshot>(
                              stream: Firestore.instance
                                  .collection('garages')
                                  .document(snapshot.data.data['garageId'])
                                  .snapshots(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<DocumentSnapshot> snapshotten) {
                                if (snapshotten.hasData) {
                                  return Card(
                                      elevation: 0,
                                      child: ListTile(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      DetailGarage(
                                                          idGarage: snapshot
                                                                  .data.data[
                                                              'garageId'])));
                                        },
                                        leading: Image.network(
                                            snapshotten.data['garageImg']),
                                        title: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(snapshotten.data['street'],
                                                  style: TextStyle(
                                                      fontSize: 16.0)),
                                              Text(
                                                  snapshotten.data['city'] +
                                                      " " +
                                                      snapshotten
                                                          .data['postcode'],
                                                  style: TextStyle(
                                                      fontSize: 16.0)),
                                            ]),
                                        trailing: Icon(Icons.arrow_forward_ios,
                                            color: Zwart),
                                      ));
                                } else {
                                  return Container();
                                }
                              }),
                          Padding(
                              padding: EdgeInsets.only(top: 15),
                              child: Text(
                                changeDateWithTime(snapshot
                                    .data.data['chat'][0]['time']
                                    .toDate()),
                                textAlign: TextAlign.center,
                                style: ChatStyle,
                              )),
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
                          snapshot.data.data['chat'].last['auteur'] == sendName
                              ? Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  child: Text(
                                      snapshot.data.data['seenLastMessage']
                                          ? "Vu"
                                          : "Distribué",
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                        fontStyle: FontStyle.italic
                                      )))
                              : Container(),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 10.0, right: 10.0, bottom: 10.0),
                              child: TextFormField(
                                controller: controller,
                                onSaved: (input) => message = input,
                                decoration: InputDecoration(
                                    hintText:
                                        translate(Keys.Inputs_Sendmessage),
                                    border: OutlineInputBorder(),
                                    suffixIcon: IconButton(
                                      icon: Icon(Icons.send),
                                      onPressed: _createMessage,
                                    )),
                              ))
                        ]));
              } else {
                return CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(Blauw));
              }
            },
          ),
        ));
  }

  _scrollDown(BuildContext context) {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  _createMessage() {
    final formState = _formKey.currentState;
    formState.save();
    Firestore.instance
        .collection('conversation')
        .document(conversationID)
        .updateData({
      "chat": FieldValue.arrayUnion([
        {'auteur': sendName, 'time': DateTime.now(), 'message': message}
      ])
    });

    Firestore.instance
        .collection('conversation')
        .document(conversationID)
        .updateData({"seenLastMessage": false});

    lastMessageName = sendName;
    checkIsSeen();

    controller.text = "";
  }

  checkmessage(String auteurName, String message) {
    if (sendName == auteurName) {
      return Padding(
          padding: EdgeInsets.only(right: 20.0, bottom: 5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text(
                auteurName,
                style: ChatStyle,
              ),
              SpeechBubble(
                color: Blauw,
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
              )
            ],
          ));
    } else {
      return Padding(
          padding: EdgeInsets.only(left: 20.0, bottom: 10.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  auteurName,
                  style: ChatStyle,
                ),
                SpeechBubble(
                    color: Grijs,
                    nipLocation: NipLocation.LEFT,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          message,
                          style: TextStyle(
                            color: Zwart,
                            fontSize: 18.0,
                          ),
                        ),
                      ],
                    ))
              ]));
    }
  }
}
