import 'package:flutter/material.dart';
import 'package:parkly/constant.dart';

class ListTextComponent extends StatelessWidget {
  final String label;

  ListTextComponent({
    @required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(right: 10),
            width: 7.0,
            height: 7.0,
            decoration:
                new BoxDecoration(shape: BoxShape.circle, color: Blauw)),
        Text(
          label,
          style: SizeParagraph,
        ),
      ],
    );
  }
}
