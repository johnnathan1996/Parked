import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:parkly/constant.dart';
import 'package:parkly/script/logout.dart';
import 'package:parkly/ui/button.dart';
import 'package:parkly/ui/title.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:parkly/localization/keys.dart';
import 'package:share/share.dart';

class Instellingen extends StatefulWidget {
  @override
  _InstellingenState createState() => _InstellingenState();
}

class _InstellingenState extends State<Instellingen> {
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
                    _onActionSheetPress(context);
                  },
                  leading: Icon(Icons.language, color: Zwart),
                  title: Text(translate(Keys.Apptext_Language),
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                      )),
                  trailing: Text(getCurrentLanguageLocalizationKey(localizationDelegate.currentLocale.languageCode), style: TextStyle(color: Grijs)),
                ),
              )),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Card(
                child: ListTile(
                    onTap: () {},
                    leading: Icon(Icons.notifications, color: Zwart),
                    title: Text(translate(Keys.Apptext_Notification),
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                        )),
                    trailing: Text(translate(Keys.Apptext_No), style: TextStyle(color: Grijs))),
              )),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Card(
                child: ListTile(
                  onTap: () {
                    Share.share('Check the new parking app, the easiest way to park, Download now!');
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
                  onTap: () {},
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
                  onTap: () {},
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

   void showDemoActionSheet({BuildContext context, Widget child}) {
    showCupertinoModalPopup<String>(
            context: context,
            builder: (BuildContext context) => child).then((String value)
    {
      changeLocale(context, value);
    });
  }

  void _onActionSheetPress(BuildContext context) {
    showDemoActionSheet(
      context: context,
      child: CupertinoActionSheet(
        title: Text(translate(Keys.Apptext_Switchlang)),
        actions: <Widget>[
          CupertinoActionSheetAction(
            child: Text(translate(Keys.Apptext_French)),
            onPressed: () => Navigator.pop(context, 'fr'),
          ),
          CupertinoActionSheetAction(
            child: Text(translate(Keys.Apptext_Dutch)),
            onPressed: () => Navigator.pop(context, 'nl'),
          ),
          CupertinoActionSheetAction(
            child: Text(translate(Keys.Apptext_English)),
            onPressed: () => Navigator.pop(context, 'en'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          child: Text(translate(Keys.Button_Cancel)),
          isDefaultAction: true,
          onPressed: () => Navigator.pop(context, null),
        ),
      ),
    );
  }

  getCurrentLanguageLocalizationKey(String code) {
    switch(code)
    {
      case "nl": return translate(Keys.Apptext_Dutch);
      case "fr": return translate(Keys.Apptext_French);
      case "en": return translate(Keys.Apptext_English);
      default: return translate(Keys.Apptext_Dutch);
    }
  }
}
