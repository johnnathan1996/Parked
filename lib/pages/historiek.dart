import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:parkly/constant.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:parkly/localization/keys.dart';
import 'package:parkly/script/changeDate.dart';
import 'package:parkly/script/getStatus.dart';
import 'package:parkly/ui/navigation.dart';
import 'package:parkly/ui/title.dart';
import '../setup/globals.dart' as globals;

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
        body: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: TitleComponent(label: translate(Keys.Title_History)),
            ),
            StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance
                    .collection('reservaties')
                    .where("aanvrager", isEqualTo: globals.userId)
                    .where("isDatePassed", isEqualTo: true)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    return snapshot.data.documents.length != 0
                        ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: snapshot.data.documents.length,
                                itemBuilder: (_, index) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: <Widget>[
                                      Text(
                                        changeDate(snapshot
                                            .data.documents[index].data["end"]
                                            .toDate()),
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Card(
                                          elevation: 0,
                                          child: StreamBuilder<
                                                  DocumentSnapshot>(
                                              stream: Firestore.instance
                                                  .collection('garages')
                                                  .document(snapshot
                                                      .data
                                                      .documents[index]
                                                      .data['garageId'])
                                                  .snapshots(),
                                              builder: (BuildContext context,
                                                  AsyncSnapshot<
                                                          DocumentSnapshot>
                                                      snapshotten) {
                                                if (snapshotten.hasData) {
                                                  return ListTile(
                                                      onTap: () {},
                                                      leading: Image.network(snapshotten
                                                          .data['garageImg']),
                                                      title: Text(changeDate(snapshot
                                                              .data
                                                              .documents[index]
                                                              .data["begin"]
                                                              .toDate()) +
                                                          " - " +
                                                          changeDate(snapshot
                                                              .data
                                                              .documents[index]
                                                              .data["end"]
                                                              .toDate())),
                                                      subtitle: Text(getStatusText(snapshot
                                                          .data
                                                          .documents[index]
                                                          .data["status"])),
                                                      trailing: Icon(Icons.close));
                                                } else {
                                                  return Container();
                                                }
                                              })),
                                    ],
                                  );
                                }),
                          )
                        : Expanded(
                            child: Center(
                                child: Text(
                                    translate(Keys.Apptext_Zerohistorical),
                                    style: SizeParagraph)));
                  } else {
                    return Container(
                      width: 200,
                      height: 200,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                          valueColor: new AlwaysStoppedAnimation(Blauw)),
                    );
                  }
                })
          ],
        ),
        drawer: Navigation(activeHis: true));
  }
}
