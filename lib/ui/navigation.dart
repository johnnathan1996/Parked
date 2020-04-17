import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:parkly/constant.dart';
import 'package:parkly/pages/favorite.dart';
import 'package:parkly/pages/garages.dart';
import 'package:parkly/pages/instellingen.dart';
import 'package:parkly/pages/maps.dart';
import 'package:parkly/pages/profile.dart';
import '../setup/globals.dart' as globals;

List<Widget> navItemWidget = [];

class Navigation extends StatefulWidget {
  final bool activeMap;
  final bool activeFav;
  final bool activeHis;
  final bool activeGar;

  Navigation({
    this.activeMap = false,
    this.activeFav = false,
    this.activeHis = false,
    this.activeGar = false,
  });
  @override
  _NavigationState createState() => _NavigationState(
        activeMap: activeMap,
        activeFav: activeFav,
        activeGar: activeGar,
      );
}

class _NavigationState extends State<Navigation> {
  bool activeMap;
  bool activeFav;
  bool activeGar;

  _NavigationState(
      {Key key,
      this.activeMap,
      this.activeFav,
      this.activeGar});

  @override
  void initState() {
    super.initState();
    navItemWidget = [];

    List navItems = [
      {
        "label": "Map",
        "icon": Icons.map,
        "active": activeMap,
        "redirect": MapsPage(),
      },
      {
        "label": "Favoriet",
        "icon": Icons.favorite,
        "active": activeFav,
        "redirect": FavoritePage(),
      },
      {
        "label": "Mijn garage",
        "icon": Icons.directions_car,
        "active": activeGar,
        "redirect": GaragePage(),
      }
    ];

    navItems.forEach((value) {
      if (!value["active"]) {
        navItemWidget.add(ListTile(
          leading: Icon(value["icon"], color: Zwart),
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
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
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
                      currentAccountPicture:
                          Image.asset('assets/images/logo.png'),
                      accountName: snapshot.hasData
                          ? Text(snapshot.data['voornaam'],
                              style: TextStyle(color: Zwart))
                          : Text("voornaam", style: TextStyle(color: Zwart)),
                      accountEmail: snapshot.hasData
                          ? Text(snapshot.data['email'],
                              style: TextStyle(color: Zwart))
                          : Text("email", style: TextStyle(color: Zwart)),
                      onDetailsPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProfilePage()));
                      },
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
                  padding: EdgeInsets.only(bottom: 30, right: 10),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child:IconButton(
                          icon: Icon(Icons.settings),
                          onPressed: () {
                            Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Instellingen(),
                                fullscreenDialog: true));
                          })))
              ]);
            },
          ),
        );
  }
}
