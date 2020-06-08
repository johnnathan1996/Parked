import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:Parked/localization/keys.dart';

getStatus(int status) {
  switch (status) {
    case 1:
      return Icon(Icons.access_time, color: Colors.orange);
    case 0:
      return Icon(Icons.close, color: Colors.red);
    case 2:
      return Icon(Icons.check, color: Colors.green);
    default:
      return Container();
  }
}

getStatusText(int status) {
  switch (status) {
    case 1:
      return translate(Keys.Apptext_Waiting);
    case 0:
      return translate(Keys.Apptext_Refuse);
    case 2:
      return translate(Keys.Apptext_Accept);
    default:
      return "";
  }
}
