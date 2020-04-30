import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:parkly/constant.dart';
import 'package:parkly/script/changeDate.dart';
import 'package:url_launcher/url_launcher.dart';
import '../setup/globals.dart' as globals;
import 'package:flutter_translate/flutter_translate.dart';
import 'package:parkly/localization/keys.dart';

class Reservations extends StatefulWidget {
  @override
  _ReservationsState createState() => _ReservationsState();
}

class _ReservationsState extends State<Reservations> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection('reservaties')
            .where('aanvrager', isEqualTo: globals.userId)
            .orderBy("begin", descending: false)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return MediaQuery.removePadding(
                removeTop: true,
                context: context,
                child: ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (_, index) {
                    return Container(
                        margin: EdgeInsets.only(
                            bottom: 0, left: 20, right: 20, top: 20),
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Wit,
                        ),
                        child: ExpandablePanel(
                            hasIcon: false,
                            header: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Text(changeDateWithTime(snapshot
                                    .data.documents[index].data["begin"]
                                    .toDate())),
                                Icon(Icons.arrow_forward, color: Blauw),
                                Text(changeDateWithTime(snapshot
                                    .data.documents[index].data["end"]
                                    .toDate()))
                              ],
                            ),
                            expanded: StreamBuilder<DocumentSnapshot>(
                                stream: Firestore.instance
                                    .collection("garages")
                                    .document(snapshot
                                        .data.documents[index].data["garageId"])
                                    .snapshots(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                                  if (snapshot.hasData) {
                                    return Padding(
                                        padding: EdgeInsets.only(top: 20),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(snapshot.data['street']),
                                                Text(
                                                  snapshot.data['city'] +
                                                      " " +
                                                      snapshot.data['postcode'],
                                                ),
                                              ],
                                            ),
                                            FlatButton(
                                              textColor: Blauw,
                                              onPressed: () async {
                                                var url =
                                                    'https://www.waze.com/ul?ll=${snapshot.data["latitude"]}%2C${snapshot.data["longitude"]}&navigate=yes';

                                                if (await canLaunch(url)) {
                                                  await launch(url);
                                                } else {
                                                  throw 'Could not launch $url';
                                                }
                                              },
                                              child: Text(translate(
                                                      Keys.Button_Openwaze) +
                                                  " >"),
                                            ),
                                          ],
                                        ));
                                  } else {
                                    return Container();
                                  }
                                })));
                  },
                ));
          } else {
            return Container();
          }
        });
  }
}
