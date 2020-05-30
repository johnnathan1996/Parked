import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:parkly/constant.dart';
import 'package:parkly/localization/keys.dart';
import 'package:parkly/pages/chatPage.dart';
import 'package:parkly/script/changeDate.dart';
import 'package:parkly/ui/dot.dart';
import 'package:parkly/ui/navigation.dart';
import 'package:parkly/ui/title.dart';
import '../setup/globals.dart' as globals;
import 'package:content_placeholder/content_placeholder.dart';

class MessagePage extends StatefulWidget {
  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  String sendName;
  void getSendName() {
    Firestore.instance
        .collection('users')
        .document(globals.userId)
        .snapshots()
        .listen((snapshot) {
      sendName = snapshot.data["voornaam"];
    });
  }

  @override
  void initState() {
    getSendName();
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
        body: Container(
            decoration: BoxDecoration(
                image: new DecorationImage(
                    image: new AssetImage('assets/images/backgroundP.png'),
                    fit: BoxFit.cover)),
            child: StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance
                  .collection('conversation')
                  .where('userInChat', arrayContains: globals.userId)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: <Widget>[
                      TitleComponent(label: translate(Keys.Title_Message)),
                      Expanded(
                          child: ListView.builder(
                              itemCount: snapshot.data.documents.length,
                              itemBuilder: (_, index) {
                                String otherUser;

                                if (snapshot.data.documents[index]
                                        .data['userInChat'][0] ==
                                    globals.userId) {
                                  otherUser = snapshot.data.documents[index]
                                      .data['userInChat'][1];
                                } else {
                                  otherUser = snapshot.data.documents[index]
                                      .data['userInChat'][0];
                                }

                                return snapshot.data.documents[index]
                                            .data["chat"].length !=
                                        0
                                    ? Card(
                                        elevation: 0,
                                        child: ListTile(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => ChatPage(
                                                        sendName: sendName,
                                                        conversationID: snapshot
                                                            .data
                                                            .documents[index]
                                                            .documentID)));
                                          },
                                          title: StreamBuilder<
                                                  DocumentSnapshot>(
                                              stream: Firestore.instance
                                                  .collection('users')
                                                  .document(otherUser)
                                                  .snapshots(),
                                              builder: (BuildContext context,
                                                  AsyncSnapshot<
                                                          DocumentSnapshot>
                                                      snapshots) {
                                                if (snapshots.hasData) {
                                                  return Text(snapshots
                                                          .data["voornaam"] +
                                                      " " +
                                                      snapshots.data[
                                                          "achternaam"][0] +
                                                      ".");
                                                } else {
                                                  return Container();
                                                }
                                              }),
                                          leading: SizedBox(
                                              width: 80,
                                              child: StreamBuilder<
                                                      DocumentSnapshot>(
                                                  stream: Firestore.instance
                                                      .collection('garages')
                                                      .document(snapshot
                                                          .data
                                                          .documents[index]
                                                          .data["garageId"])
                                                      .snapshots(),
                                                  builder: (BuildContext
                                                          context,
                                                      AsyncSnapshot<
                                                              DocumentSnapshot>
                                                          snapshots) {
                                                    if (snapshots.hasData) {
                                                      if (snapshots
                                                          .data.exists) {
                                                        return Image.network(
                                                            snapshots.data[
                                                                'garageImg'],
                                                            fit: BoxFit.cover);
                                                      } else {
                                                        return Image.asset(
                                                            "assets/images/del_garage.jpg",
                                                            fit: BoxFit.cover);
                                                      }
                                                    } else {
                                                      return ContentPlaceholder();
                                                    }
                                                  })),
                                          subtitle: Row(
                                            children: <Widget>[
                                              snapshot
                                                          .data
                                                          .documents[index]
                                                          .data["chat"]
                                                          .length !=
                                                      0
                                                  ? Text(
                                                      snapshot
                                                                      .data
                                                                      .documents[
                                                                          index]
                                                                      .data["chat"]
                                                                      .last[
                                                                  "auteur"] ==
                                                              sendName
                                                          ? translate(Keys
                                                                  .Chattext_You) +
                                                              " : "
                                                          : "",
                                                      style: ChatStyle)
                                                  : Text(""),
                                              snapshot
                                                          .data
                                                          .documents[index]
                                                          .data["chat"]
                                                          .length !=
                                                      0
                                                  ? snapshot
                                                                  .data
                                                                  .documents[index]
                                                                  .data[
                                                              "seenLastMessage"] ==
                                                          false
                                                      ? sendName !=
                                                              snapshot
                                                                      .data
                                                                      .documents[
                                                                          index]
                                                                      .data["chat"]
                                                                      .last[
                                                                  "auteur"]
                                                          ? Flexible(
                                                              child: RichText(
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  strutStyle:
                                                                      StrutStyle(
                                                                          fontSize:
                                                                              12.0),
                                                                  text:
                                                                      TextSpan(
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            14.0,
                                                                        color:
                                                                            Zwart,
                                                                        fontWeight:
                                                                            FontWeight.w500),
                                                                    text: snapshot.data.documents[index].data["chat"].last["message"].length >
                                                                            10
                                                                        ? snapshot
                                                                            .data
                                                                            .documents[
                                                                                index]
                                                                            .data[
                                                                                "chat"]
                                                                            .last[
                                                                                "message"]
                                                                            .substring(0,
                                                                                10)
                                                                        : snapshot
                                                                            .data
                                                                            .documents[index]
                                                                            .data["chat"]
                                                                            .last["message"],
                                                                  )))
                                                          : Flexible(
                                                              child: RichText(
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  strutStyle:
                                                                      StrutStyle(
                                                                          fontSize:
                                                                              12.0),
                                                                  text:
                                                                      TextSpan(
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            14.0,
                                                                        color:
                                                                            Grijs,
                                                                        fontWeight:
                                                                            FontWeight.w300),
                                                                    text: snapshot.data.documents[index].data["chat"].last["message"].length >
                                                                            10
                                                                        ? snapshot
                                                                            .data
                                                                            .documents[
                                                                                index]
                                                                            .data[
                                                                                "chat"]
                                                                            .last[
                                                                                "message"]
                                                                            .substring(0,
                                                                                10)
                                                                        : snapshot
                                                                            .data
                                                                            .documents[index]
                                                                            .data["chat"]
                                                                            .last["message"],
                                                                  )))
                                                      : Flexible(
                                                          child: RichText(
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              strutStyle:
                                                                  StrutStyle(
                                                                      fontSize:
                                                                          12.0),
                                                              text: TextSpan(
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        14.0,
                                                                    color:
                                                                        Grijs,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w300),
                                                                text: snapshot
                                                                            .data
                                                                            .documents[
                                                                                index]
                                                                            .data[
                                                                                "chat"]
                                                                            .last[
                                                                                "message"]
                                                                            .length >
                                                                        10
                                                                    ? snapshot
                                                                        .data
                                                                        .documents[
                                                                            index]
                                                                        .data[
                                                                            "chat"]
                                                                        .last[
                                                                            "message"]
                                                                        .substring(
                                                                            0,
                                                                            10)
                                                                    : snapshot
                                                                        .data
                                                                        .documents[
                                                                            index]
                                                                        .data[
                                                                            "chat"]
                                                                        .last["message"],
                                                              )))
                                                  : Text(translate(
                                                      Keys.Apptext_Nomessage))
                                            ],
                                          ),
                                          trailing: snapshot
                                                      .data
                                                      .documents[index]
                                                      .data["chat"]
                                                      .length !=
                                                  0
                                              ? snapshot.data.documents[index].data["seenLastMessage"] ==
                                                      false
                                                  ? sendName !=
                                                          snapshot
                                                              .data
                                                              .documents[index]
                                                              .data["chat"]
                                                              .last["auteur"]
                                                      ? DotComponent(
                                                          number: snapshot
                                                                  .data
                                                                  .documents[
                                                                      index]
                                                                  .data["chat"]
                                                                  .length -
                                                              snapshot
                                                                  .data
                                                                  .documents[index]
                                                                  .data["seenLastIndex"])
                                                      : Text(changeDate(snapshot.data.documents[index].data["chat"].last["time"].toDate()), style: ChatStyle)
                                                  : Text(changeDate(snapshot.data.documents[index].data["chat"].last["time"].toDate()), style: ChatStyle)
                                              : Text(""),
                                        ))
                                    : Container();
                              }))
                    ],
                  );
                } else {
                  return Container(
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(
                        valueColor: new AlwaysStoppedAnimation<Color>(Blauw)),
                  );
                }
              },
            )),
        drawer: Navigation(activeMes: true));
  }
}
