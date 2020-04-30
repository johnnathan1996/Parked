import 'package:flutter/material.dart';
import 'package:parkly/constant.dart';

class DotComponent extends StatelessWidget {
  final int number;

  DotComponent({
    @required this.number,
  });

  @override
  Widget build(BuildContext context) {
    return ClipOval(
        child: Container(
      color: Blauw,
      width: 20,
      height: 20,
      alignment: Alignment.center,
      child: Text(number.toString(), style: TextStyle(color: Wit)),
    ));
  }
}
