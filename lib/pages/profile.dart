import 'package:flutter/material.dart';
import 'package:parkly/constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:parkly/script/chooseImage.dart';
import 'package:flutter/cupertino.dart';
import 'package:parkly/ui/navigation.dart';
import 'package:parkly/ui/profileTab.dart';
import 'package:parkly/ui/agendaTab.dart';
import '../setup/globals.dart' as globals;
import 'package:flutter_translate/flutter_translate.dart';
import 'package:parkly/localization/keys.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:percent_indicator/percent_indicator.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  double percentage = 0.70;

  int percent;

  @override
  void initState() {
    setState(() {
      percent = (percentage * 100).toInt();
    });
    super.initState();
  }

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
                                        0.08,
                                    bottom: 10.0),
                                child: GestureDetector(
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
                                  child: CircularPercentIndicator(
                                    backgroundColor: LichtGrijs,
                                    header: Padding(
                                        padding: EdgeInsets.only(bottom: 10),
                                        child: Text(
                                            percent == 100
                                                ? "Profile complet!"
                                                : percent > 80
                                                    ? 'encore un peu! $percent%'
                                                    : 'Votre profile est complet à $percent%',
                                            style: TextStyle(color: Grijs))),
                                    radius: 120.0,
                                    lineWidth: 5.0,
                                    animation: true,
                                    animationDuration: 600,
                                    percent: percentage > 1 ? 1 : percentage,
                                    center: ClipOval(
                                      child: Container(
                                        height: 110,
                                        width: 110,
                                        child: snapshot.data["imgUrl"] != null
                                            ? Image.network(
                                                snapshot.data["imgUrl"],
                                                fit: BoxFit.fill)
                                            : Image.asset(
                                                'assets/images/default-user-image.png'),
                                      ),
                                    ),
                                    progressColor: Blauw,
                                  ),
                                )),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 40),
                              child: AutoSizeText(
                                snapshot.data['voornaam'],
                                style: TitleCustom,
                                maxLines: 1,
                              ),
                            )
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
