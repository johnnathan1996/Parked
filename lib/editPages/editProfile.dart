import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:image_picker/image_picker.dart';
import 'package:parkly/constant.dart';
import 'package:parkly/localization/keys.dart';
import 'package:parkly/script/changeDate.dart';
import 'package:parkly/ui/button.dart';
import '../setup/globals.dart' as globals;
import 'dart:io';
import 'package:path/path.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _lastName, _name, _newUrlImage, _gender;
  DateTime birthday;
  File fileName;

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
                                              actionUploadImage(context);
                                            },
                                            child: Stack(children: <Widget>[
                                              ClipRRect(
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  width: 140,
                                                  height: 140,
                                                  color: Blauw,
                                                  child: fileName != null
                                                      ? Image.file(fileName)
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
                                                  child: Text(
                                                      translate(Keys
                                                          .Button_Changeimg),
                                                      style: TextStyle(
                                                          color: Wit))),
                                              Container(
                                                  alignment: Alignment.center,
                                                  width: 140,
                                                  height: 140,
                                                  child: fileName != null
                                                      ? Image.file(fileName)
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
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 10.0),
                                margin: EdgeInsets.only(bottom: 10.0),
                                color: Wit,
                                child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                  value: _gender == null
                                      ? snapshot.data["gender"]
                                      : _gender,
                                  icon: Icon(Icons.keyboard_arrow_down),
                                  iconSize: 24,
                                  hint: Text(translate(Keys.Inputs_Gender),
                                      style: TextStyle(
                                          color: Zwart,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 15)),
                                  style: TextStyle(color: Zwart),
                                  onChanged: (String newValue) {
                                    if (this.mounted) {
                                      setState(() {
                                        _gender = newValue;
                                      });
                                    }
                                  },
                                  items: <String>[
                                    "M",
                                    "W",
                                    "X",
                                  ].map<DropdownMenuItem<String>>(
                                      (String value) {
                                    String tekst;
                                    if (value == "M") {
                                      tekst = translate(Keys.Inputs_Man);
                                    }
                                    if (value == "W") {
                                      tekst = translate(Keys.Inputs_Woman);
                                    }
                                    if (value == "X") {
                                      tekst = translate(Keys.Inputs_Other);
                                    }
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(tekst),
                                    );
                                  }).toList(),
                                )),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: TextFormField(
                                  enabled: false,
                                  initialValue:
                                      changeDate(snapshot.data["age"].toDate()),
                                  style: TextStyle(
                                    color: Grijs,
                                  ),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    filled: true,
                                    fillColor: Wit,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: TextFormField(
                                  enabled: false,
                                  initialValue: snapshot.data["nummer"],
                                  style: TextStyle(color: Grijs),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    filled: true,
                                    fillColor: Wit,
                                  ),
                                ),
                              ),
                              ButtonComponent(
                                label: translate(Keys.Button_Update),
                                onClickAction: () {
                                  updateProfile(
                                      context,
                                      snapshot.data["voornaam"],
                                      snapshot.data["achternaam"],
                                      snapshot.data["imgUrl"],
                                      snapshot.data["gender"]);
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

  Future takePicture() async {
    PickedFile imageFromCamera =
        await ImagePicker().getImage(source: ImageSource.camera);

    if (imageFromCamera != null) {
      if (this.mounted) {
        setState(() {
          fileName = File(imageFromCamera.path);
        });
      }
    }
  }

  Future choosePicture() async {
    PickedFile imageFromLibrary =
        await ImagePicker().getImage(source: ImageSource.gallery);

    if (imageFromLibrary != null) {
      if (this.mounted) {
        setState(() {
          fileName = File(imageFromLibrary.path);
        });
      }
    }
  }

  Future uploadToStorage(BuildContext context, File image) async {
    var dialogContext;
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        dialogContext = context;
        return Container(
          width: 200,
          height: 200,
          alignment: Alignment.center,
          child: CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(Blauw)),
        );
      },
    );

    String fileName = basename(image.path);
    StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(image);
    await uploadTask.onComplete;

    var dowurl = await (await uploadTask.onComplete).ref.getDownloadURL();
    var url = dowurl.toString();
    _newUrlImage = url;
    if (dialogContext != null) {
      Navigator.of(dialogContext).pop();
    }
  }

  Future actionUploadImage(BuildContext context) async {
    await showCupertinoModalPopup(
        context: context,
        builder: (context) {
          return CupertinoActionSheet(
            cancelButton: CupertinoActionSheetAction(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(translate(Keys.Button_Cancel)),
            ),
            actions: <Widget>[
              CupertinoActionSheetAction(
                onPressed: () async {
                  await takePicture();
                  Navigator.of(context).pop();
                },
                child: Text(translate(Keys.Button_Camera)),
              ),
              CupertinoActionSheetAction(
                onPressed: () async {
                  await choosePicture();
                  Navigator.of(context).pop();
                },
                child: Text(translate(Keys.Button_Library)),
              )
            ],
          );
        });
  }

  updateProfile(BuildContext context, String firstName, String lastName,
      String url, String gender) {
    final formState = _formKey.currentState;

    if (formState.validate()) {
      formState.save();

      if (fileName != null) {
        uploadToStorage(context, fileName).whenComplete(() {
          try {
            Firestore.instance
                .collection('users')
                .document(globals.userId)
                .updateData({
              'voornaam': _name == null ? firstName : _name,
              'achternaam': _lastName == null ? lastName : _lastName,
              'gender': _gender == null ? gender : _gender,
              'imgUrl': _newUrlImage == null ? url : _newUrlImage,
            }).whenComplete(() {
              Navigator.of(context).pop();
            });
          } catch (e) {
            print(e.message);
          }
        });
      } else {
        try {
          Firestore.instance
              .collection('users')
              .document(globals.userId)
              .updateData({
            'voornaam': _name == null ? firstName : _name,
            'achternaam': _lastName == null ? lastName : _lastName,
            'gender': _gender == null ? gender : _gender,
            "imgUrl": url,
          }).whenComplete(() {
            Navigator.of(context).pop();
          });
        } catch (e) {
          print(e.message);
        }
      }
    }
  }
}
