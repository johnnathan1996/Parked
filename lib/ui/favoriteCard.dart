import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:content_placeholder/content_placeholder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:parkly/pages/detailGarage.dart';
import 'package:parkly/script/checkFavorite.dart';
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
    ContainerTransitionType _transitionType = ContainerTransitionType.fade;
    return Padding(
      padding: const EdgeInsets.all(10),
      child: OpenContainer(
          transitionType: _transitionType,
          openBuilder: (BuildContext context, VoidCallback _) {
            return DetailGarage(idGarage: garage.documentID);
          },
          closedBuilder: (BuildContext context, VoidCallback openContainer) {
            return ListTile(
                onTap: openContainer,
                title: ClipRect(
                  child: Align(
                    alignment: Alignment.center,
                    heightFactor: 0.5,
                    child: Image.network(
                      garage['garageImg'][0],
                      fit: BoxFit.cover,
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent loadingProgress) {
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
                        Expanded(
                          child: Text(
                            garage['adress'],
                            style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                                color: Zwart),
                          ),
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
                    )));
          }),
    );
  }
}
