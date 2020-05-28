import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:parkly/constant.dart';
import 'package:parkly/localization/keys.dart';
import 'package:parkly/pages/addHome.dart';
import 'package:parkly/pages/addJob.dart';
import 'package:parkly/pages/maps.dart';
import 'package:parkly/script/changeDate.dart';
import 'package:parkly/script/getStatus.dart';
import '../setup/globals.dart' as globals;

class ProfileTab extends StatefulWidget {
  final DocumentSnapshot snapshot;

  ProfileTab({
    @required this.snapshot,
  });
  @override
  _ProfileTabState createState() => _ProfileTabState(snapshot: snapshot);
}

class _ProfileTabState extends State<ProfileTab> {
  DocumentSnapshot snapshot;
  _ProfileTabState({Key key, this.snapshot});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(20),
        child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          StreamBuilder<DocumentSnapshot>(
              stream: Firestore.instance
                  .collection('users')
                  .document(globals.userId)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasData) {
                  return Expanded(
                      child: SingleChildScrollView(
                          child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.only(bottom: 20),
                          child: Column(
                            children: <Widget>[
                              Padding(
                                  padding: EdgeInsets.only(bottom: 10),
                                  child: placesComponent(snapshot.data)),
                              reservationComponent()
                            ],
                          )),
                    ],
                  )));
                } else {
                  return Container();
                }
              })
        ]));
  }

  placesComponent(userData) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
        Widget>[
      Padding(
          padding: EdgeInsets.only(bottom: 15),
          child: Text(translate(Keys.Apptext_Favoritelocations),
              style: SubTitleCustom)),
      MediaQuery.removePadding(
          context: context,
          removeBottom: true,
          removeTop: true,
          child: GridView.count(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              children: [
                GestureDetector(
                    onTap: userData["home"] == null
                        ? () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddHome()));
                          }
                        : () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MapsPage(
                                          zoomToOtherplace: true,
                                          givenLat: userData["home"]
                                              ["latitude"],
                                          givenLon: userData["home"]
                                              ["longitude"],
                                        )));
                          },
                    child: Stack(
                      children: <Widget>[
                        Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Wit),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(Icons.home),
                                userData["home"] == null
                                    ? Text(translate(Keys.Apptext_Addhome))
                                    : Text(
                                        userData["home"]["adress"],
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                      ),
                              ],
                            )),
                        Align(
                            alignment: Alignment.topRight,
                            child: userData["home"] == null
                                ? IconButton(
                                    icon: Icon(
                                      Icons.add_circle,
                                      color: Blauw,
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => AddHome()));
                                    })
                                : IconButton(
                                    icon: Icon(Icons.more_vert),
                                    onPressed: () {
                                      actionMore(
                                          context,
                                          translate(Keys.Apptext_Home),
                                          userData["home"],
                                          "home");
                                    }))
                      ],
                    )),
                GestureDetector(
                  onTap: userData["job"] == null
                      ? () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddJob()));
                        }
                      : () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MapsPage(
                                        zoomToOtherplace: true,
                                        givenLat: userData["job"]["latitude"],
                                        givenLon: userData["job"]["longitude"],
                                      )));
                        },
                  child: Stack(
                    children: <Widget>[
                      Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Wit),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.business),
                              userData["job"] == null
                                  ? Text(translate(Keys.Apptext_Addjob))
                                  : Text(
                                      userData["job"]["adress"],
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                    ),
                            ],
                          )),
                      Align(
                          alignment: Alignment.topRight,
                          child: userData["job"] == null
                              ? IconButton(
                                  icon: Icon(
                                    Icons.add_circle,
                                    color: Blauw,
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => AddJob()));
                                  })
                              : IconButton(
                                  icon: Icon(Icons.more_vert),
                                  onPressed: () {
                                    actionMore(
                                        context,
                                        translate(Keys.Apptext_Job),
                                        userData["job"],
                                        "job");
                                  }))
                    ],
                  ),
                ),
              ]))
    ]);
  }

  reservationComponent() {
    return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection('reservaties')
            .where("aanvrager", isEqualTo: globals.userId)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return snapshot.data.documents.length != 0
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: Text(translate(Keys.Apptext_Yourreservation),
                            style: SubTitleCustom),
                      ),
                      MediaQuery.removePadding(
                          context: context,
                          removeBottom: true,
                          removeTop: true,
                          child: ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: snapshot.data.documents.length,
                            itemBuilder: (_, index) {
                              return Card(
                                  elevation: 0,
                                  child: StreamBuilder<DocumentSnapshot>(
                                      stream: Firestore.instance
                                          .collection('garages')
                                          .document(snapshot
                                              .data
                                              .documents[index]
                                              .data['garageId'])
                                          .snapshots(),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<DocumentSnapshot>
                                              snapshotten) {
                                        if (snapshotten.hasData) {
                                          return ListTile(
                                              leading: Image.network(snapshotten
                                                  .data['garageImg']),
                                              title: Text(changeDate(snapshot
                                                      .data
                                                      .documents[index]
                                                      .data["begin"]
                                                      .toDate()) +
                                                  " - " +
                                                  changeDate(snapshot
                                                      .data
                                                      .documents[index]
                                                      .data["end"]
                                                      .toDate())),
                                              trailing: getStatus(snapshot
                                                  .data
                                                  .documents[index]
                                                  .data["status"]));
                                        } else {
                                          return Container();
                                        }
                                      }));
                            },
                          ))
                    ],
                  )
                : Container();
          } else {
            return Container();
          }
        });
  }

  Future actionMore(
      BuildContext context, String title, dynamic data, String type) async {
    await showCupertinoModalPopup(
        context: context,
        builder: (context) {
          return CupertinoActionSheet(
            cancelButton: CupertinoActionSheetAction(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(translate(Keys.Button_Cancel)),
            ),
            title: Text(title),
            actions: <Widget>[
              CupertinoActionSheetAction(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MapsPage(
                                  zoomToOtherplace: true,
                                  givenLat: data["latitude"],
                                  givenLon: data["longitude"],
                                )));
                  },
                  child: Text(translate(Keys.Button_Searchgarage))),
              CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.of(context).pop();
                  //TODO: go to editpage
                },
                child: Text(translate(Keys.Button_Edit)),
              ),
              CupertinoActionSheetAction(
                onPressed: () {
                  deleteAdress(type);
                  Navigator.of(context).pop();
                },
                child: Text(
                  translate(Keys.Button_Delete),
                  style: TextStyle(color: Colors.red),
                ),
              )
            ],
          );
        });
  }

  deleteAdress(String type) {
    if (type == "job") {
      Firestore.instance
          .collection('users')
          .document(globals.userId)
          .updateData({"job": FieldValue.delete()});
    }
    if (type == "home") {
      Firestore.instance
          .collection('users')
          .document(globals.userId)
          .updateData({"home": FieldValue.delete()});
    }
  }
}
