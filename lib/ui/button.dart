import 'package:flutter/material.dart';
import 'package:parkly/constant.dart';

class ButtonComponent extends StatelessWidget {
  final String label;
  final Null Function() onClickAction; 

  ButtonComponent({
    @required this.label,
    this.onClickAction,
  });

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: onClickAction,
      child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0),
          child: Text(label, style: TextStyle(color: Colors.white))),
      color: Blauw,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    );
  }
}
