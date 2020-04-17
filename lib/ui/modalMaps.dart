import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:parkly/constant.dart';
import 'package:parkly/pages/detailGarage.dart';
import 'package:parkly/script/checkFavorite.dart';
import 'package:parkly/ui/showStars.dart';
import '../setup/globals.dart' as globals;

class ModalMapComponent extends StatefulWidget {
  final DocumentSnapshot garage;
  ModalMapComponent({
    @required this.garage,
  });

  @override
  _ModalMapComponentState createState() =>
      _ModalMapComponentState(garage: garage);
}

class _ModalMapComponentState extends State<ModalMapComponent> {
  DocumentSnapshot garage;
  _ModalMapComponentState({Key key, this.garage});

  List mijnFavorieten = [];

  getUserData() async {
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
    return GestureDetector(
        onTap: () {
          Navigator.push(context,
                          MaterialPageRoute(builder: (context) => DetailGarage(idGarage: garage.documentID)));
        },
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)),
                    child: ConstrainedBox(
                        constraints:
                            const BoxConstraints(minWidth: double.infinity),
                        child: Container(
                            height: 200,
                            color: Zwart,
                            child: Image.network(garage['garageImg'],
                                fit: BoxFit.cover)))),
                Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      decoration: new BoxDecoration(
                        color: Wit,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: mijnFavorieten.contains(garage.documentID)
                            ? Icon(Icons.favorite)
                            : Icon(Icons.favorite_border),
                        color: Blauw,
                        onPressed: () {
                          setState(() {
                            CheckFav().isgarageInFavorite(garage.documentID);
                          });
                        },
                      ),
                    )),
              ],
            ),
            Padding(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(children: <Widget>[
                              ShowStars(rating: garage["rating"]),
                              Padding(
                                  padding: EdgeInsets.only(left: 10, top: 5),
                                  child: Text("(" +
                                      garage['rating'].length.toString() +
                                      " reviews)"))
                            ]),
                            Text(garage["prijs"].toString() + "€",
                                style: ShowPriceStyle),
                          ],
                        )),
                    Text(garage['street'], style: SubTitleCustom),
                    Text(garage['city'] + " " + garage['postcode'],
                        style: SubTitleCustom),
                  ],
                )),
          ],
        ));
  }
}
