import 'package:flutter/material.dart';
import 'package:parkly/constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:parkly/editPages/editProfile.dart';
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
                                  child: CircularPercentIndicator(
                                    backgroundColor: LichtGrijs,
                                    header: Padding(
                                        padding: EdgeInsets.only(bottom: 10),
                                        child: Text(
                                            //TODO: POURCENTAGE PROFILE
                                            /*
                                          CHANGER DE PHOTO DE PROFIL
                                          RAJOUTER UNE MAISON
                                          RAJOUTER ADRESSE TRAVAIL/ETABLISSEMENT SCOLAIRE
                                          METTRE  UN GARAGE EN LIGNE OUBIEN LOUER UN GARAGE 
                                          METTRE UN GARAGE EN FAVORIS
                                          ENVOYER UN MESSAGE -> CHECK CONEVRSATIONS.LENGTH IS NOT NULL
                                          PARTAGER L'APP AVEC DES AMIS, TRUE DNS DATABASE?
                                          */
                                            percent == 100
                                                ? translate(Keys
                                                    .Apptext_Completeprofile)
                                                : percent > 80
                                                    ? translate(Keys
                                                            .Apptext_Alittlebit) +
                                                        ' $percent%'
                                                    : translate(Keys
                                                            .Apptext_Statusprofile) +
                                                        ' $percent%',
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
                                            //TODO: ONCLICK OPEN IMAGE EN GRAND!
                                            ? Image.network(
                                                snapshot.data["imgUrl"],
                                                fit: BoxFit.fill)
                                            : Image.asset(
                                                'assets/images/default-user-image.png'),
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
                            valueColor:
                                new AlwaysStoppedAnimation<Color>(Blauw)),
                      );
                    }
                  },
                )),
            drawer: Navigation(activeProf: true)));
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
