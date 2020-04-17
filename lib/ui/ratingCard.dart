import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:parkly/constant.dart';
import 'package:parkly/script/changeDate.dart';

class RatingCardComponent extends StatefulWidget {
  final Map card;

  RatingCardComponent({
    @required this.card,
  });

  @override
  State<StatefulWidget> createState() => _RatingCardComponentState(card: card);
}

class _RatingCardComponentState extends State<RatingCardComponent>
    with SingleTickerProviderStateMixin {
  Map card;
  _RatingCardComponentState({Key key, this.card});

  String editorName = "";
  String urlImage = "";

  getUserData() {
    Firestore.instance
        .collection('users')
        .document(card["editor"])
        .get()
        .then((value) {
      setState(() {
        editorName =
            value.data["voornaam"] + " " + value.data["achternaam"][0] + ".";
        urlImage = value.data["imgUrl"];
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
    return ClipRRect(
        borderRadius: new BorderRadius.circular(15.0),
        child: Container(
          padding: EdgeInsets.all(20),
          color: Wit,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.only(right: 10),
                      width: 40.0,
                      height: 40.0,
                      decoration: new BoxDecoration(
                          shape: BoxShape.circle,
                          image: urlImage != ''
                              ? DecorationImage(
                                  fit: BoxFit.fill,
                                  image: NetworkImage(urlImage))
                              : null)),
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(editorName),
                          Text(changeDate(card["date"]),
                              style: TextStyle(color: Grijs))
                        ],
                      ),
                      RatingBarIndicator(
                        rating: card["score"].toDouble(),
                        itemPadding: EdgeInsets.only(top: 5),
                        itemBuilder: (context, index) => Icon(
                          Icons.star,
                          color: Blauw,
                        ),
                        itemCount: 5,
                        itemSize: 20,
                      ),
                    ],
                  ))
                ],
              ),
              Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: card["comment"].toString() != "null" ? Text(
                    card["comment"].toString(),
                    style: TextStyle(color: Zwart),
                  ): Container()),
            ],
          ),
        ));
  }
}
