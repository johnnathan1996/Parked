import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:content_placeholder/content_placeholder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:parkly/localization/keys.dart';
import 'package:parkly/detailPages/detailGarage.dart';
import 'package:parkly/script/checkFavorite.dart';
import 'package:parkly/ui/showStars.dart';
import '../constant.dart';
import '../setup/globals.dart' as globals;

class FavoriteCardComponent extends StatefulWidget {
  final DocumentSnapshot garage;

  FavoriteCardComponent({
    @required this.garage,
  });
  @override
  _FavoriteCardComponentState createState() =>
      _FavoriteCardComponentState(garage: garage);
}

class _FavoriteCardComponentState extends State<FavoriteCardComponent> {
  final DocumentSnapshot garage;
  _FavoriteCardComponentState({Key key, this.garage});

  List mijnFavorieten = [];

  getUserData() {
    Firestore.instance
        .collection('users')
        .document(globals.userId)
        .snapshots()
        .listen((userInstance) {
      if (this.mounted) {
        setState(() {
          mijnFavorieten = userInstance.data["favoriet"];
        });
      }
    });
  }

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 1.0,
        margin: new EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: ListTile(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          DetailGarage(idGarage: garage.documentID)));
            },
            title: ClipRect(
              child: Align(
                alignment: Alignment.center,
                heightFactor: 0.5,
                child: Image.network(
                  garage['garageImg'],
                  fit: BoxFit.cover,
                  loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent loadingProgress) {
                    if (loadingProgress == null) return child;
                    return ContentPlaceholder(
                      height: 250,
                    );
                  },
                ),
              ),
            ),
            subtitle: Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(garage['street'],
                            style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                                color: Zwart)),
                        Text(garage['city'] + " " + garage['postcode'],
                            style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                                color: Zwart)),
                        Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              ShowStars(rating: garage["rating"]),
                              Padding(
                                  padding: EdgeInsets.only(left: 10, top: 5),
                                  child: Text("( " +
                                      garage['rating'].length.toString() +
                                      " " +
                                      translate(Keys.Subtitle_Reviews) +
                                      " )"))
                            ])
                      ],
                    ),
                    IconButton(
                      icon: mijnFavorieten.contains(garage.documentID)
                          ? Icon(Icons.favorite)
                          : Icon(Icons.favorite_border),
                      color: Blauw,
                      onPressed: () {
                        CheckFav().isgarageInFavorite(garage.documentID);
                      },
                    )
                  ],
                ))));
  }
}
