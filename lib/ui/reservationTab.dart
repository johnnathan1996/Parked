import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:parkly/constant.dart';
import 'package:parkly/script/changeDate.dart';
import 'package:url_launcher/url_launcher.dart';
import '../setup/globals.dart' as globals;
import 'package:flutter_translate/flutter_translate.dart';
import 'package:parkly/localization/keys.dart';
import 'package:table_calendar/table_calendar.dart';

class Reservations extends StatefulWidget {
  @override
  _ReservationsState createState() => _ReservationsState();
}

class _ReservationsState extends State<Reservations> {
  CalendarController _calendarController;

  @override
  void initState() {
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

    final Map<DateTime, List> _events = {
      DateTime(2020, 5, 12): ['Easter Sunday'],
      DateTime(2020, 5, 22): ['Easter Monday'],
    };

    return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection('reservaties')
            .where('eigenaar', isEqualTo: globals.userId)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return TableCalendar(
              calendarController: _calendarController,
              locale: getCurrentLanguageLocalizationKey(
                  localizationDelegate.currentLocale.languageCode),
              startingDayOfWeek: StartingDayOfWeek.monday,
              initialCalendarFormat: CalendarFormat.month,
              events: _events,
              headerStyle: HeaderStyle(
                centerHeaderTitle: true,
                formatButtonVisible: false,
              ),
              onDaySelected: (value, a) {
                print(value.toString());
              },
              daysOfWeekStyle: DaysOfWeekStyle(
                  weekendStyle: TextStyle().copyWith(color: Blauw),
                  weekdayStyle: TextStyle().copyWith(color: Zwart)),
              calendarStyle: CalendarStyle(
                todayColor: Grijs,
                selectedColor: Blauw,
                weekdayStyle: TextStyle().copyWith(color: Zwart),
                weekendStyle: TextStyle().copyWith(color: Blauw),
              ),
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
                                borderRadius: BorderRadius.circular(10),
                                shape: BoxShape.rectangle,
                                color: _calendarController.isSelected(date)
                                    ? Zwart
                                    : _calendarController.isToday(date)
                                        ? Zwart
                                        : Blauw,
                              ),
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

                  return children;
                },
              ),
            );
          } else {
            return Container(
              alignment: Alignment.center,
              child: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(Blauw)),
            );
          }
        });
  }

  showReservation(AsyncSnapshot<QuerySnapshot> snapshot) {
    return MediaQuery.removePadding(
        removeTop: true,
        context: context,
        child: ListView.builder(
          itemCount: snapshot.data.documents.length,
          itemBuilder: (_, index) {
            return Container(
                margin:
                    EdgeInsets.only(bottom: 0, left: 20, right: 20, top: 20),
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
                            .document(
                                snapshot.data.documents[index].data["garageId"])
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
                                      child: Text(
                                          translate(Keys.Button_Openwaze) +
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
