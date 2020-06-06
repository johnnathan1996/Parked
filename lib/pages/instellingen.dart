import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:parkly/constant.dart';
import 'package:parkly/script/logout.dart';
import 'package:parkly/ui/button.dart';
import 'package:parkly/ui/title.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:parkly/localization/keys.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import '../setup/globals.dart' as globals;

class Instellingen extends StatefulWidget {
  @override
  _InstellingenState createState() => _InstellingenState();
}

class _InstellingenState extends State<Instellingen> {
  bool notif = true;
  @override
  Widget build(BuildContext context) {
    var localizationDelegate = LocalizedApp.of(context).delegate;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Wit,
          elevation: 0.0,
          title: Image.asset('assets/images/logo.png', height: 32),
        ),
        body: Container(
          decoration: BoxDecoration(
              image: new DecorationImage(
                  image: new AssetImage('assets/images/backgroundP.png'),
                  fit: BoxFit.cover)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TitleComponent(label: translate(Keys.Title_Settings)),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Card(
                    child: ListTile(
                      onTap: () {
                        showCupertinoModalPopup(
                            context: context,
                            builder: (BuildContext context) {
                              return CupertinoActionSheet(
                                title: Text(translate(Keys.Apptext_Switchlang)),
                                actions: <Widget>[
                                  CupertinoActionSheetAction(
                                    child: Text(translate(Keys.Apptext_French)),
                                    onPressed: () {
                                      setState(() {
                                        localizationDelegate
                                            .changeLocale(Locale('fr'));
                                      });

                                      Navigator.pop(context);
                                    },
                                  ),
                                  CupertinoActionSheetAction(
                                    child: Text(translate(Keys.Apptext_Dutch)),
                                    onPressed: () {
                                      setState(() {
                                        localizationDelegate
                                            .changeLocale(Locale('nl'));
                                      });

                                      Navigator.pop(context);
                                    },
                                  ),
                                  CupertinoActionSheetAction(
                                    child:
                                        Text(translate(Keys.Apptext_English)),
                                    onPressed: () {
                                      setState(() {
                                        localizationDelegate
                                            .changeLocale(Locale('en'));
                                      });

                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                                cancelButton: CupertinoActionSheetAction(
                                  child: Text(translate(Keys.Button_Cancel)),
                                  isDefaultAction: true,
                                  onPressed: () => Navigator.pop(context),
                                ),
                              );
                            });
                      },
                      leading: Icon(Icons.language, color: Zwart),
                      title: Text(translate(Keys.Apptext_Language),
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                          )),
                      trailing: Text(
                          getCurrentLanguageLocalizationKey(
                              localizationDelegate.currentLocale.languageCode),
                          style: TextStyle(color: Grijs)),
                    ),
                  )),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Card(
                    child: ListTile(
                        onTap: () {
                          setState(() {
                            notif = !notif;
                          });
                        },
                        leading: Icon(Icons.notifications, color: Zwart),
                        title: Text(translate(Keys.Apptext_Notification),
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            )),
                        trailing: Text(
                            notif
                                ? translate(Keys.Apptext_Yes)
                                : translate(Keys.Apptext_No),
                            style: TextStyle(color: Grijs))),
                  )),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Card(
                    child: ListTile(
                      onTap: () {
                        Share.share(
                                'Check the new parking app, the easiest way to park, Download now!')
                            .whenComplete(() {
                          Firestore.instance
                              .collection('users')
                              .document(globals.userId)
                              .updateData({'share': true});
                        });
                      },
                      leading: Icon(Icons.card_giftcard, color: Zwart),
                      title: Text(translate(Keys.Apptext_Invite),
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                          )),
                    ),
                  )),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Card(
                    child: ListTile(
                      onTap: () {},
                      leading: Icon(Icons.message, color: Zwart),
                      title: Text(translate(Keys.Apptext_Questions),
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                          )),
                    ),
                  )),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Card(
                    child: ListTile(
                      onTap: () async {
                        String url =
                            "https://www.privacypolicygenerator.info/live.php?token=KEgjKav0Wp5pXzcwRPQzTCZWqORMvn36";

                        if (await canLaunch(url)) {
                          await launch(url);
                        } else {
                          print('Could not launch $url');
                        }
                      },
                      leading: Icon(Icons.lock, color: Zwart),
                      title: Text(translate(Keys.Apptext_Privacy),
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                          )),
                    ),
                  )),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Card(
                    child: ListTile(
                      onTap: () async {
                        String url = Uri.encodeFull(
                            "mailto:john96@hotmail.be?subject=Help%20Parked");

                        if (await canLaunch(url)) {
                          await launch(url);
                        } else {
                          print('Could not launch $url');
                        }
                      },
                      leading: Icon(Icons.mail, color: Zwart),
                      title: Text(translate(Keys.Apptext_Contact),
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                          )),
                    ),
                  )),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ButtonComponent(
                    label: translate(Keys.Button_Logout),
                    onClickAction: () {
                      logOut(context);
                    },
                  ))
            ],
          ),
        ));
  }

  getCurrentLanguageLocalizationKey(String code) {
    switch (code) {
      case "nl":
        return translate(Keys.Apptext_Dutch);
      case "fr":
        return translate(Keys.Apptext_French);
      case "en":
        return translate(Keys.Apptext_English);
      default:
        return translate(Keys.Apptext_English);
    }
  }
}
