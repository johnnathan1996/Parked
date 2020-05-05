import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:parkly/constant.dart';
import 'package:parkly/localization/keys.dart';
import 'package:parkly/script/chooseImage.dart';
import 'package:parkly/ui/button.dart';
import '../setup/globals.dart' as globals;

//TODO: completer page

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _lastName, _name, _newUrlImage;
  DateTime birthday;

  @override
  Widget build(BuildContext context) {
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
                    return Form(
                        key: _formKey,
                        child: Padding(
                          padding: const EdgeInsets.all(20),
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
                                                  setState(() {
                                                    _newUrlImage =
                                                        getUrl.downloadLink;
                                                  });
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
                                                          color: Wit))),
                                              Container(
                                                  alignment: Alignment.center,
                                                  width: 140,
                                                  height: 140,
                                                  child: _newUrlImage != null
                                                      ? Image.network(
                                                          _newUrlImage)
                                                      : Container())
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
                                                  labelText: translate(
                                                      Keys.Inputs_Firstname),
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
                              ButtonComponent(
                                label: translate(Keys.Button_Update),
                                onClickAction: () {
                                  updateProfile(
                                      snapshot.data["voornaam"],
                                      snapshot.data["achternaam"],
                                      snapshot.data["imgUrl"]);
                                },
                              )
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

  updateProfile(String firstName, String lastName, String url) {
    final formState = _formKey.currentState;
    if (formState.validate()) {
      formState.save();

      try {
        Firestore.instance
            .collection('users')
            .document(globals.userId)
            .updateData({
          'voornaam': _name == null ? firstName : _name,
          'achternaam': _lastName == null ? lastName : _lastName,
          "imgUrl": _newUrlImage == null ? url : _newUrlImage,
        }).whenComplete(() {
          Navigator.of(context).pop();
        });
      } catch (e) {
        print(e.message);
      }
    }
  }
}
