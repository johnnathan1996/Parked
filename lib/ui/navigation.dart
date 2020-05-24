import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:parkly/constant.dart';
import 'package:parkly/pages/favorite.dart';
import 'package:parkly/pages/garages.dart';
import 'package:parkly/pages/historiek.dart';
import 'package:parkly/pages/instellingen.dart';
import 'package:parkly/pages/maps.dart';
import 'package:parkly/pages/message.dart';
import 'package:parkly/pages/profile.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:parkly/localization/keys.dart';
import 'package:parkly/ui/dot.dart';
import '../setup/globals.dart' as globals;

List<Widget> navItemWidget = [];

class Navigation extends StatefulWidget {
  final bool activeProf;
  final bool activeMap;
  final bool activeFav;
  final bool activeHis;
  final bool activeMes;
  final bool activeGar;

  Navigation({
    this.activeProf = false,
    this.activeMap = false,
    this.activeFav = false,
    this.activeHis = false,
    this.activeMes = false,
    this.activeGar = false,
  });
  @override
  _NavigationState createState() => _NavigationState(
        activeProf: activeProf,
        activeMap: activeMap,
        activeFav: activeFav,
        activeHis: activeHis,
        activeMes: activeMes,
        activeGar: activeGar,
      );
}

class _NavigationState extends State<Navigation> {
  bool activeProf;
  bool activeMap;
  bool activeFav;
  bool activeHis;
  bool activeMes;
  bool activeGar;

  _NavigationState(
      {Key key,
      this.activeProf,
      this.activeMap,
      this.activeFav,
      this.activeHis,
      this.activeMes,
      this.activeGar});

  @override
  void initState() {
    super.initState();
    navItemWidget = [];

    List navItems = [
      {
        "label": translate(Keys.Apptext_Profile),
        "icon": Icons.person,
        "active": activeProf,
        "redirect": ProfilePage(),
        "trailing": null
      },
      {
        "label": translate(Keys.Navigation_Search),
        "icon": Icons.map,
        "active": activeMap,
        "redirect": MapsPage(),
        "trailing": null
      },
      {
        "label": translate(Keys.Navigation_Favorite),
        "icon": Icons.favorite,
        "active": activeFav,
        "redirect": FavoritePage(),
        "trailing": null
      },
      {
        "label": translate(Keys.Navigation_Message),
        "icon": Icons.message,
        "active": activeMes,
        "redirect": MessagePage(),
        "trailing": globals.notifications == 0 ? null : globals.notifications
      },
      {
        "label": translate(Keys.Navigation_Garage),
        "icon": Icons.directions_car,
        "active": activeGar,
        "redirect": GaragePage(),
        "trailing": null
      },
      {
        "label": translate(Keys.Navigation_Hist),
        "icon": Icons.history,
        "active": activeHis,
        "redirect": HistoriekPage(),
        "trailing": null
      },
    ];

    navItems.forEach((value) {
      if (!value["active"]) {
        navItemWidget.add(ListTile(
          leading: Icon(value["icon"], color: Zwart),
          trailing: value["trailing"] != null
              ? DotComponent(number: value["trailing"])
              : null,
          title: Text(value["label"]),
          onTap: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => value["redirect"]));
          },
        ));
      } else {
        navItemWidget.add(Ink(
            color: Zwart,
            child: ListTile(
              leading: Icon(value["icon"], color: Wit),
              trailing: value["trailing"] != null
                  ? DotComponent(number: value["trailing"])
                  : null,
              title: Text(value["label"], style: TextStyle(color: Wit)),
              onTap: () {
                Navigator.pop(context);
              },
            )));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: StreamBuilder<DocumentSnapshot>(
        stream: Firestore.instance
            .collection('users')
            .document(globals.userId)
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          return Column(children: <Widget>[
            Expanded(
                child: ListView(
              children: <Widget>[
                UserAccountsDrawerHeader(
                  decoration: BoxDecoration(color: Wit),
                  arrowColor: Wit,
                  otherAccountsPictures: <Widget>[
                    IconButton(
                      icon: Icon(Icons.close, color: Zwart),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    )
                  ],
                  currentAccountPicture: Image.asset('assets/images/logo.png'),
                  accountName: snapshot.hasData
                      ? Text(snapshot.data['voornaam'],
                          style: TextStyle(color: Zwart))
                      : Text("", style: TextStyle(color: Zwart)),
                  accountEmail: snapshot.hasData
                      ? Text(snapshot.data['email'],
                          style: TextStyle(color: Zwart))
                      : Text("", style: TextStyle(color: Zwart)),
                ),
                Column(
                  children: navItemWidget,
                ),
                Divider(
                  color: Grijs,
                )
              ],
            )),
            Padding(
                padding: EdgeInsets.only(bottom: 30, right: 10, left: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("V. 1.0.12",
                        style: TextStyle(
                            fontStyle: FontStyle.italic, color: Grijs)),
                    IconButton(
                        icon: Icon(Icons.settings),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Instellingen(),
                                  fullscreenDialog: true));
                        })
                  ],
                ))
          ]);
        },
      ),
    );
  }
}
