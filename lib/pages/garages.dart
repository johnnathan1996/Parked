import 'package:flutter/material.dart';
import 'package:parkly/constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:parkly/pages/addGarage.dart';
import 'package:parkly/ui/garageCard.dart';
import 'package:parkly/ui/navigation.dart';
import 'package:parkly/ui/title.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:parkly/localization/keys.dart';
import '../setup/globals.dart' as globals;

class GaragePage extends StatefulWidget {
  @override
  _GaragePageState createState() => _GaragePageState();
}

class _GaragePageState extends State<GaragePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Zwart),
          backgroundColor: Wit,
          elevation: 0.0,
          title: Image.asset('assets/images/logo.png', height: 32),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance
              .collection('garages')
              .where('eigenaar', isEqualTo: globals.userId)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              return Scaffold(
                  floatingActionButton: FloatingActionButton(
                    heroTag: "add",
                    backgroundColor: Blauw,
                    child: Icon(Icons.add),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => AddGarage()));
                    },
                  ),
                  body: Container(
                      decoration: BoxDecoration(
                          image: new DecorationImage(
                              image: new AssetImage(
                                  'assets/images/backgroundP.png'),
                              fit: BoxFit.cover)),
                      child: Column(children: <Widget>[
                        TitleComponent(label: translate(Keys.Title_Garage)),
                        snapshot.data.documents.length != 0
                            ? Expanded(
                                child: ListView.builder(
                                itemCount: snapshot.data.documents.length,
                                itemBuilder: (_, index) {
                                  return GarageCardComponent(
                                    garage: snapshot.data.documents[index],
                                  );
                                },
                              ))
                            : Expanded(
                                child: Center(
                                    child: Text("Je hebt nog geen garage!",
                                        style: SizeParagraph))),
                      ])),
                  floatingActionButtonLocation:
                      FloatingActionButtonLocation.endFloat);
            } else {
              return Container(
                alignment: Alignment.center,
                child: CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(Blauw)),
              );
            }
          },
        ),
        drawer: Navigation(activeGar: true));
  }
}
