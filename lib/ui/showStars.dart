import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../constant.dart';

class ShowStars extends StatefulWidget {
  final List rating;

  ShowStars({
    @required this.rating,
  });
  @override
  _ShowStarsState createState() => _ShowStarsState(rating: rating);
}

class _ShowStarsState extends State<ShowStars> {
  final List rating;
  _ShowStarsState({Key key, this.rating});

  List score = [];

  countRating(List array) {
    double sum = 0.0;

    for (var i = 0; i < array.length; i++) {
      sum += array[i];
    }
    double ratingOnFive = sum / array.length;

    if (ratingOnFive.isNaN) {
      ratingOnFive = 0.0;
    }
    return ratingOnFive;
  }

  @override
  void initState() {
    rating.forEach((element) {
      score.add(element["score"]);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RatingBarIndicator(
      rating: countRating(score),
      itemPadding: EdgeInsets.only(top: 5),
      itemBuilder: (context, index) => Icon(
        Icons.star,
        color: Colors.yellow,
      ),
      itemCount: 5,
      itemSize: 20,
    );
  }
}
