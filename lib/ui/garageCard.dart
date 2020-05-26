import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:content_placeholder/content_placeholder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';
import 'package:parkly/pages/detailGarage.dart';
import 'package:parkly/ui/showStars.dart';
import '../constant.dart';
import '../setup/globals.dart' as globals;
import 'package:flutter_translate/flutter_translate.dart';
import 'package:parkly/localization/keys.dart';

class GarageCardComponent extends StatelessWidget {
  final DocumentSnapshot garage;

  GarageCardComponent({
    @required this.garage,
  });

  @override
  Widget build(BuildContext context) {
    ContainerTransitionType _transitionType = ContainerTransitionType.fade;
    return Padding(
      padding: const EdgeInsets.all(10),
      child: OpenContainer(
        transitionType: _transitionType,
        openBuilder: (BuildContext context, VoidCallback _) {
          return DetailGarage(idGarage: garage.documentID, isVanMij: true);
        },
        closedBuilder: (BuildContext context, VoidCallback openContainer) {
          return ListTile(
              onTap: openContainer,
              onLongPress: () {
                showCupertinoModalPopup(
                    context: context,
                    builder: (BuildContext context) {
                      return CupertinoActionSheet(
                        cancelButton: CupertinoActionSheetAction(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(translate(Keys.Button_Cancel)),
                        ),
                        actions: <Widget>[
                          CupertinoActionSheetAction(
                            onPressed: () {
                              deletePost(garage.documentID);
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              translate(Keys.Button_Delete),
                              style: TextStyle(color: Colors.red),
                            ),
                          )
                        ],
                      );
                    });
              },
              title: ClipRect(
                child: Align(
                  alignment: Alignment.center,
                  heightFactor: 0.5,
                  child: Image.network(
                    garage['garageImg'],
                    fit: BoxFit.cover,
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent progress) {
                      return progress == null
                          ? child
                          : ContentPlaceholder(
                              height: 250,
                            );
                    },
                  ),
                ),
              ),
              subtitle: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: ExpandablePanel(
                    hasIcon: true,
                    header: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(garage['adress'], style: SubTitleCustom),
                            ],
                          ),
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
                            ],
                          )
                        ]),
                    expanded: Padding(
                        padding: EdgeInsets.only(top: 20, bottom: 10),
                        child: Row(
                          children: <Widget>[
                            Expanded(child: Text(garage['beschrijving'])),
                            Text(garage['prijs'].toString() + " €",
                                style: ShowPriceStyle)
                          ],
                        )),
                  )));
        },
      ),
    );
  }

  deletePost(String id) async {
    Firestore.instance.collection('users').document(globals.userId).updateData({
      "mijnGarage": FieldValue.arrayRemove([id])
    }).whenComplete(() {
      Firestore.instance.collection("garages").document(id).delete();
    });
  }
}
