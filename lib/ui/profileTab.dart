import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:parkly/constant.dart';
import 'package:parkly/pages/addPaysystem.dart';
import 'package:parkly/pages/detailPaysystem.dart';
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

  List payMethode = [];

  getPaymethode() {
    Firestore.instance
        .collection("users")
        .document(globals.userId)
        .snapshots()
        .listen((instance) {
      setState(() {
        payMethode = [];
        for (var item in instance.data["paymethode"]) {
          payMethode.add(item);
        }
      });
    });
  }

  @override
  void initState() {
    getPaymethode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(child: betaalmiddel()),
          ],
        ));
  }

  Widget betaalmiddel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text("Betaalmethoden"),
        Expanded(
            child: ReorderableListView(
                children: [
              for (final item in payMethode)
                ListTile(
                  key: ValueKey(item.hashCode),
                  title: Text(item["bankName"]),
                  leading: Icon(
                    Icons.credit_card,
                    color: Zwart,
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PaySystem(payMethod: item)));
                  },
                )
            ],
                onReorder: (oldIndex, newIndex) {
                  setState(() {
                    if (newIndex > oldIndex) {
                      newIndex -= 1;
                    }
                    final Map item = payMethode.removeAt(oldIndex);
                    payMethode.insert(newIndex, item);
                  });
                })),
        ButtonComponent(
            label: translate(Keys.Button_Addcard),
            onClickAction: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AddPaySystem()));
            })
      ],
    );
  }
}
