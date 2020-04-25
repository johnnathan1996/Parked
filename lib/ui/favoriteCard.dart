import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:parkly/pages/detailGarage.dart';
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
      setState(() {
        mijnFavorieten = userInstance.data["favoriet"];
      });
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
                child: Image.network(garage['garageImg']),
              ),
            ),
            subtitle: Padding(
                padding: EdgeInsets.only(top: 10),
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
                        ShowStars(rating: garage["rating"]),
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
