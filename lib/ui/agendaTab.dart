import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:parkly/constant.dart';
import 'package:parkly/localization/keys.dart';
import 'package:parkly/script/changeDate.dart';
import 'package:parkly/script/getStatus.dart';
import '../setup/globals.dart' as globals;
import 'package:flutter_translate/flutter_translate.dart';
import 'package:table_calendar/table_calendar.dart';

class AgendaTab extends StatefulWidget {
  @override
  _AgendaTabState createState() => _AgendaTabState();
}

//TODO: firebase function to change status after 7 days whitout answer

class _AgendaTabState extends State<AgendaTab> {
  CalendarController _calendarController;
  List<dynamic> showGarageId = [];
  bool showGarage = false;
  bool showMyResevation = false;
  Map<DateTime, List> _reservations = {};
  Map<DateTime, List> _myReservations = {};

  MaterialColor color = Colors.orange;
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

    return Column(
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
            if (_myReservations.containsKey(changeDatetimeToDatetime(value))) {
              if (this.mounted) {
                setState(() {
                  showGarageId = _myReservations.values.first;
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
              holidayStyle: TextStyle().copyWith(color: color)),
          builders: CalendarBuilders(
              markersBuilder: (context, date, events, holidays) {
            final children = <Widget>[];

            if (events.isNotEmpty) {
              if (this.mounted) {
                getNotificationAgenda(events.first);
              }
              children.add(showNotification
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
                    ));
            }

            if (holidays.isNotEmpty) {
              if (this.mounted) {
                getColor(holidays.first);
              }
              children.add(
                Positioned(
                    bottom: 10,
                    child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _calendarController.isSelected(date)
                              ? Wit
                              : _calendarController.isToday(date) ? Wit : color,
                        ),
                        width: 5,
                        height: 5)),
              );
            }

            return children;
          }),
        ),
        Divider(),
        showGarage
            ? Expanded(child: showReservation(showGarageId))
            : Container(),
        showMyResevation
            ? Expanded(child: showMyReservations(showGarageId))
            : Container()
      ],
    );
  }

  //TODO: fix error color
  getColor(reservationId) {
    Firestore.instance
        .collection('reservaties')
        .document(reservationId)
        .snapshots()
        .listen((data) {
      if (this.mounted) {
        setState(() {
          color = data.data["status"] == 1 ? Colors.orange : Colors.green;
        });
      }
    });
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

  showReservation(List<dynamic> garageId) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: garageId.length,
                itemBuilder: (_, index) {
                  return StreamBuilder<DocumentSnapshot>(
                      stream: Firestore.instance
                          .collection('reservaties')
                          .document(garageId[index])
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<DocumentSnapshot> snapshot) {
                        if (snapshot.hasData) {
                          return StreamBuilder<DocumentSnapshot>(
                              stream: Firestore.instance
                                  .collection('users')
                                  .document(snapshot.data["aanvrager"])
                                  .snapshots(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<DocumentSnapshot> snapshots) {
                                    //TODO: welke garage wilt meneer reserveren als ik meerdere garages heb
                                if (snapshots.hasData) {
                                  return dontShowWhenRefused
                                      ? Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 20, horizontal: 10),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            color: Wit,
                                          ),
                                          child: Column(
                                            children: <Widget>[
                                              snapshot.data["status"] == 1
                                                  ? Text(snapshots
                                                          .data["voornaam"] +
                                                      translate(Keys
                                                          .Apptext_Wantreserve) +
                                                      snapshot.data["prijs"]
                                                          .toString())
                                                  : snapshot.data["status"] == 2
                                                      ? Text(translate(Keys
                                                              .Apptext_Reservedby) +
                                                          snapshots.data[
                                                              "voornaam"] +
                                                          "- " +
                                                          snapshot.data["prijs"]
                                                              .toString() +
                                                          " €")
                                                      : Container(),
                                              snapshot.data["status"] == 1
                                                  ? Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        FlatButton(
                                                            onPressed: () {
                                                              if (this
                                                                  .mounted) {
                                                                cancelReservation(
                                                                    garageId[
                                                                        index]);
                                                              }
                                                            },
                                                            child: Text(
                                                                translate(Keys
                                                                    .Button_Refuse)),
                                                            textColor:
                                                                Colors.red),
                                                        FlatButton(
                                                          onPressed: () {
                                                            if (this.mounted) {
                                                              acceptReservation(
                                                                  garageId[
                                                                      index]);
                                                            }
                                                          },
                                                          child: Text(translate(
                                                              Keys.Button_Accept)),
                                                          textColor: Blauw,
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
                                    new AlwaysStoppedAnimation<Color>(Blauw)),
                          );
                        }
                      });
                })));
  }

  showMyReservations(List<dynamic> garageId) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: ListView.builder(
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
                                                      garageSnapchot
                                                          .data['garageImg']),
                                                  title: Text(changeDate(
                                                          reservationSnapshot
                                                              .data["begin"]
                                                              .toDate()) +
                                                      " - " +
                                                      changeDate(
                                                          reservationSnapshot
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
