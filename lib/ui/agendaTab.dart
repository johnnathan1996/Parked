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

class _AgendaTabState extends State<AgendaTab> {
  CalendarController _calendarController;
  List<dynamic> showGarageId = [];
  bool showGarage = false;
  bool showMyResevation = false;
  Map<DateTime, List> _reservations = {};
  Map<DateTime, List> _myReservations = {};

  MaterialColor color = Colors.orange;

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
    getResevations();
    getMyResevations();

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
              children.add(Positioned(
                  bottom: 10,
                  child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: _calendarController.isSelected(date)
                            ? Wit
                            : _calendarController.isToday(date) ? Wit : Blauw,
                      ),
                      width: 5,
                      height: 5)));
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

  getColor(reservationId) {
    Firestore.instance
        .collection('reservaties')
        .document(reservationId)
        .snapshots()
        .listen((data) {
      setState(() {
        color = data.data["status"] == 1 ? Colors.orange : Colors.green;
      });
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
                                if (snapshots.hasData) {
                                  return Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 20, horizontal: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Wit,
                                    ),
                                    child: Column(
                                      children: <Widget>[
                                        Text(
                                            translate(Keys.Apptext_Reservedby) +
                                                snapshots.data["voornaam"] +
                                                " pour " +
                                                snapshot.data["prijs"]
                                                    .toString() +
                                                " €"),
                                        snapshot.data["status"] == 1
                                            ? Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  FlatButton(
                                                      onPressed: () {
                                                        cancelReservation(
                                                            garageId[index]);
                                                      },
                                                      child: Text(translate(
                                                          Keys.Button_Refuse)),
                                                      textColor: Colors.red),
                                                  FlatButton(
                                                    onPressed: () {
                                                      acceptReservation(
                                                          garageId[index]);
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
        return "nl_NL";
    }
  }
}
