import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:parkly/constant.dart';
import 'package:parkly/localization/keys.dart';
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
    ContainerTransitionType _transitionType = ContainerTransitionType.fade;
    return OpenContainer(
        closedElevation: 0,
        closedColor: Transparant,
        transitionType: _transitionType,
        openBuilder: (BuildContext context, VoidCallback _) {
          return DetailGarage(idGarage: garage.documentID);
        },
        closedBuilder: (BuildContext context, VoidCallback openContainer) {
          return GestureDetector(
              onTap: openContainer,
              child: Column(
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      ClipRRect(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20)),
                          child: ConstrainedBox(
                              constraints: const BoxConstraints(
                                  minWidth: double.infinity),
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
                                if (this.mounted) {
                                  setState(() {
                                    CheckFav()
                                        .isgarageInFavorite(garage.documentID);
                                  });
                                }
                              },
                            ),
                          )),
                    ],
                  ),
                  Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                              padding: EdgeInsets.symmetric(vertical: 5),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Row(children: <Widget>[
                                    ShowStars(rating: garage["rating"]),
                                    Padding(
                                        padding:
                                            EdgeInsets.only(left: 10, top: 5),
                                        child: Text("( " +
                                            garage['rating'].length.toString() +
                                            " " +
                                            translate(Keys.Subtitle_Reviews) +
                                            " )"))
                                  ]),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[
                                      Text(garage['prijs'].toString() + " €",
                                          style: ShowPriceStyle),
                                      Text(translate(Keys.Apptext_Hourly))
                                    ],
                                  )
                                ],
                              )),
                          Text(garage['street'], style: SubTitleCustom),
                          Text(garage['city'] + " " + garage['postcode'],
                              style: SubTitleCustom),
                        ],
                      )),
                ],
              ));
        });
  }
}
