import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:parkly/constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:parkly/editPages/editProfile.dart';
import 'package:flutter/cupertino.dart';
import 'package:parkly/ui/listText.dart';
import 'package:parkly/ui/navigation.dart';
import 'package:parkly/ui/profileTab.dart';
import 'package:parkly/ui/agendaTab.dart';
import '../setup/globals.dart' as globals;
import 'package:flutter_translate/flutter_translate.dart';
import 'package:parkly/localization/keys.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:full_screen_image/full_screen_image.dart';
import 'package:simple_tooltip/simple_tooltip.dart';
import 'package:badges/badges.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  double percentage = 0;
  int result = 1;
  int percent = 0;

  bool showTooltip = false;
  bool hasNotif = false;
  bool hasConvers = false;
  bool hasGarage = false;

  //TODO: TOOLTIP BUG , IL SE FEMRE PAS

  @override
  void initState() {
    if (this.mounted) {
      checkGamification();
      checkForNotif();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            body: Container(
                decoration: BoxDecoration(
                    image: new DecorationImage(
                        image: new AssetImage('assets/images/backgroundP.png'),
                        fit: BoxFit.cover)),
                child: StreamBuilder<DocumentSnapshot>(
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
                                    ? 280
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
                                    if (this.mounted) {
                                      setState(() {
                                        showTooltip = false;
                                      });
                                    }
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                EditProfile()));
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
                                    icon: hasNotif
                                        ? Badge(
                                            elevation: 0,
                                            shape: BadgeShape.circle,
                                            borderRadius: 5,
                                            position: BadgePosition.topRight(
                                                top: -12, right: -15),
                                            padding: EdgeInsets.all(5),
                                            badgeContent: Text(
                                              '1',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            child: Text(translate(
                                                Keys.Apptext_Reservation)),
                                          )
                                        : null,
                                    text: !hasNotif
                                        ? translate(Keys.Apptext_Reservation)
                                        : null,
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
                                  child: CircularPercentIndicator(
                                    backgroundColor: LichtGrijs,
                                    header: Padding(
                                        padding: EdgeInsets.only(bottom: 10),
                                        child: SimpleTooltip(
                                            minimumOutSidePadding: 20,
                                            borderWidth: 0,
                                            arrowLength: 10,
                                            arrowBaseWidth: 20,
                                            ballonPadding: EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 5),
                                            customShadows: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.4),
                                                spreadRadius: 1,
                                                blurRadius: 5,
                                                offset: Offset(0, 2),
                                              ),
                                            ],
                                            show: showTooltip,
                                            tooltipDirection:
                                                TooltipDirection.down,
                                            child: GestureDetector(
                                              onTap: () {
                                                if (this.mounted) {
                                                  setState(() {
                                                    showTooltip = !showTooltip;
                                                  });
                                                }
                                              },
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Text(
                                                      percent == 100
                                                          ? translate(Keys
                                                              .Apptext_Completeprofile)
                                                          : percent >= 80
                                                              ? translate(Keys
                                                                  .Apptext_Alittlebit)
                                                              : translate(Keys
                                                                  .Apptext_Statusprofile),
                                                      style: TextStyle(
                                                          color: Zwart)),
                                                  Text(' $percent%',
                                                      style: TextStyle(
                                                          color: Zwart,
                                                          fontWeight:
                                                              FontWeight.w500)),
                                                  percent == 100
                                                      ? Icon(Icons.star,
                                                          color: Colors.amber,
                                                          size: 15)
                                                      : Container(),
                                                ],
                                              ),
                                            ),
                                            content: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                snapshot.data["imgUrl"] == null
                                                    ? ListTextComponent(
                                                        label: translate(Keys
                                                            .Gamification_One))
                                                    : Text(
                                                        translate(Keys
                                                            .Gamification_One),
                                                        style: TextStyle(
                                                          fontSize: 16.0,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: Grijs,
                                                          decoration:
                                                              TextDecoration
                                                                  .none,
                                                        ),
                                                      ),
                                                snapshot.data["home"] == null
                                                    ? ListTextComponent(
                                                        label: translate(Keys
                                                            .Gamification_Two))
                                                    : Text(
                                                        translate(Keys
                                                            .Gamification_Two),
                                                        style: TextStyle(
                                                          fontSize: 16.0,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: Grijs,
                                                          decoration:
                                                              TextDecoration
                                                                  .none,
                                                        ),
                                                      ),
                                                snapshot.data["job"] == null
                                                    ? ListTextComponent(
                                                        label: translate(Keys
                                                            .Gamification_Three))
                                                    : Text(
                                                        translate(Keys
                                                            .Gamification_Three),
                                                        style: TextStyle(
                                                          fontSize: 16.0,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: Grijs,
                                                          decoration:
                                                              TextDecoration
                                                                  .none,
                                                        ),
                                                      ),
                                                !hasGarage
                                                    ? ListTextComponent(
                                                        label: translate(Keys
                                                            .Gamification_Four))
                                                    : Text(
                                                        translate(Keys
                                                            .Gamification_Four),
                                                        style: TextStyle(
                                                          fontSize: 16.0,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: Grijs,
                                                          decoration:
                                                              TextDecoration
                                                                  .none,
                                                        ),
                                                      ),
                                                snapshot.data["favoriet"]
                                                            .length ==
                                                        0
                                                    ? ListTextComponent(
                                                        label: translate(Keys
                                                            .Gamification_Five))
                                                    : Text(
                                                        translate(Keys
                                                            .Gamification_Five),
                                                        style: TextStyle(
                                                          fontSize: 16.0,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: Grijs,
                                                          decoration:
                                                              TextDecoration
                                                                  .none,
                                                        ),
                                                      ),
                                                !hasConvers
                                                    ? ListTextComponent(
                                                        label: translate(Keys
                                                            .Gamification_Six))
                                                    : Text(
                                                        translate(Keys
                                                            .Gamification_Six),
                                                        style: TextStyle(
                                                          fontSize: 16.0,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: Grijs,
                                                          decoration:
                                                              TextDecoration
                                                                  .none,
                                                        ),
                                                      ),
                                                !snapshot.data["share"]
                                                    ? ListTextComponent(
                                                        label: translate(Keys
                                                            .Gamification_Seven))
                                                    : Text(
                                                        translate(Keys
                                                            .Gamification_Seven),
                                                        style: TextStyle(
                                                          fontSize: 16.0,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: Grijs,
                                                          decoration:
                                                              TextDecoration
                                                                  .none,
                                                        ),
                                                      ),
                                              ],
                                            ))),
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
                                            ? FullScreenWidget(
                                                child: Center(
                                                  child: Hero(
                                                    tag: "smallImage",
                                                    child: Image.network(
                                                      snapshot.data["imgUrl"],
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : FullScreenWidget(
                                                child: Center(
                                                  child: Hero(
                                                    tag: "smallImage",
                                                    child: Image.asset(
                                                      'assets/images/default-user-image.png',
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                      ),
                                    ),
                                    progressColor: Blauw,
                                  ),
                                ),
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
                              ProfileTab(
                                  snapshot: snapshot.data,
                                  callback: hideShowTooltip,
                                  myName: snapshot.data['voornaam']),
                              AgendaTab()
                            ]),
                          )
                        ],
                      );
                    } else {
                      return Container(
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(
                            valueColor:
                                new AlwaysStoppedAnimation<Color>(Blauw)),
                      );
                    }
                  },
                )),
            drawer: Navigation(activeProf: true)));
  }

  checkForNotif() {
    Firestore.instance
        .collection('reservaties')
        .where('eigenaar', isEqualTo: globals.userId)
        .where('status', isEqualTo: 1)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.documents.isNotEmpty) {
        if (this.mounted) {
          setState(() {
            hasNotif = true;
          });
        }
      }

      if (snapshot.documents.isEmpty) {
        if (this.mounted) {
          setState(() {
            hasNotif = false;
          });
        }
      }
    });
  }

  hideShowTooltip() {
    if (this.mounted) {
      setState(() {
        showTooltip = false;
      });
    }
  }

  void checkGamification() {
    Firestore.instance
        .collection('users')
        .document(globals.userId)
        .snapshots()
        .listen((userSnapshot) async {
      Firestore.instance
          .collection('conversation')
          .where("creator", isEqualTo: globals.userId)
          .snapshots()
          .listen((convSnapshot) {
        Firestore.instance
            .collection('reservaties')
            .where("aanvrager", isEqualTo: globals.userId)
            .snapshots()
            .listen((reservSnapshot) {
          result = 1;
          percentage = 0;
          percent = 0;
          if (reservSnapshot.documents.length != 0 ||
              userSnapshot.data["mijnGarage"].length != 0) {
            if (this.mounted) {
              setState(() {
                result += 1;
                hasGarage = true;
              });
            }
          }

          if (convSnapshot.documents.length != 0) {
            if (this.mounted) {
              setState(() {
                result += 1;
                hasConvers = true;
              });
            }
          }

          if (userSnapshot.data["imgUrl"] != null) {
            if (this.mounted) {
              setState(() {
                result += 1;
              });
            }
          }
          if (userSnapshot.data["favoriet"].length != 0) {
            if (this.mounted) {
              setState(() {
                result += 1;
              });
            }
          }

          if (userSnapshot.data["home"] != null) {
            if (this.mounted) {
              setState(() {
                result += 1;
              });
            }
          }

          if (userSnapshot.data["job"] != null) {
            if (this.mounted) {
              setState(() {
                result += 1;
              });
            }
          }

          if (userSnapshot.data["share"]) {
            if (this.mounted) {
              setState(() {
                result += 1;
              });
            }
          }

          if (this.mounted) {
            setState(() {
              percentage = result / 8; //(8 = Total de mes point)
              percent = (percentage * 100).toInt();
            });
          }
        });
      });
    });
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
