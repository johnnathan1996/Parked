import 'package:flutter/material.dart';
import 'package:parkly/constant.dart';
import 'package:parkly/script/logout.dart';
import 'package:parkly/ui/button.dart';
import 'package:parkly/ui/title.dart';

class Instellingen extends StatefulWidget {
  @override
  _InstellingenState createState() => _InstellingenState();
}

class _InstellingenState extends State<Instellingen> {
  @override
  Widget build(BuildContext context) {
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
          TitleComponent(label: "Instellingen"),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Card(
                child: ListTile(
                  onTap: () {},
                  leading: Icon(Icons.language, color: Zwart),
                  title: Text("Taal",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                      )),
                  trailing: Text("Nederlands", style: TextStyle(color: Grijs)),
                ),
              )),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Card(
                child: ListTile(
                    onTap: () {},
                    leading: Icon(Icons.notifications, color: Zwart),
                    title: Text("Notificaties",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                        )),
                    trailing: Text("Ja", style: TextStyle(color: Grijs))),
              )),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Card(
                child: ListTile(
                  onTap: () {},
                  leading: Icon(Icons.card_giftcard, color: Zwart),
                  title: Text("vrienden uitnodigen",
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
                  title: Text("Vaak gestelde vragen",
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
                  leading: Icon(Icons.lock, color: Zwart),
                  title: Text("Privacybeleid",
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
                  leading: Icon(Icons.mail, color: Zwart),
                  title: Text("Contact",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                      )),
                ),
              )),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: ButtonComponent(
                label: "Log out",
                onClickAction: () {
                  logOut(context);
                },
              ))
        ],
      ),
    ));
  }
}
