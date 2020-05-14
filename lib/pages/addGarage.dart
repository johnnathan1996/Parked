import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:parkly/constant.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:parkly/ui/modal.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:parkly/ui/button.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import '../setup/globals.dart' as globals;
import 'package:geocoder/geocoder.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:parkly/localization/keys.dart';

class AddGarage extends StatefulWidget {
  @override
  _AddGarageState createState() => _AddGarageState();
}

class _AddGarageState extends State<AddGarage> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _street, _number, _city, _postcode, _desciption, _price, downloadLink;
  String _high = "Geen";

  File fileName;

  num _longitude, _latitude;

  List<String> _listChecked = [];
  List<String> _typeVoertuigen = [];

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
          margin: EdgeInsets.all(20),
          child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: imageComponent(context)),
                    Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: adresComponent()),
                    Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: priceComponent(context)),
                    Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: descComponent()),
                    Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: featuresComponent(context)),
                    Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: typesComponent(context)),
                    Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: ButtonComponent(
                            label: translate(Keys.Button_Add),
                            onClickAction: () {
                              createGarage(context);
                            })),
                  ],
                ),
              )),
        ));
  }

  Widget imageComponent(BuildContext context) {
    return DottedBorder(
        dashPattern: [7],
        color: Blauw,
        strokeWidth: 2,
        child: GestureDetector(
          onTap: () {
            actionUploadImage(context);
          },
          child: (fileName == null)
              ? Container(
                  alignment: Alignment.center,
                  height: 70,
                  color: Wit,
                  child: RichText(
                    text: TextSpan(
                      style: SizeParagraph,
                      children: [
                        WidgetSpan(
                          child: Padding(
                            padding: EdgeInsets.only(right: 5),
                            child: Icon(Icons.camera_alt),
                          ),
                        ),
                        TextSpan(text: translate(Keys.Inputs_Uploadimg)),
                      ],
                    ),
                  ))
              : ClipRect(
                  child: Align(
                    alignment: Alignment.center,
                    heightFactor: 0.5,
                    child: Image.file(fileName),
                  ),
                ),
        ));
  }

  Widget adresComponent() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
              padding: EdgeInsets.symmetric(vertical: 5),
              child:
                  Text(translate(Keys.Subtitle_Adres), style: SubTitleCustom)),
          Padding(
              padding: EdgeInsets.symmetric(vertical: 5),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Flexible(
                        child: Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: TextFormField(
                              validator: (input) {
                                if (input.isEmpty) {
                                  return translate(Keys.Errors_Isempty);
                                }
                                return null;
                              },
                              onSaved: (input) => _street = input,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  filled: true,
                                  fillColor: Wit,
                                  hintText: translate(Keys.Inputs_Street),
                                  labelStyle: TextStyle(color: Zwart)),
                            ))),
                    SizedBox(
                        width: 80,
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          validator: (input) {
                            if (input.isEmpty) {
                              return translate(Keys.Errors_Isempty);
                            }
                            return null;
                          },
                          onSaved: (input) => _number = input,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              filled: true,
                              fillColor: Wit,
                              hintText: translate(Keys.Inputs_Number),
                              labelStyle: TextStyle(color: Zwart)),
                        )),
                  ])),
          Padding(
              padding: EdgeInsets.symmetric(vertical: 5),
              child: Row(children: <Widget>[
                Expanded(
                    child: Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: TextFormField(
                          validator: (input) {
                            if (input.isEmpty) {
                              return translate(Keys.Errors_Isempty);
                            }
                            return null;
                          },
                          onSaved: (input) => _city = input,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              filled: true,
                              fillColor: Wit,
                              hintText: translate(Keys.Inputs_City),
                              labelStyle: TextStyle(color: Zwart)),
                        ))),
                Expanded(
                    child: TextFormField(
                  keyboardType: TextInputType.number,
                  validator: (input) {
                    if (input.isEmpty) {
                      return translate(Keys.Errors_Isempty);
                    }
                    return null;
                  },
                  onSaved: (input) => _postcode = input,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      filled: true,
                      fillColor: Wit,
                      hintText: translate(Keys.Inputs_Postal),
                      labelStyle: TextStyle(color: Zwart)),
                )),
              ])),
        ]);
  }

  Widget priceComponent(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
              padding: EdgeInsets.only(bottom: 5),
              child:
                  Text(translate(Keys.Subtitle_Price), style: SubTitleCustom)),
          Row(
            children: <Widget>[
              Expanded(
                child: TextFormField(
                  validator: (input) {
                    if (input.isEmpty) {
                      return "";
                    }
                    return null;
                  },
                  onSaved: (input) => _price = input,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Wit, width: 0.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Wit, width: 0.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Wit, width: 0.0),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 1.0),
                      ),
                      filled: true,
                      fillColor: Wit,
                      hintText: "5",
                      labelStyle: TextStyle(color: Zwart)),
                ),
              ),
              Expanded(
                  flex: 7,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Text("€" + translate(Keys.Apptext_Hourly)),
                  )),
            ],
          )
        ]);
  }

  Widget descComponent() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
              padding: EdgeInsets.symmetric(vertical: 5),
              child:
                  Text(translate(Keys.Subtitle_Desc), style: SubTitleCustom)),
          TextFormField(
            validator: (input) {
              if (input.isEmpty) {
                return translate(Keys.Errors_Isempty);
              }
              return null;
            },
            onSaved: (input) => _desciption = input,
            decoration: InputDecoration(
                hintText: translate(Keys.Inputs_Desc),
                border: InputBorder.none,
                filled: true,
                fillColor: Wit,
                labelStyle: TextStyle(color: Zwart)),
            maxLines: 5,
          )
        ]);
  }

  Widget featuresComponent(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(translate(Keys.Subtitle_Features), style: SubTitleCustom),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              CheckboxGroup(
                activeColor: Blauw,
                labels: <String>[
                  translate(Keys.Featuregarage_One),
                  translate(Keys.Featuregarage_Two),
                  translate(Keys.Featuregarage_Three),
                  translate(Keys.Featuregarage_Four),
                  translate(Keys.Featuregarage_Five),
                ],
                onSelected: (List<String> checked) => _listChecked = checked,
              ),
              Text(translate(Keys.Subtitle_Maxheigt),
                  style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w500,
                      color: Zwart)),
              RadioButtonGroup(
                  picked: _high,
                  orientation: GroupedButtonsOrientation.HORIZONTAL,
                  activeColor: Blauw,
                  labels: <String>[
                    translate(Keys.Featuregarage_None),
                    '1,90',
                    '2,10',
                    '2,30',
                    '2,50',
                  ],
                  onSelected: (String selected) => {
                        if (this.mounted)
                          {
                            setState(() {
                              _high = selected;
                            })
                          }
                      }),
            ],
          ),
        ]);
  }

  Widget typesComponent(BuildContext context) {
    List types = [
      {"label": translate(Keys.Apptext_Twowheelers), "icon": Icons.motorcycle},
      {"label": translate(Keys.Apptext_Little), "icon": Icons.directions_car},
      {"label": translate(Keys.Apptext_Middle), "icon": Icons.directions_car},
      {"label": translate(Keys.Apptext_Large), "icon": Icons.directions_car},
      {"label": translate(Keys.Apptext_High), "icon": Icons.airport_shuttle},
      {"label": translate(Keys.Apptext_Veryhigh), "icon": Icons.power}
    ];

    return Container(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: Text(translate(Keys.Subtitle_Typevehicules),
                style: SubTitleCustom)),
        MediaQuery.removePadding(
            context: context,
            removeBottom: true,
            removeTop: true,
            child: GridView.count(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              crossAxisCount: 3,
              children: List.generate(types.length, (index) {
                return GestureDetector(
                    onTap: () {
                      if (this.mounted) {
                        setState(() {
                          if (_typeVoertuigen.contains(types[index]["label"])) {
                            _typeVoertuigen.remove(types[index]["label"]);
                          } else {
                            _typeVoertuigen.add(types[index]["label"]);
                          }
                        });
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            width: 2,
                            color:
                                _typeVoertuigen.contains(types[index]["label"])
                                    ? Blauw
                                    : Transparant),
                        color: Wit,
                      ),
                      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                      width: 110,
                      height: 110,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(types[index]["icon"]),
                          Text(types[index]["label"])
                        ],
                      ),
                    ));
              }),
            )),
        _typeVoertuigen.contains(translate(Keys.Apptext_Veryhigh))
            ? Text("*" + translate(Keys.Apptext_Chargingstation))
            : Container()
      ],
    ));
  }

  Future calculateCoordonate(
      String straat, String nummer, String gemeente, String postcode) async {
    final query = straat + " " + nummer + ", " + gemeente + " " + postcode;
    var addresses =
        await Geocoder.local.findAddressesFromQuery(query.toString());
    var first = addresses.first;

    _longitude = first.coordinates.longitude;
    _latitude = first.coordinates.latitude;
  }

  Future takePicture() async {
    var imageFromCamera =
        await ImagePicker.pickImage(source: ImageSource.camera);

    if (imageFromCamera != null) {
      if (this.mounted) {
        setState(() {
          fileName = imageFromCamera;
        });
      }
    }
  }

  Future choosePicture() async {
    var imageFromLibrary =
        await ImagePicker.pickImage(source: ImageSource.gallery);

    if (imageFromLibrary != null) {
      if (this.mounted) {
        setState(() {
          fileName = imageFromLibrary;
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
    downloadLink = url;
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

  void createGarage(BuildContext context) async {
    final formState = _formKey.currentState;
    if (formState.validate()) {
      formState.save();

      calculateCoordonate(_street, _number, _city, _postcode).whenComplete(() {
        if (fileName != null) {
          uploadToStorage(context, fileName).whenComplete(() {
            try {
              Firestore.instance.collection('garages').add({
                'eigenaar': globals.userId,
                'garageImg': downloadLink,
                'time': new DateTime.now(),
                'street': _street + ", " + _number,
                'city': _city,
                'postcode': _postcode,
                'prijs': int.parse(_price),
                'beschrijving': _desciption,
                'maxHoogte': _high,
                'kenmerken': _listChecked,
                'types': _typeVoertuigen,
                'rating': [],
                'latitude': _latitude,
                'longitude': _longitude,
              }).then((data) {
                try {
                  Firestore.instance
                      .collection('users')
                      .document(globals.userId)
                      .updateData({
                    "mijnGarage": FieldValue.arrayUnion([data.documentID])
                  });
                } catch (e) {
                  print(e.message);
                }
              }).then((value) {
                Navigator.of(context).pop();
              });
            } catch (e) {
              print(e.message);
            }
          });
        } else {
          showDialog(
              context: context,
              builder: (_) => ModalComponent(modalTekst: translate(Keys.Modal_Noimage)),
            );
        }
      });
    }
  }
}
