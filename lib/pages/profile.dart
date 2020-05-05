import 'package:flutter/material.dart';
import 'package:parkly/constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:parkly/script/chooseImage.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/cupertino.dart';
import 'package:parkly/ui/navigation.dart';
import 'package:parkly/ui/profileTab.dart';
import 'package:parkly/ui/agendaTab.dart';
import '../setup/globals.dart' as globals;
import 'package:flutter_translate/flutter_translate.dart';
import 'package:parkly/localization/keys.dart';
import 'package:auto_size_text/auto_size_text.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

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
                        expandedHeight:
                            MediaQuery.of(context).size.height * 0.30 < 250
                                ? 250
                                : MediaQuery.of(context).size.height * 0.30,
                        backgroundColor: Wit,
                        floating: false,
                        pinned: true,
                        snap: false,
                        elevation: 0,
                        iconTheme: IconThemeData(color: Zwart),
                        actions: <Widget>[
                          IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                //TODO: edit profile
                              })
                        ],
                        bottom: DecoratedTabBar(
                          decoration: BoxDecoration(
                              color: Wit,
                              border: Border(
                                  bottom: BorderSide(
                                color: Wit,
                                width: 2.0,
                              ))),
                          tabBar: TabBar(
                            indicatorColor: Blauw,
                            labelColor: Blauw,
                            unselectedLabelColor: Zwart,
                            labelPadding: EdgeInsets.zero,
                            tabs: <Widget>[
                              Tab(
                                text: translate(Keys.Apptext_Profile),
                              ),
                              Tab(
                                text: translate(Keys.Apptext_Reservation),
                              )
                            ],
                          ),
                        ),
                        flexibleSpace: FlexibleSpaceBar(
                          background: Column(children: <Widget>[
                            Padding(
                                padding: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height *
                                        0.09,
                                    bottom: 10.0),
                                child: CircularProfileAvatar(
                                  snapshot.data["imgUrl"] != null
                                      ? snapshot.data["imgUrl"]
                                      : 'https://firebasestorage.googleapis.com/v0/b/parkly-2f177.appspot.com/o/default-user-avatar.png?alt=media&token=9af11a8c-e2b6-4f7b-87b6-f656d705eb20',
                                  radius: 60,
                                  borderWidth: 3,
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
                            Padding(
                                padding: EdgeInsets.symmetric(horizontal: 40),
                                child: AutoSizeText(
                                  snapshot.data['voornaam'] +
                                      " " +
                                      snapshot.data['achternaam'],
                                  style: TitleCustom,
                                  maxLines: 1,
                                ))
                          ]),
                        ),
                      ),
                      SliverFillRemaining(
                        child: TabBarView(children: [
                          ProfileTab(snapshot: snapshot.data),
                          AgendaTab()
                        ]),
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

class DecoratedTabBar extends StatelessWidget implements PreferredSizeWidget {
  DecoratedTabBar({@required this.tabBar, @required this.decoration});

  final TabBar tabBar;
  final BoxDecoration decoration;

  @override
  Size get preferredSize => tabBar.preferredSize;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(child: Container(decoration: decoration)),
        tabBar,
      ],
    );
  }
}
