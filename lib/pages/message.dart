import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:parkly/constant.dart';
import 'package:parkly/localization/keys.dart';
import 'package:parkly/ui/navigation.dart';
import 'package:parkly/ui/title.dart';
import '../setup/globals.dart' as globals;

class MessagePage extends StatefulWidget {
  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
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
          stream: Firestore.instance.collection('conversation').snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              return Scaffold(
                  body: Column(
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
                                print("going to chat");
                              },
                              // leading: returnImage(snapshot.data.documents[index]['imgUrl']),
                              title: Text("test",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text("message"),
                            ));
                          }))
                ],
              ));
            } else {
              return Text("waiting");
            }
          },
        ),
        drawer: Navigation(activeMes: true));
  }
}
