import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:parkly/constant.dart';
import 'package:parkly/pages/addHome.dart';
import 'package:parkly/pages/addJob.dart';
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
                          child: placesComponent(snapshot.data)),
                    ],
                  ));
                } else {
                  return Container();
                }
              })
        ]));
  }

  placesComponent(userData) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
        Widget>[
      Padding(
          padding: EdgeInsets.symmetric(vertical: 5),
          child: Text("Emplacement favoris", style: SubTitleCustom)), //TODO: trad
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
                    onTap: userData["home"] == null
                        ? () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddHome()));
                          }
                        : () {
                            //TODO: Go to carte
                            print("go to carte");
                          },
                    child: Stack(
                      children: <Widget>[
                        Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Wit),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(Icons.home),
                                userData["home"] == null
                                    ? Text("Ajouter un domicile") //TODO: trad
                                    : Text(
                                        userData["home"]["adress"],
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                      ),
                              ],
                            )),
                        Align(
                            alignment: Alignment.topRight,
                            child: userData["home"] == null
                                ? IconButton(
                                    icon: Icon(
                                      Icons.add_circle,
                                      color: Blauw,
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => AddHome()));
                                    })
                                : IconButton(
                                    icon: Icon(Icons.more_vert),
                                    onPressed: () {
                                      //TODO: edit or delete
                                      print("more");
                                    }))
                      ],
                    )),
                GestureDetector(
                  onTap: userData["job"] == null
                      ? () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddJob()));
                        }
                      : () {
                          //TODO: Go to carte
                          print("Go to carte");
                        },
                  child: Stack(
                    children: <Widget>[
                      Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Wit),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.business),
                              userData["job"] == null
                                  ? Text("Ajouter un travaille") //TODO: trad
                                  : Text(
                                      userData["job"]["adress"],
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                    ),
                            ],
                          )),
                      Align(
                          alignment: Alignment.topRight,
                          child: userData["job"] == null
                              ? IconButton(
                                  icon: Icon(
                                    Icons.add_circle,
                                    color: Blauw,
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => AddJob()));
                                  })
                              : IconButton(
                                  icon: Icon(Icons.more_vert),
                                  onPressed: () {
                                    //TODO: edit or delete
                                    print("more");
                                  }))
                    ],
                  ),
                ),
              ]))
    ]);
  }
}
