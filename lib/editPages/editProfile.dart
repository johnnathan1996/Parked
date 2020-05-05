import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:parkly/constant.dart';
import 'package:parkly/localization/keys.dart';
import 'package:parkly/script/chooseImage.dart';
import 'package:parkly/ui/button.dart';
import '../setup/globals.dart' as globals;

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  String _lastName, _name, _newUrlImage, _gender;
  DateTime birthday;

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Zwart),
          backgroundColor: Wit,
          elevation: 0.0,
          title: Image.asset('assets/images/logo.png', height: 32),
        ),
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
                    return Padding(
                        padding: const EdgeInsets.all(20),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              TextFormField(
                                enabled: false,
                                initialValue: snapshot.data["email"],
                                style: TextStyle(color: Grijs),
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    filled: true,
                                    fillColor: Wit,
                                    ),
                              ),
                              Divider(),
                              IntrinsicHeight(
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Row(
                                    children: <Widget>[
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10),
                                        child: GestureDetector(
                                            onTap: () {
                                              ChooseImage getUrl =
                                                  ChooseImage();
                                              getUrl
                                                  .actionUploadImage(context)
                                                  .whenComplete(() {
                                                if (getUrl.downloadLink !=
                                                    null) {
                                                  _newUrlImage =
                                                      getUrl.downloadLink;
                                                }
                                              });
                                            },
                                            child: Stack(children: <Widget>[
                                              ClipRRect(
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  width: 140,
                                                  height: 140,
                                                  color: Blauw,
                                                  child: _newUrlImage != null
                                                      ? Image.network(
                                                          _newUrlImage)
                                                      : snapshot.data[
                                                                  "imgUrl"] !=
                                                              null
                                                          ? Image.network(
                                                              snapshot.data[
                                                                  "imgUrl"])
                                                          : Image.asset(
                                                              'assets/images/default-user-image.png'),
                                                ),
                                              ),
                                              Opacity(
                                                  opacity: 0.5,
                                                  child: Container(
                                                      alignment:
                                                          Alignment.center,
                                                      width: 140,
                                                      height: 140,
                                                      color: Grijs)),
                                              Container(
                                                  alignment: Alignment.center,
                                                  width: 140,
                                                  height: 140,
                                                  child: Text("Change image",
                                                      style: TextStyle(
                                                          color: Wit)))
                                            ])),
                                      ),
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: <Widget>[
                                            TextFormField(
                                              initialValue:
                                                  snapshot.data["voornaam"],
                                              validator: (input) {
                                                if (input.isEmpty) {
                                                  return '';
                                                }
                                                return null;
                                              },
                                              onSaved: (input) => _name = input,
                                              decoration: InputDecoration(
                                                  labelText: translate(Keys.Inputs_Firstname),
                                                  errorStyle:
                                                      TextStyle(height: 0),
                                                  border: InputBorder.none,
                                                  errorBorder:
                                                      OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                                  color: Colors
                                                                      .red,
                                                                  width: 1.0)),
                                                  filled: true,
                                                  fillColor: Wit,
                                                  labelStyle:
                                                      TextStyle(color: Zwart)),
                                            ),
                                            TextFormField(
                                              initialValue:
                                                  snapshot.data["achternaam"],
                                              validator: (input) {
                                                if (input.isEmpty) {
                                                  return '';
                                                }
                                                return null;
                                              },
                                              onSaved: (input) =>
                                                  _lastName = input,
                                              decoration: InputDecoration(
                                                  labelText: translate(
                                                      Keys.Inputs_Lastname),
                                                  errorStyle:
                                                      TextStyle(height: 0),
                                                  border: InputBorder.none,
                                                  errorBorder:
                                                      OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                                  color: Colors
                                                                      .red,
                                                                  width: 1.0)),
                                                  filled: true,
                                                  fillColor: Wit,
                                                  labelStyle:
                                                      TextStyle(color: Zwart)),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              ButtonComponent(label: translate(Keys.Button_Update), onClickAction: (){
                                print("Update");
                              },)
                            ],
                          ),
                        ));
                  } else {
                    return Container(
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                          valueColor: new AlwaysStoppedAnimation<Color>(Blauw)),
                    );
                  }
                })));
  }

  updateProfile() {
    try {
      Firestore.instance
          .collection('users')
          .document(globals.userId)
          .updateData({
        'voornaam': _name,
        'achternaam': _lastName,
        "imgUrl": _newUrlImage,
        'gender': _gender,
        'age': birthday,
      });
    } catch (e) {
      print(e.message);
    }
  }
}
