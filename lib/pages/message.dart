import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:parkly/constant.dart';
import 'package:parkly/localization/keys.dart';
import 'package:parkly/pages/chatPage.dart';
import 'package:parkly/script/changeDate.dart';
import 'package:parkly/ui/navigation.dart';
import 'package:parkly/ui/title.dart';
import '../setup/globals.dart' as globals;

class MessagePage extends StatefulWidget {
  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  String sendName;

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
          iconTheme: IconThemeData(color: Zwart),
          backgroundColor: Wit,
          elevation: 0.0,
          title: Image.asset('assets/images/logo.png', height: 32),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance
              .collection('conversation')
              .where('userInChat', arrayContains: globals.userId)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              return Column(
                children: <Widget>[
                  TitleComponent(label: translate(Keys.Title_Message)),
                  Expanded(
                      child: ListView.builder(
                          itemCount: snapshot.data.documents.length,
                          itemBuilder: (_, index) {
                            return Card(
                                elevation: 0,
                                child: ListTile(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ChatPage(
                                                conversationID: snapshot
                                                    .data
                                                    .documents[index]
                                                    .documentID)));
                                  },
                                  // leading: returnImage(snapshot.data.documents[index]['imgUrl']),
                                  title: Text(
                                    "test",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Row(
                                    children: <Widget>[
                                      Text(
                                          snapshot
                                                      .data
                                                      .documents[index]
                                                      .data["chat"]
                                                      .last["auteur"] ==
                                                  sendName
                                              ? "Vous"
                                              : snapshot.data.documents[index]
                                                  .data["chat"].last["auteur"],
                                          style: ChatStyle),
                                      Text(
                                          " : " +
                                              snapshot.data.documents[index]
                                                  .data["chat"].last["message"],
                                          style: ChatStyle)
                                    ],
                                  ),
                                  trailing: Text(
                                      changeDate(snapshot.data.documents[index]
                                          .data["chat"].last["time"].toDate()),
                                      style: ChatStyle),
                                ));
                          }))
                ],
              );
            } else {
              return CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(Blauw));
            }
          },
        ),
        drawer: Navigation(activeMes: true));
  }
}
