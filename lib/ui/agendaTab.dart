import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:Parked/constant.dart';
import 'package:Parked/localization/keys.dart';
import 'package:Parked/script/changeDate.dart';
import 'package:Parked/script/getStatus.dart';
import '../setup/globals.dart' as globals;
import 'package:flutter_translate/flutter_translate.dart';
import 'package:table_calendar/table_calendar.dart';

class AgendaTab extends StatefulWidget {
  @override
  _AgendaTabState createState() => _AgendaTabState();
}

class _AgendaTabState extends State<AgendaTab> {
  CalendarController _calendarController;
  List<dynamic> showGarageId = [];
  bool showGarage = false;
  bool showMyResevation = false;
  Map<DateTime, List> _reservations = {};
  Map<DateTime, List> _myReservations = {};

  bool showNotification = false;
  bool dontShowWhenRefused = true;

  getResevations() {
    Firestore.instance
        .collection('reservaties')
        .where('eigenaar', isEqualTo: globals.userId)
        .where('status', isGreaterThan: 0)
        .snapshots()
        .listen((data) {
      _reservations = {};
      data.documents.forEach((element) {
        if (this.mounted) {
          setState(() {
            element.data["dates"].forEach((date) {
              _reservations[date.toDate()] = [element.documentID];
            });
          });
        }
      });
    });
  }

  getMyResevations() {
    Firestore.instance
        .collection('reservaties')
        .where('aanvrager', isEqualTo: globals.userId)
        .where('status', isGreaterThan: 0)
        .snapshots()
        .listen((data) {
      _myReservations = {};
      data.documents.forEach((element) {
        if (this.mounted) {
          setState(() {
            element.data["dates"].forEach((date) {
              _myReservations[date.toDate()] = [element.documentID];
            });
          });
        }
      });
    });
  }

  @override
  void initState() {
    if (this.mounted) {
      getResevations();
      getMyResevations();
    }

    super.initState();
    _calendarController = CalendarController();
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var localizationDelegate = LocalizedApp.of(context).delegate;

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          TableCalendar(
            calendarController: _calendarController,
            locale: getCurrentLanguageLocalizationKey(
                localizationDelegate.currentLocale.languageCode),
            startingDayOfWeek: StartingDayOfWeek.monday,
            initialCalendarFormat: CalendarFormat.month,
            events: _reservations,
            holidays: _myReservations,
            availableGestures: AvailableGestures.horizontalSwipe,
            headerStyle: HeaderStyle(
              centerHeaderTitle: true,
              formatButtonVisible: false,
            ),
            onDaySelected: (value, a) {
              if (_myReservations
                  .containsKey(changeDatetimeToDatetime(value))) {
                if (this.mounted) {
                  setState(() {
                    showGarageId =
                        _myReservations[changeDatetimeToDatetime(value)];
                    showMyResevation = true;
                  });
                }
              } else {
                if (this.mounted) {
                  setState(() {
                    showMyResevation = false;
                  });
                }
              }

              if (a.length != 0) {
                if (this.mounted) {
                  setState(() {
                    showGarageId = a;
                    showGarage = true;
                  });
                }
              } else {
                if (this.mounted) {
                  setState(() {
                    showGarage = false;
                  });
                }
              }
            },
            daysOfWeekStyle: DaysOfWeekStyle(
                weekendStyle: TextStyle().copyWith(color: Blauw),
                weekdayStyle: TextStyle().copyWith(color: Zwart)),
            calendarStyle: CalendarStyle(
                todayColor: Grijs,
                selectedColor: Blauw,
                weekdayStyle: TextStyle().copyWith(color: Zwart),
                weekendStyle: TextStyle().copyWith(color: Blauw),
                holidayStyle: TextStyle().copyWith(color: Zwart)),
            builders: CalendarBuilders(
                markersBuilder: (context, date, events, holidays) {
              final children = <Widget>[];

              if (events.isNotEmpty) {
                if (this.mounted) {
                  getNotificationAgenda(events.first);
                }
                children.add(StreamBuilder<DocumentSnapshot>(
                    stream: Firestore.instance
                        .collection('reservaties')
                        .document(events.first)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if (snapshot.hasData) {
                        return snapshot.data["status"] == 1
                            ? Positioned(
                                top: 5,
                                right: 5,
                                child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.red,
                                    ),
                                    width: 12,
                                    height: 12))
                            : Center(
                                child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: dontShowWhenRefused
                                          ? Blauw.withOpacity(0.15)
                                          : Grijs.withOpacity(0),
                                    ),
                                    width: 50,
                                    height: 50),
                              );
                      } else {
                        return Container();
                      }
                    }));
              }

              if (holidays.isNotEmpty) {
                children.add(
                  StreamBuilder<DocumentSnapshot>(
                      stream: Firestore.instance
                          .collection('reservaties')
                          .document(holidays.first)
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<DocumentSnapshot> snapshot) {
                        if (snapshot.hasData) {
                          return Positioned(
                              bottom: 10,
                              child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: _calendarController.isSelected(date)
                                        ? Wit
                                        : _calendarController.isToday(date)
                                            ? Wit
                                            : snapshot.data["status"] == 1
                                                ? Colors.orange
                                                : Colors.green,
                                  ),
                                  width: 7,
                                  height: 7));
                        } else {
                          return Container();
                        }
                      }),
                );
              }

              return children;
            }),
          ),
          Divider(),
          Column(
            children: <Widget>[
              showGarage ? showReservation(showGarageId) : Container(),
              showMyResevation ? showMyReservations(showGarageId) : Container()
            ],
          )
        ],
      ),
    );
  }

  getNotificationAgenda(reservationId) {
    Firestore.instance
        .collection('reservaties')
        .document(reservationId)
        .snapshots()
        .listen((data) {
      if (this.mounted) {
        setState(() {
          showNotification = data.data["status"] == 1 ? true : false;
        });
      }
    });
  }

//TODO: check error
  showReservation(List<dynamic> garageId) {
    return Padding(
        padding: EdgeInsets.only(right: 15, left: 15, bottom: 10),
        child: MediaQuery.removePadding(
            context: context,
            removeTop: true,
            removeBottom: true,
            child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: garageId.length,
                itemBuilder: (_, index) {
                  return StreamBuilder<DocumentSnapshot>(
                      stream: Firestore.instance
                          .collection('reservaties')
                          .document(garageId[index])
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<DocumentSnapshot> reservatieSnapshot) {
                        if (reservatieSnapshot.hasData) {
                          return StreamBuilder<DocumentSnapshot>(
                              stream: Firestore.instance
                                  .collection('garages')
                                  .document(reservatieSnapshot.data["garageId"])
                                  .snapshots(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<DocumentSnapshot>
                                      garagesSnapshot) {
                                if (garagesSnapshot.hasData) {
                                  return StreamBuilder<DocumentSnapshot>(
                                      stream: Firestore.instance
                                          .collection('users')
                                          .document(reservatieSnapshot
                                              .data["aanvrager"])
                                          .snapshots(),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<DocumentSnapshot>
                                              userSnapshot) {
                                        if (userSnapshot.hasData) {
                                          return dontShowWhenRefused
                                              ? Container(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 20,
                                                      horizontal: 10),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                    color: Wit,
                                                  ),
                                                  child: Column(
                                                    children: <Widget>[
                                                      reservatieSnapshot.data[
                                                                  "status"] ==
                                                              1
                                                          ? Column(
                                                              children: <
                                                                  Widget>[
                                                                Text(
                                                                    garagesSnapshot
                                                                            .data[
                                                                        "adress"],
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.w500)),
                                                                Divider(),
                                                                Text(
                                                                  userSnapshot.data[
                                                                          "voornaam"] +
                                                                      translate(Keys
                                                                          .Apptext_Wantreserve) +
                                                                      reservatieSnapshot
                                                                          .data[
                                                                              "prijs"]
                                                                          .toString() +
                                                                      " €",
                                                                  style:
                                                                      SizeParagraph,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                ),
                                                              ],
                                                            )
                                                          : reservatieSnapshot
                                                                          .data[
                                                                      "status"] ==
                                                                  2
                                                              ? Column(
                                                                  children: <
                                                                      Widget>[
                                                                    Text(
                                                                        garagesSnapshot.data[
                                                                            "adress"],
                                                                        style: TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.w500)),
                                                                    Divider(),
                                                                    Column(
                                                                      children: <
                                                                          Widget>[
                                                                        Text(
                                                                            translate(Keys.Apptext_Reservedby) +
                                                                                userSnapshot.data["voornaam"],
                                                                            style: SizeParagraph),
                                                                        Text(
                                                                            reservatieSnapshot.data["prijs"].toStringAsFixed(2).toString() +
                                                                                " €",
                                                                            style:
                                                                                SizeParagraph)
                                                                      ],
                                                                    ),
                                                                  ],
                                                                )
                                                              : Container(),
                                                      reservatieSnapshot.data[
                                                                  "status"] ==
                                                              1
                                                          ? Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: <
                                                                  Widget>[
                                                                FlatButton(
                                                                    onPressed:
                                                                        () {
                                                                      if (this
                                                                          .mounted) {
                                                                        cancelReservation(
                                                                            garageId[index]);
                                                                      }
                                                                    },
                                                                    child: Text(
                                                                        translate(Keys
                                                                            .Button_Refuse)),
                                                                    textColor:
                                                                        Colors
                                                                            .red),
                                                                FlatButton(
                                                                  onPressed:
                                                                      () {
                                                                    if (this
                                                                        .mounted) {
                                                                      acceptReservation(
                                                                          garageId[
                                                                              index]);
                                                                    }
                                                                  },
                                                                  child: Text(
                                                                      translate(
                                                                          Keys.Button_Accept)),
                                                                  textColor:
                                                                      Blauw,
                                                                ),
                                                              ],
                                                            )
                                                          : Container()
                                                    ],
                                                  ),
                                                )
                                              : Container();
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
                        } else {
                          return Container();
                        }
                      });
                })));
  }

  showMyReservations(List<dynamic> garageId) {
    return Padding(
        padding: EdgeInsets.only(right: 15, left: 15, bottom: 10),
        child: MediaQuery.removePadding(
            context: context,
            removeTop: true,
            removeBottom: true,
            child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: garageId.length,
                itemBuilder: (_, index) {
                  return StreamBuilder<DocumentSnapshot>(
                      stream: Firestore.instance
                          .collection('reservaties')
                          .document(garageId[index])
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<DocumentSnapshot> reservationSnapshot) {
                        if (reservationSnapshot.hasData) {
                          return StreamBuilder<DocumentSnapshot>(
                              stream: Firestore.instance
                                  .collection('users')
                                  .document(
                                      reservationSnapshot.data["aanvrager"])
                                  .snapshots(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<DocumentSnapshot>
                                      userSnapshot) {
                                if (userSnapshot.hasData) {
                                  return Card(
                                      elevation: 0,
                                      child: StreamBuilder<DocumentSnapshot>(
                                          stream: Firestore.instance
                                              .collection('garages')
                                              .document(reservationSnapshot
                                                  .data['garageId'])
                                              .snapshots(),
                                          builder: (BuildContext context,
                                              AsyncSnapshot<DocumentSnapshot>
                                                  garageSnapchot) {
                                            if (garageSnapchot.hasData) {
                                              return ListTile(
                                                  leading: Image.network(
                                                      garageSnapchot.data['garageImg']
                                                          [0]),
                                                  title: Text(changeDate(
                                                          reservationSnapshot
                                                              .data["begin"]
                                                              .toDate()) +
                                                      " - " +
                                                      changeDate(reservationSnapshot
                                                          .data["end"]
                                                          .toDate())),
                                                  trailing: getStatus(
                                                      reservationSnapshot
                                                          .data["status"]));
                                            } else {
                                              return Container();
                                            }
                                          }));
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
                                    new AlwaysStoppedAnimation<Color>(Blauw)),
                          );
                        }
                      });
                })));
  }

  acceptReservation(String garageId) {
    try {
      Firestore.instance
          .collection('reservaties')
          .document(garageId)
          .updateData({
        "accepted": true,
        "status": 2,
      });
    } catch (e) {
      print(e.message);
    }
  }

  cancelReservation(String garageId) {
    try {
      Firestore.instance
          .collection('reservaties')
          .document(garageId)
          .updateData({
        "accepted": false,
        "status": 0,
      }).whenComplete(() {
        if (this.mounted) {
          setState(() {
            dontShowWhenRefused = false;
          });
        }
      });
    } catch (e) {
      print(e.message);
    }
  }

  getCurrentLanguageLocalizationKey(String code) {
    switch (code) {
      case "nl":
        return "nl_NL";
      case "fr":
        return "fr_FR";
      case "en":
        return "en_EN";
      default:
        return "en_EN";
    }
  }
}
