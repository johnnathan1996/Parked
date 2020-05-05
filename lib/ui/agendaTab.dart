import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:parkly/constant.dart';
import 'package:parkly/script/changeDate.dart';
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
  Map<DateTime, List> _reservations = {};
  Map<DateTime, List> _myReservations = {};

  getResevations() {
    Firestore.instance
        .collection('reservaties')
        .where('eigenaar', isEqualTo: globals.userId)
        .snapshots()
        .listen((data) {
      _reservations = {};
      data.documents.forEach((element) {
        if (this.mounted) {
          setState(() {
            if (_reservations.containsKey(
                changeDatetimeToDatetime(element.data["begin"].toDate()))) {
              _reservations.update(
                  changeDatetimeToDatetime(element.data["begin"].toDate()),
                  (value) {
                value.add(element.documentID);

                return value;
              });
            }

            if (!_reservations.containsKey(
                changeDatetimeToDatetime(element.data["begin"].toDate()))) {
              _reservations[
                  changeDatetimeToDatetime(element.data["begin"].toDate())] = [
                element.documentID
              ];
            }
          });
        }
      });
    });
  }

  getMyResevations() {
    Firestore.instance
        .collection('reservaties')
        .where('aanvrager', isEqualTo: globals.userId)
        .snapshots()
        .listen((data) {
      _myReservations = {};
      data.documents.forEach((element) {
        if (this.mounted) {
          setState(() {
            if (_myReservations.containsKey(
                changeDatetimeToDatetime(element.data["begin"].toDate()))) {
              _myReservations.update(
                  changeDatetimeToDatetime(element.data["begin"].toDate()),
                  (value) {
                value.add(element.documentID);

                return value;
              });
            }

            if (!_myReservations.containsKey(
                changeDatetimeToDatetime(element.data["begin"].toDate()))) {
              _myReservations[
                  changeDatetimeToDatetime(element.data["begin"].toDate())] = [
                element.documentID
              ];
            }
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
              holidayStyle: TextStyle().copyWith(color: Colors.green)),
          builders: CalendarBuilders(
            markersBuilder: (context, date, events, holidays) {
              final children = <Widget>[];

              if (events.isNotEmpty) {
                children.add(
                  Positioned(
                      right: 0,
                      top: 0,
                      child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: Zwart),
                          width: 20,
                          height: 20,
                          child: Center(
                            child: Text(
                              '${events.length}',
                              style: TextStyle().copyWith(
                                color: Colors.white,
                                fontSize: 12.0,
                              ),
                            ),
                          ))),
                );
              }

              if (holidays.isNotEmpty) {
                children.add(
                  Positioned(
                      bottom: 10,
                      child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _calendarController.isSelected(date)
                                ? Wit
                                : _calendarController.isToday(date)
                                    ? Wit
                                    : Colors.green,
                          ),
                          width: 5,
                          height: 5)),
                );
              }

              return children;
            },
          ),
        ),
        Divider(),
        showGarage
            ? Expanded(child: showReservation(showGarageId))
            : Container()
      ],
    );
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
                          return Card(
                              elevation: 0,
                              child: ListTile(
                                  title: Text(getTime(
                                          snapshot.data["begin"].toDate()) +
                                      " to " +
                                      getTime(snapshot.data["end"].toDate()))));
                        } else {
                          return Text("geen data");
                        }
                      });
                })));
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
