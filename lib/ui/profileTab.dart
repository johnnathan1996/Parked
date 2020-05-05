import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:parkly/constant.dart';
import 'package:parkly/addPages/addPaysystem.dart';
import 'package:parkly/detailPages/detailPaysystem.dart';
import 'package:parkly/ui/button.dart';
import '../setup/globals.dart' as globals;
import 'package:flutter_translate/flutter_translate.dart';
import 'package:parkly/localization/keys.dart';

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
                      Text(translate(Keys.Apptext_Payment),
                          style: SubTitleCustom),
                      snapshot.data["paymethode"].length != 0
                          ? MediaQuery.removePadding(
                              context: context,
                              removeBottom: true,
                              removeTop: true,
                              child: ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: snapshot.data["paymethode"].length,
                                  itemBuilder: (_, index) {
                                    return ListTile(
                                      title: Text(snapshot.data["paymethode"]
                                          [index]["bankName"]),
                                      leading: Icon(
                                        Icons.credit_card,
                                        color: Zwart,
                                      ),
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => PaySystem(
                                                    payMethod: snapshot
                                                            .data["paymethode"]
                                                        [index])));
                                      },
                                    );
                                  }))
                          : Padding(
                              padding: EdgeInsets.symmetric(vertical: 15),
                              child: Text(
                                translate(Keys.Apptext_Zerogarage),
                                style: TextStyle(fontStyle: FontStyle.italic),
                              )),
                      ButtonComponent(
                          label: translate(Keys.Button_Addcard),
                          onClickAction: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddPaySystem()));
                          }),
                    ],
                  ));
                } else {
                  return Container();
                }
              })
        ]));
  }
}
