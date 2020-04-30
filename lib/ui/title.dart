import 'package:flutter/material.dart';
import 'package:parkly/constant.dart';

class TitleComponent extends StatelessWidget {
  final String label;

  TitleComponent({
    @required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 20, bottom: 10, left: 10, right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              label,
              style: TitleCustom,
            ),
            Container(
              child: Align(
                alignment: Alignment.topLeft,
                child: Container(width: 50.0, height: 3.0, color: Blauw),
              ),
            )
          ],
        ));
  }
}
