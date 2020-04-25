import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:parkly/constant.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import '../setup/globals.dart' as globals;

class RatingModal extends StatefulWidget {
  final String idGarage;

  RatingModal({
    @required this.idGarage,
  });
  @override
  State<StatefulWidget> createState() => _RatingModalState(idGarage: idGarage);
}

class _RatingModalState extends State<RatingModal>
    with SingleTickerProviderStateMixin {
  String idGarage;
  _RatingModalState({Key key, this.idGarage});
  AnimationController controller;
  Animation<double> scaleAnimation;
  double rating = 0.0;
  String _beschrijvingRating;

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 450));
    scaleAnimation =
        CurvedAnimation(parent: controller, curve: Curves.elasticInOut);

    controller.addListener(() {
      setState(() {});
    });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: ScaleTransition(
          scale: scaleAnimation,
          child: Container(
            constraints: BoxConstraints(
                minWidth: MediaQuery.of(context).size.width * 0.60,
                maxWidth: MediaQuery.of(context).size.width * 0.80),
            decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0))),
            child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SmoothStarRating(
                      allowHalfRating: false,
                      onRatingChanged: (value) {
                        if (this.mounted) {
                          setState(() {
                            rating = value;
                          });
                        }
                      },
                      starCount: 5,
                      rating: rating,
                      size: 30.0,
                      filledIconData: Icons.star,
                      halfFilledIconData: Icons.star_half,
                      color: Blauw,
                      borderColor: Blauw,
                      spacing: 0.0),
                  Padding(
                      padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
                      child: TextFormField(
                        onChanged: (value) {
                          if (this.mounted) {
                            setState(() {
                              _beschrijvingRating = value;
                            });
                          }
                        },
                        decoration: InputDecoration(
                            hintText: "Schijf hier waarom",
                            border: InputBorder.none,
                            filled: true,
                            fillColor: Wit,
                            labelStyle: TextStyle(color: Zwart)),
                        maxLines: 3,
                      )),
                  FlatButton(
                    padding: EdgeInsets.symmetric(vertical: 0),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    onPressed: () {
                      createRatingScore();
                    },
                    child: Container(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        decoration: ShapeDecoration(
                            color: Blauw,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(15),
                                    bottomRight: Radius.circular(15)))),
                        alignment: Alignment.center,
                        child: Text(
                          "Doorsturen",
                          style: TextStyle(color: Wit),
                        )),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void createRatingScore() async {
    try {
      await Firestore.instance
          .collection('garages')
          .document(idGarage)
          .updateData({
        "rating": FieldValue.arrayUnion([
          {
            'comment': _beschrijvingRating,
            'date': DateTime.now(),
            'editor': globals.userId,
            'score': rating,
          }
        ])
      }).whenComplete(() {
        Navigator.of(context).pop();
      });
    } catch (e) {
      print(e.message);
    }
  }
}
