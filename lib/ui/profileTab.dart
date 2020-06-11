import 'package:Parked/pages/revenues.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:Parked/constant.dart';
import 'package:Parked/localization/keys.dart';
import 'package:Parked/pages/addHome.dart';
import 'package:Parked/pages/addJob.dart';
import 'package:Parked/pages/maps.dart';
import 'package:Parked/script/changeDate.dart';
import 'package:Parked/script/getMonth.dart';
import 'package:Parked/script/getStatus.dart';
import 'package:Parked/script/getWeekDay.dart';
import 'package:Parked/script/goToChat.dart';
import '../setup/globals.dart' as globals;

class ProfileTab extends StatefulWidget {
  final DocumentSnapshot snapshot;
  final Function callback;
  final String myName;

  ProfileTab({@required this.snapshot, this.callback, this.myName});
  @override
  _ProfileTabState createState() =>
      _ProfileTabState(snapshot: snapshot, callback: callback, myName: myName);
}

class _ProfileTabState extends State<ProfileTab> {
  DocumentSnapshot snapshot;
  Function callback;
  String myName;
  _ProfileTabState({Key key, this.snapshot, this.callback, this.myName});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
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
                    return Padding(
                        padding: EdgeInsets.only(bottom: 20),
                        child: Column(
                          children: <Widget>[
                            Padding(
                                padding: EdgeInsets.only(bottom: 10),
                                child: revenues()),
                            Padding(
                                padding: EdgeInsets.only(bottom: 10),
                                child: placesComponent(snapshot.data)),
                            reservationComponent()
                          ],
                        ));
                  } else {
                    return Container();
                  }
                })
          ])),
    );
  }

  revenues() {
    return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection('reservaties')
            .where("eigenaar", isEqualTo: globals.userId)
            .where("status", isEqualTo: 2)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          double totalprijs = 0;

          if (snapshot.hasData) {
            snapshot.data.documents.forEach((element) {
              totalprijs += element.data["prijs"];
            });
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.only(bottom: 15),
                    child: Text("Revenues", //TODO: trad
                        style: SubTitleCustom)),
                Card(
                    margin: EdgeInsets.zero,
                    elevation: 0,
                    child: ListTile(
                        onTap: () {
                          callback();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Revenues()));
                        },
                        trailing: Icon(Icons.folder, color: Blauw),
                        title: RichText(
                                      text: TextSpan(
                                        style: SizeParagraph,
                                        children: [
                                          TextSpan(
                                    style: TextStyle(
                                      fontWeight: FontWeight.normal
                                    ),
                                    text: "Vous avez gagner depuis de debut "), // TODO: trad
                                    TextSpan(
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600
                                    ),
                                    text: totalprijs.toStringAsFixed(2).toString() + " €")
                                        ],
                                      ),
                                    ),)
                            )

              ],
            );
          } else {
            return Container();
          }
        });
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
                            callback();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddHome()));
                          }
                        : () {
                            callback();
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
                                      callback();
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
                          callback();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddJob()));
                        }
                      : () {
                          callback();
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
                                    callback();
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
            .where("isDatePassed", isEqualTo: false)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            List garageList = snapshot.data.documents;
            garageList
                .sort((a, b) => a.data['begin'].compareTo(b.data['begin']));
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
                            itemCount: garageList.length,
                            itemBuilder: (_, index) {
                              if (changeDatetimeToDatetime(
                                      garageList[index].data["end"].toDate())
                                  .isBefore(changeDatetimeToDatetime(
                                      DateTime.now()))) {
                                Firestore.instance
                                    .collection('reservaties')
                                    .document(garageList[index].documentID)
                                    .updateData({
                                  'isDatePassed': true,
                                });
                                return Container();
                              }
                              return Card(
                                  elevation: 0,
                                  child: StreamBuilder<DocumentSnapshot>(
                                      stream: Firestore.instance
                                          .collection('garages')
                                          .document(garageList[index]
                                              .data['garageId'])
                                          .snapshots(),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<DocumentSnapshot>
                                              snapshotten) {
                                        if (snapshotten.hasData) {
                                          return ListTile(
                                              onTap: () {
                                                _showModalBottomSheet(
                                                    context,
                                                    garageList[index]
                                                        .documentID);
                                              },
                                              leading: Image.network(snapshotten
                                                  .data['garageImg'][0]),
                                              title: Text(changeDate(
                                                      garageList[index]
                                                          .data["begin"]
                                                          .toDate()) +
                                                  " - " +
                                                  changeDate(garageList[index]
                                                      .data["end"]
                                                      .toDate())),
                                              trailing: getStatus(
                                                  garageList[index]
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
                    callback();
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
                  callback();
                  Navigator.of(context).pop();
                  if (type == "home") {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => AddHome()));
                  }

                  if (type == "job") {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => AddJob()));
                  }
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

  _showModalBottomSheet(context, String reservationId) {
    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Transparant,
        context: context,
        builder: (BuildContext context) {
          return Container(
            decoration: BoxDecoration(
                color: Wit,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20))),
            child: Container(
              height: MediaQuery.of(context).size.height > 750
                  ? MediaQuery.of(context).size.height * 0.55
                  : MediaQuery.of(context).size.height * 0.65,
              child: Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Theme(
                      data: ThemeData(canvasColor: Wit, primaryColor: Blauw),
                      child: StreamBuilder<DocumentSnapshot>(
                          stream: Firestore.instance
                              .collection('reservaties')
                              .document(reservationId)
                              .snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<DocumentSnapshot>
                                  reservationSnapshot) {
                            if (reservationSnapshot.hasData) {
                              return Container(
                                  child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: <Widget>[
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 10),
                                          child: Text(
                                              translate(
                                                  Keys.Apptext_Yourreservation),
                                              style: SubTitleCustom,
                                              textAlign: TextAlign.center),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Text(
                                                  getStatusText(
                                                      reservationSnapshot
                                                          .data['status']),
                                                  style: SubTitleCustom,
                                                  textAlign: TextAlign.center),
                                              getStatus(reservationSnapshot
                                                  .data['status'])
                                            ],
                                          ),
                                        ),
                                        Divider(),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20, right: 20, top: 20),
                                          child: StreamBuilder<
                                                  DocumentSnapshot>(
                                              stream: Firestore.instance
                                                  .collection('garages')
                                                  .document(reservationSnapshot
                                                      .data['garageId'])
                                                  .snapshots(),
                                              builder: (BuildContext context,
                                                  AsyncSnapshot<
                                                          DocumentSnapshot>
                                                      garagesSnapshot) {
                                                if (garagesSnapshot.hasData) {
                                                  return Container(
                                                      margin: EdgeInsets.only(
                                                          bottom: 10),
                                                      child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: <Widget>[
                                                            Container(
                                                                height: 80,
                                                                margin: EdgeInsets
                                                                    .only(
                                                                        right:
                                                                            10),
                                                                child: Image.network(
                                                                    garagesSnapshot
                                                                            .data['garageImg']
                                                                        [0],
                                                                    fit: BoxFit
                                                                        .cover)),
                                                            Expanded(
                                                              child: Text(
                                                                garagesSnapshot
                                                                        .data[
                                                                    'adress'],
                                                                style:
                                                                    SizeParagraph,
                                                              ),
                                                            ),
                                                          ]));
                                                } else {
                                                  return Container();
                                                }
                                              }),
                                        ),
                                        FlatButton(
                                            onPressed: () {
                                              goingToChat(
                                                  context,
                                                  reservationSnapshot
                                                      .data['eigenaar'],
                                                  reservationSnapshot
                                                      .data['garageId'],
                                                  myName);
                                            },
                                            child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Icon(Icons.message,
                                                      color: Blauw, size: 20),
                                                  Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 7),
                                                      child: Text(
                                                          translate(Keys
                                                              .Button_Sendmessageowner),
                                                          style: TextStyle(
                                                            color: Blauw,
                                                          )))
                                                ])),
                                        Container(
                                          margin: EdgeInsets.only(top: 10),
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Wit),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Expanded(
                                                child: Container(
                                                    alignment: Alignment.center,
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        Text(
                                                            getWeekDay(reservationSnapshot
                                                                    .data[
                                                                        'begin']
                                                                    .toDate()
                                                                    .weekday)
                                                                .toUpperCase(),
                                                            style: TextStyle(
                                                                fontSize: 13,
                                                                color: Zwart
                                                                    .withOpacity(
                                                                        0.8))),
                                                        Text(
                                                            reservationSnapshot
                                                                .data['begin']
                                                                .toDate()
                                                                .day
                                                                .toString(),
                                                            style: TextStyle(
                                                                color: Blauw,
                                                                fontSize: 40)),
                                                        Text(
                                                            getMonth(reservationSnapshot
                                                                        .data[
                                                                            'begin']
                                                                        .toDate()
                                                                        .month)
                                                                    .toUpperCase() +
                                                                " " +
                                                                reservationSnapshot
                                                                    .data[
                                                                        'begin']
                                                                    .toDate()
                                                                    .year
                                                                    .toString(),
                                                            style: TextStyle(
                                                                color: Zwart
                                                                    .withOpacity(
                                                                        0.8))),
                                                      ],
                                                    )),
                                              ),
                                              Container(
                                                width: 1,
                                                color: Grijs,
                                                height: 70,
                                              ),
                                              Expanded(
                                                  child: Container(
                                                      alignment:
                                                          Alignment.center,
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          Text(
                                                              getWeekDay(reservationSnapshot
                                                                      .data[
                                                                          'end']
                                                                      .toDate()
                                                                      .weekday)
                                                                  .toUpperCase(),
                                                              style: TextStyle(
                                                                  fontSize: 13,
                                                                  color: Zwart
                                                                      .withOpacity(
                                                                          0.8))),
                                                          Text(
                                                              reservationSnapshot
                                                                  .data['end']
                                                                  .toDate()
                                                                  .day
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  color: Blauw,
                                                                  fontSize:
                                                                      40)),
                                                          Text(
                                                              getMonth(reservationSnapshot
                                                                          .data[
                                                                              'end']
                                                                          .toDate()
                                                                          .month)
                                                                      .toUpperCase() +
                                                                  " " +
                                                                  reservationSnapshot
                                                                      .data[
                                                                          'end']
                                                                      .toDate()
                                                                      .year
                                                                      .toString(),
                                                              style: TextStyle(
                                                                  color: Zwart
                                                                      .withOpacity(
                                                                          0.8))),
                                                        ],
                                                      ))),
                                            ],
                                          ),
                                        ),
                                      ]),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 20),
                                    child: FlatButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text(translate(Keys.Button_Back),
                                            style: TextStyle(color: Zwart))),
                                  )
                                ],
                              ));
                            } else {
                              return Container(
                                width: 200,
                                height: 200,
                                alignment: Alignment.center,
                                child: CircularProgressIndicator(
                                    valueColor:
                                        new AlwaysStoppedAnimation(Blauw)),
                              );
                            }
                          }))),
            ),
          );
        });
  }
}
