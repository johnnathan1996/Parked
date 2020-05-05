import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:content_placeholder/content_placeholder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';
import 'package:parkly/detailPages/detailGarage.dart';
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
    return Card(
        elevation: 1.0,
        margin: new EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: ListTile(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DetailGarage(
                          idGarage: garage.documentID, isVanMij: true)));
            },
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
                child: ExpandablePanel(
                  hasIcon: true,
                  header: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          garage['titel'],
                          style: SubTitleCustom,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            ShowStars(rating: garage["rating"]),
                            Padding(
                                padding: EdgeInsets.only(left: 10, top: 5),
                                child: Text("( " +
                                    garage['rating'].length.toString() + " " + translate(Keys.Subtitle_Reviews) +
                                    " )"))
                          ],
                        )
                      ]),
                  expanded: Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                              padding: EdgeInsets.only(bottom: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(garage['street'],
                                          style: SizeParagraph),
                                      Text(
                                          garage['city'] +
                                              " " +
                                              garage['postcode'],
                                          style: SizeParagraph),
                                    ],
                                  ),
                                  Text(garage['prijs'].toString() + " €",
                                      style: ShowPriceStyle)
                                ],
                              )),
                          Text(garage['beschrijving'])
                        ],
                      )),
                ))));
  }

  deletePost(String id) async {
    Firestore.instance.collection('users').document(globals.userId).updateData({
      "mijnGarage": FieldValue.arrayRemove([id])
    }).then((value) {
      Firestore.instance.collection("garages").document(id).delete();
    });
  }
}
