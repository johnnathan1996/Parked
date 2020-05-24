import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:parkly/constant.dart';
import '../setup/globals.dart' as globals;

class ProfileTab extends StatefulWidget {
  final DocumentSnapshot snapshot;

  ProfileTab({
    @required this.snapshot,
  });
  @override
  _ProfileTabState createState() => _ProfileTabState(snapshot: snapshot);
}

class _ProfileTabState extends State<ProfileTab> {
  DocumentSnapshot snapshot;
  _ProfileTabState({Key key, this.snapshot});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(20),
        child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          StreamBuilder<DocumentSnapshot>(
              stream: Firestore.instance
                  .collection('users')
                  .document(globals.userId)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasData) {
                  return Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.only(bottom: 20),
                          child: placesComponent()),
                    ],
                  ));
                } else {
                  return Container();
                }
              })
        ]));
  }

  placesComponent() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
              padding: EdgeInsets.symmetric(vertical: 5),
              child: Text("places", style: SubTitleCustom)),
          MediaQuery.removePadding(
              context: context,
              removeBottom: true,
              removeTop: true,
              child: GridView.count(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  children: [
                    GestureDetector(
                      onTap: (){
                        //TODO: aller sur carte et montrer les garage pres de la maison
                        print("object");
                      },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Wit),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.home),
                            Text("Ajouter un domicile"),//TODO: ajouter adresse
                          ],
                        ))), 
                    GestureDetector(
                      onTap: (){
                        //TODO: aller sur carte et montrer les garage pres de la travaille
                        print("object");
                      },
                      child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Wit),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.business),
                              Text("Ajouter un travaille"),//TODO: ajouter adresse
                            ],
                          )), 
                    ),
                  ]))
        ]);
  }
}
