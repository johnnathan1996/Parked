import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Parked/constant.dart';
import '../setup/globals.dart' as globals;

class Revenues extends StatefulWidget {
  @override
  _RevenuesState createState() => _RevenuesState();
}

class _RevenuesState extends State<Revenues> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Zwart),
          backgroundColor: Wit,
          elevation: 0.0,
          title: Image.asset('assets/images/logo.png', height: 32),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance
                  .collection('reservaties')
                  .where("eigenaar", isEqualTo: globals.userId)
                  .where("status", isEqualTo: 2)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (_, index) {
                        return StreamBuilder<DocumentSnapshot>(
                            stream: Firestore.instance
                                .collection('garages')
                                .document(snapshot
                                    .data.documents[index].data["garageId"])
                                .snapshots(),
                            builder: (BuildContext context,
                                AsyncSnapshot<DocumentSnapshot>
                                    garagesSnapshot) {
                              if (garagesSnapshot.hasData) {
                                return StreamBuilder<DocumentSnapshot>(
                                    stream: Firestore.instance
                                        .collection('users')
                                        .document(snapshot.data.documents[index]
                                            .data["aanvrager"])
                                        .snapshots(),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<DocumentSnapshot>
                                            userSnapshot) {
                                      if (userSnapshot.hasData) {
                                        return Container(
                                          margin: EdgeInsets.only(bottom: 10),
                                          padding: EdgeInsets.symmetric(
                                              vertical: 20, horizontal: 10),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            color: Wit,
                                          ),
                                          child: Column(
                                            children: <Widget>[
                                              Column(
                                                children: <Widget>[
                                                  Text(
                                                      garagesSnapshot
                                                          .data["adress"],
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500)),
                                                  Divider(),
                                                  Text(
                                                      userSnapshot.data[
                                                              "voornaam"] +
                                                          " betaalde " + //TODO: trad
                                                          snapshot
                                                              .data
                                                              .documents[index]
                                                              .data["prijs"].toStringAsFixed(2)
                                                              .toString() +
                                                          " €",
                                                      style: SizeParagraph),
                                                ],
                                              )
                                            ],
                                          ),
                                        );
                                      } else {
                                        return Text("");
                                      }
                                    });
                              } else {
                                return Container(
                                  width: 200,
                                  height: 200,
                                  alignment: Alignment.center,
                                  child: CircularProgressIndicator(
                                      valueColor:
                                          new AlwaysStoppedAnimation<Color>(
                                              Blauw)),
                                );
                              }
                            });
                      });
                } else {
                  return Container(
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(
                        valueColor: new AlwaysStoppedAnimation(Blauw)),
                  );
                }
              }),
        ));
  }
}
