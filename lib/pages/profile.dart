import 'package:flutter/material.dart';
import 'package:parkly/constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:parkly/script/chooseImage.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/cupertino.dart';
import 'package:parkly/ui/navigation.dart';
import 'package:parkly/ui/profileTab.dart';
import 'package:parkly/ui/reservationTab.dart';
import '../setup/globals.dart' as globals;
import 'package:flutter_translate/flutter_translate.dart';
import 'package:parkly/localization/keys.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

//TODO: make profile prettier for every phone

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            body: StreamBuilder<DocumentSnapshot>(
              stream: Firestore.instance
                  .collection('users')
                  .document(globals.userId)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasData) {
                  return CustomScrollView(
                    slivers: <Widget>[
                      SliverAppBar(
                        expandedHeight: 300.0,
                        backgroundColor: Wit,
                        floating: false,
                        pinned: true,
                        snap: false,
                        elevation: 0,
                        iconTheme: IconThemeData(color: Zwart),
                        title:
                            Image.asset('assets/images/logo.png', height: 32.0),
                        actions: <Widget>[
                          IconButton(icon: Icon(Icons.edit), onPressed: () {
                            //TODO: edit profile
                          })
                        ],
                        bottom: TabBar(
                          indicatorColor: Blauw,
                          labelColor: Blauw,
                          unselectedLabelColor: Zwart,
                          tabs: <Widget>[
                            Tab(
                              text: translate(Keys.Apptext_Profile),
                            ),
                            Tab(
                              text: translate(Keys.Apptext_Reservation),
                            )
                          ],
                        ),
                        flexibleSpace: FlexibleSpaceBar(
                          background: Column(children: <Widget>[
                            Padding(
                                padding:
                                    EdgeInsets.only(top: 100.0, bottom: 20.0),
                                child: CircularProfileAvatar(
                                  snapshot.data["imgUrl"] != null
                                      ? snapshot.data["imgUrl"]
                                      : 'https://firebasestorage.googleapis.com/v0/b/parkly-2f177.appspot.com/o/default-user-avatar.png?alt=media&token=9af11a8c-e2b6-4f7b-87b6-f656d705eb20',
                                  radius: 70,
                                  borderWidth: 7,
                                  borderColor: Blauw,
                                  cacheImage: true,
                                  onTap: () {
                                    ChooseImage getUrl = ChooseImage();
                                    getUrl
                                        .actionUploadImage(context)
                                        .whenComplete(() {
                                      if (getUrl.downloadLink != null) {
                                        try {
                                          Firestore.instance
                                              .collection('users')
                                              .document(globals.userId)
                                              .updateData({
                                            "imgUrl": getUrl.downloadLink
                                          });
                                        } catch (e) {
                                          print(e.message);
                                        }
                                      }
                                    });
                                  },
                                )),
                            Text(
                                snapshot.data['voornaam'] +
                                    " " +
                                    snapshot.data['achternaam'],
                                style: TitleCustom)
                          ]),
                        ),
                      ),
                      SliverFillRemaining(
                        child: TabBarView(
                            children: [
                              ProfileTab(snapshot: snapshot.data), 
                              Reservations()]),
                      )
                    ],
                  );
                } else {
                  return Container(
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(
                        valueColor: new AlwaysStoppedAnimation<Color>(Blauw)),
                  );
                }
              },
            ),
            drawer: Navigation()));
  }
}
