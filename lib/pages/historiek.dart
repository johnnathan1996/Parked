import 'package:flutter/material.dart';
import 'package:parkly/constant.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:parkly/localization/keys.dart';
import 'package:parkly/ui/navigation.dart';
import 'package:parkly/ui/title.dart';

class HistoriekPage extends StatefulWidget {
  @override
  _HistoriekPageState createState() => _HistoriekPageState();
}

class _HistoriekPageState extends State<HistoriekPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Zwart),
          backgroundColor: Wit,
          elevation: 0.0,
          title: Image.asset('assets/images/logo.png', height: 32),
        ),
        body: TitleComponent(label: translate(Keys.Title_History)),
        drawer: Navigation(activeHis: true));
  }
}
