import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:Parked/constant.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:Parked/ui/modal.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:Parked/ui/button.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import '../setup/globals.dart' as globals;
import 'package:geocoder/geocoder.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:Parked/localization/keys.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:mapbox_search/mapbox_search.dart';

class AddGarage extends StatefulWidget {
  @override
  _AddGarageState createState() => _AddGarageState();
}

class _AddGarageState extends State<AddGarage> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _adress, _desciption, downloadLink;
  String _high = translate(Keys.Featuregarage_None);
  String _price = "";

  List<File> fileName = [];
  List<String> fileNameUrl = [];

  num _longitude, _latitude;

  List<String> _listChecked = [];
  List<String> _typeVoertuigen = [];
  List listAdresses = [];

  TextEditingController priceController = TextEditingController();
  bool showbtn = true;
  bool valueLift = false;
  bool valueLader = false;

  var placesSearch = PlacesSearch(
    apiKey:
        'pk.eyJ1Ijoiam9obm5hdGhhbjk2IiwiYSI6ImNrM3p1M2pwcjFkYmIzZHA3ZGZ5dW1wcGIifQ.pcrBkGP2Jq3H6bcX1M0CYg',
    limit: 5,
  );

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
          margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
          child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: imageComponent(context)),
                        Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: adresComponent(context)),
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
                            child: servicesComponent()),
                        Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: ButtonComponent(
                                label: translate(Keys.Button_Add),
                                onClickAction: () {
                                  calculateCoordonateAndCreate(context);
                                })),
                      ],
                    ),
                  ],
                ),
              )),
        ));
  }

  Widget imageComponent(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 10),
          height: 130,
          child: Row(
            children: <Widget>[
              Flexible(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Stack(
                    children: <Widget>[
                      DottedBorder(
                          dashPattern: [7],
                          color: Blauw,
                          strokeWidth: 2,
                          child: GestureDetector(
                            onTap: () {
                              actionUploadImage(context, 0);
                            },
                            child: (fileName.length == 0)
                                ? Container(
                                    alignment: Alignment.center,
                                    color: Wit,
                                    child: RichText(
                                      text: TextSpan(
                                        style: SizeParagraph,
                                        children: [
                                          WidgetSpan(
                                            child: Padding(
                                              padding:
                                                  EdgeInsets.only(right: 5),
                                              child: Icon(Icons.camera_alt),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ))
                                : ClipRect(
                                    child: Align(
                                      alignment: Alignment.center,
                                      heightFactor: 1,
                                      child: Image.file(fileName[0]),
                                    ),
                                  ),
                          )),
                      fileName.asMap().containsKey(0)
                          ? Positioned(
                              right: 0,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                     fileName.removeAt(0);
                                  });
                                 
                                },
                                child: Container(
                                    width: 20,
                                    height: 20,
                                    decoration: new BoxDecoration(
                                      color: Blauw,
                                      shape: BoxShape.circle,
                                    ),
                                    alignment: Alignment.center,
                                    child: Icon(
                                      Icons.close,
                                      color: Wit,
                                      size: 14,
                                    )),
                              ),
                            )
                          : Container()
                    ],
                  ),
                ),
              ),
              Flexible(
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: Stack(
                          children: <Widget>[
                            DottedBorder(
                                dashPattern: [7],
                                color: Blauw,
                                strokeWidth: 2,
                                child: GestureDetector(
                                  onTap: () {
                                    actionUploadImage(context, 1);
                                  },
                                  child: (fileName.length <= 1)
                                      ? Container(
                                          alignment: Alignment.center,
                                          color: Wit,
                                          child: RichText(
                                            text: TextSpan(
                                              style: SizeParagraph,
                                              children: [
                                                WidgetSpan(
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.only(right: 5),
                                                    child: Icon(Icons.camera_alt),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ))
                                      : ClipRect(
                                          child: Align(
                                            alignment: Alignment.center,
                                            heightFactor: 1,
                                            child: Image.file(fileName[1]),
                                          ),
                                        ),
                                )),
                          fileName.asMap().containsKey(1)
                          ? Positioned(
                              right: 0,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                     fileName.removeAt(1);
                                  });
                                 
                                },
                                child: Container(
                                    width: 20,
                                    height: 20,
                                    decoration: new BoxDecoration(
                                      color: Blauw,
                                      shape: BoxShape.circle,
                                    ),
                                    alignment: Alignment.center,
                                    child: Icon(
                                      Icons.close,
                                      color: Wit,
                                      size: 14,
                                    )),
                              ),
                            )
                          : Container()
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Stack(
                          children: <Widget>[
                            DottedBorder(
                                dashPattern: [7],
                                color: Blauw,
                                strokeWidth: 2,
                                child: GestureDetector(
                                  onTap: () {
                                    actionUploadImage(context, 2);
                                  },
                                  child: (fileName.length <= 2)
                                      ? Container(
                                          alignment: Alignment.center,
                                          color: Wit,
                                          child: RichText(
                                            text: TextSpan(
                                              style: SizeParagraph,
                                              children: [
                                                WidgetSpan(
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.only(right: 5),
                                                    child: Icon(Icons.camera_alt),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ))
                                      : ClipRect(
                                          child: Align(
                                            alignment: Alignment.center,
                                            heightFactor: 1,
                                            child: Image.file(fileName[2]),
                                          ),
                                        ),
                                )),
                          fileName.asMap().containsKey(2)
                          ? Positioned(
                              right: 0,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                     fileName.removeAt(2);
                                  });
                                 
                                },
                                child: Container(
                                    width: 20,
                                    height: 20,
                                    decoration: new BoxDecoration(
                                      color: Blauw,
                                      shape: BoxShape.circle,
                                    ),
                                    alignment: Alignment.center,
                                    child: Icon(
                                      Icons.close,
                                      color: Wit,
                                      size: 14,
                                    )),
                              ),
                            )
                          : Container()
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget adresComponent(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
              padding: EdgeInsets.symmetric(vertical: 5),
              child:
                  Text(translate(Keys.Subtitle_Adres), style: SubTitleCustom)),
          Padding(
              padding: EdgeInsets.symmetric(vertical: 5),
              child: Column(
                children: <Widget>[
                  _adress == null
                      ? TextFormField(
                          onChanged: (input) {
                            if (input.isEmpty || input == "" || input == null) {
                              if (this.mounted) {
                                setState(() {
                                  listAdresses = [];
                                });
                              }
                            } else {
                              getPlaces(input);
                            }
                          },
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              filled: true,
                              fillColor: Wit,
                              hintText: translate(Keys.Subtitle_Adres),
                              labelStyle: TextStyle(color: Zwart)),
                        )
                      : Container(),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: listAdresses.length,
                      itemBuilder: (_, index) {
                        return Card(
                          elevation: 0,
                          margin: EdgeInsets.zero,
                          color: Wit,
                          child: ListTile(
                            onTap: () {
                              _adress = listAdresses[index].placeName;
                              if (this.mounted) {
                                setState(() {
                                  listAdresses = [];
                                });
                              }
                            },
                            title: Text(listAdresses[index].placeName),
                          ),
                        );
                      },
                    ),
                  )
                ],
              )),
          _adress != null
              ? Row(
                  children: <Widget>[
                    Expanded(child: Text(_adress)),
                    IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          if (this.mounted) {
                            setState(() {
                              _adress = null;
                              listAdresses = [];
                            });
                          }
                        })
                  ],
                )
              : Container()
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
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextFormField(
                        validator: (input) {
                          if (input.isEmpty) {
                            return "";
                          }
                          return null;
                        },
                        controller: priceController,
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
                              borderSide:
                                  BorderSide(color: Colors.red, width: 1.0),
                            ),
                            filled: true,
                            fillColor: Wit,
                            hintText: translate(Keys.Subtitle_Price),
                            labelStyle: TextStyle(color: Zwart)),
                      ),
                    ),
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Text("€" + translate(Keys.Apptext_Hourly)),
                    )),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: showbtn
                    ? FlatButton(
                        onPressed: () {
                          searchPricNearby(context);
                        },
                        child: Text(translate(Keys.Button_Averageprice),
                            style: TextStyle(color: Blauw)))
                    : Text(translate(Keys.Apptext_Avaragekm),
                        style: TextStyle(
                            color: Zwart.withOpacity(0.7),
                            fontStyle: FontStyle.italic)),
              ),
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
            textInputAction: TextInputAction.done,
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
      ],
    ));
  }

  Widget servicesComponent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(translate(Keys.Subtitle_Services), style: SubTitleCustom),
        CheckboxListTile(
          value: valueLift,
          onChanged: (value) {
            if (this.mounted) {
              setState(() {
                valueLift = value;
              });
            }
          },
          title: new Text(translate(Keys.Apptext_Offerlift)),
          controlAffinity: ListTileControlAffinity.trailing,
          subtitle: new Text('5€'),
          activeColor: Blauw,
        ),
        _typeVoertuigen.contains(translate(Keys.Apptext_Veryhigh))
            ? CheckboxListTile(
                value: valueLader,
                onChanged: (value) {
                  if (this.mounted) {
                    setState(() {
                      valueLader = value;
                    });
                  }
                },
                title: new Text(translate(Keys.Apptext_Electricalterminal)),
                controlAffinity: ListTileControlAffinity.trailing,
                subtitle: new Text('10€'),
                activeColor: Blauw,
              )
            : Container(),
        valueLader
            ? Text("*" + translate(Keys.Apptext_Chargingstation))
            : Container()
      ],
    );
  }

  Future takePicture(int index) async {
    PickedFile imageFromCamera =
        await ImagePicker().getImage(source: ImageSource.camera);

    if (imageFromCamera != null) {
      if (this.mounted) {
        setState(() {
          if (fileName.asMap().containsKey(index)) {
            fileName[index] = File(imageFromCamera.path);
          } else {
            fileName.add(File(imageFromCamera.path));
          }
        });
      }
    }
  }

  Future choosePicture(int index) async {
    PickedFile imageFromLibrary =
        await ImagePicker().getImage(source: ImageSource.gallery);

    if (imageFromLibrary != null) {
      if (this.mounted) {
        setState(() {
          if (fileName.asMap().containsKey(index)) {
            fileName[index] = File(imageFromLibrary.path);
          } else {
            fileName.add(File(imageFromLibrary.path));
          }
        });
      }
    }
  }

  Future uploadToStorage(BuildContext context, List<File> image) async {
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
              valueColor: new AlwaysStoppedAnimation(Blauw)),
        );
      },
    );

    Future.forEach(image, (element) async {
      String fileName = basename(element.path);
      StorageReference firebaseStorageRef =
          FirebaseStorage.instance.ref().child(fileName);
      StorageUploadTask uploadTask = firebaseStorageRef.putFile(element);
      await uploadTask.onComplete;

      var dowurl = await (await uploadTask.onComplete).ref.getDownloadURL();
      var url = dowurl.toString();
      fileNameUrl.add(url);
    }).whenComplete(() {
      if (dialogContext != null) {
        Navigator.of(dialogContext).pop();
      }

      Geoflutterfire geo = Geoflutterfire();
      GeoFirePoint center =
          geo.point(latitude: _latitude, longitude: _longitude);

      try {
        Firestore.instance.collection('garages').add({
          'eigenaar': globals.userId,
          'garageImg': fileNameUrl,
          'time': new DateTime.now(),
          'adress': _adress,
          'prijs': int.parse(_price),
          'beschrijving': _desciption.capitalize().trim(),
          'maxHoogte': _high,
          'kenmerken': _listChecked,
          'types': _typeVoertuigen,
          'rating': [],
          'location': center.data,
          'lift': valueLift,
          'lader': valueLader,
          'available': true,
          'verified': false
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
  }

  Future actionUploadImage(BuildContext context, int index) async {
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
                  await takePicture(index);
                  Navigator.of(context).pop();
                },
                child: Text(translate(Keys.Button_Camera)),
              ),
              CupertinoActionSheetAction(
                onPressed: () async {
                  await choosePicture(index);
                  Navigator.of(context).pop();
                },
                child: Text(translate(Keys.Button_Library)),
              )
            ],
          );
        });
  }

  getPlaces(String searchQuery) {
    Future<List<MapBoxPlace>> places = placesSearch.getPlaces(searchQuery);
    places.then((value) {
      if (this.mounted) {
        setState(() {
          listAdresses = value;
        });
      }
    });
  }

  void searchPricNearby(BuildContext context) async {
    Geoflutterfire geo = Geoflutterfire();

    if (_adress != null) {
      try {
        var addresses = await Geocoder.local.findAddressesFromQuery(_adress);
        var first = addresses.first;

        GeoFirePoint center = geo.point(
            latitude: first.coordinates.latitude,
            longitude: first.coordinates.longitude);

        var collectionReference = Firestore.instance.collection("garages");

        double radius = 30;
        String field = 'location';

        Stream<List<DocumentSnapshot>> stream = geo
            .collection(collectionRef: collectionReference)
            .within(center: center, radius: radius, field: field);

        stream.listen((List<DocumentSnapshot> documentList) {
          if (documentList.length != 0) {
            double gemiddeldePrijs = 0;
            documentList.forEach((element) {
              gemiddeldePrijs += element.data["prijs"];
            });
            if (this.mounted) {
              setState(() {
                priceController.text =
                    (gemiddeldePrijs / documentList.length).round().toString();
                showbtn = false;
              });
            }
          } else {
            showDialog(
              context: context,
              builder: (_) =>
                  ModalComponent(modalTekst: translate(Keys.Modal_Nogarageray)),
            );
          }
        });
      } catch (e) {
        print(e);
        showDialog(
          context: context,
          builder: (_) =>
              ModalComponent(modalTekst: translate(Keys.Modal_Invalidaddress)),
        );
      }
    } else {
      showDialog(
        context: context,
        builder: (_) =>
            ModalComponent(modalTekst: translate(Keys.Modal_Writeaddress)),
      );
    }
  }

  void calculateCoordonateAndCreate(BuildContext context) async {
    final formState = _formKey.currentState;
    if (formState.validate()) {
      formState.save();

      if (_adress != null) {
        if (int.parse(_price) > 0 && int.parse(_price) < 1000) {
          try {
            var addresses =
                await Geocoder.local.findAddressesFromQuery(_adress);
            var first = addresses.first;

            _longitude = first.coordinates.longitude;
            _latitude = first.coordinates.latitude;

            if (fileName[0] != null) {
              await uploadToStorage(context, fileName);
            } else {
              showDialog(
                context: context,
                builder: (_) =>
                    ModalComponent(modalTekst: translate(Keys.Modal_Noimage)),
              );
            }
          } catch (e) {
            print(e);
            showDialog(
              context: context,
              builder: (_) => ModalComponent(
                  modalTekst: translate(Keys.Modal_Invalidaddress)),
            );
          }
        } else {
          showDialog(
            context: context,
            builder: (_) =>
                ModalComponent(modalTekst: translate(Keys.Modal_Badprice)),
          );
        }
      } else {
        showDialog(
          context: context,
          builder: (_) =>
              ModalComponent(modalTekst: translate(Keys.Modal_Writeaddress)),
        );
      }
    }
  }
}
