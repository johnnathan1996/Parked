import 'package:flutter/material.dart';
import 'package:parkly/constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:parkly/localization/keys.dart';
import 'package:parkly/ui/favoriteCard.dart';
import 'package:parkly/ui/navigation.dart';
import 'package:parkly/ui/title.dart';
import '../setup/globals.dart' as globals;

class FavoritePage extends StatefulWidget {
  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  List<Widget> garageFav = [];

  getGarages() {
    Stream<DocumentSnapshot> reference = Firestore.instance
        .collection('users')
        .document(globals.userId)
        .snapshots();

    reference.listen((snapshot) {
      List mijnFavoriete = snapshot.data['favoriet'];
      garageFav = [];
      mijnFavoriete.forEach((favorieteID) {
        Firestore.instance
            .collection('garages')
            .document(favorieteID)
            .get()
            .then((value) {
          if (value.exists) {
            if (this.mounted) {
              setState(() {
                garageFav.add(FavoriteCardComponent(
                  garage: value,
                ));
              });
            }
          }
        });
      });
    });
  }

  @override
  void initState() {
    getGarages();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Zwart),
          backgroundColor: Wit,
          elevation: 0.0,
          title: Image.asset('assets/images/logo.png', height: 32),
        ),
        body: Container(
            decoration: BoxDecoration(
                image: new DecorationImage(
                    image: new AssetImage('assets/images/backgroundP.png'),
                    fit: BoxFit.cover)),
            child: Column(children: <Widget>[
              TitleComponent(label: translate(Keys.Title_Favorite)),
              garageFav.length != 0
                  ? Expanded(
                      child: ListView(
                      children: garageFav,
                    ))
                  : Container(),
            ])),
        drawer: Navigation(activeFav: true));
  }
}
