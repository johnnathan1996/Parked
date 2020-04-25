import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:parkly/constant.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:parkly/script/chooseImage.dart';
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
  double _price = 10;
  String _titel, _street, _number, _city, _postcode, _desciption, _imageUrl;
  String _high = "Geen";

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
                        child: titelComponent()),
                    Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: imageComponent()),
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
                        child: typesComponent()),
                    Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: ButtonComponent(
                            label: translate(Keys.Button_Add),
                            onClickAction: () {
                              createGarage();
                            })),
                  ],
                ),
              )),
        ));
  }

  Widget titelComponent() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            validator: (input) {
              if (input.isEmpty) {
                return "ontbreekt";
              }
              return null;
            },
            onSaved: (input) => _titel = input,
            decoration: InputDecoration(
                hintText: translate(Keys.Inputs_Titel), labelStyle: TextStyle(color: Zwart)),
          )
        ]);
  }

  Widget imageComponent() {
    return DottedBorder(
        dashPattern: [7],
        color: Blauw,
        strokeWidth: 2,
        child: GestureDetector(
          onTap: () {
            ChooseImage getUrl = ChooseImage();
            getUrl.actionUploadImage(context).whenComplete(() {
              if (this.mounted && getUrl.downloadLink != null) {
                setState(() {
                  _imageUrl = getUrl.downloadLink;
                });
              }
            });
          },
          child: (_imageUrl == null)
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
                    child: Image.network(_imageUrl),
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
              child: Text("Adres", style: SubTitleCustom)),
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
                                  return "ontbreekt";
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
                              return "ontbreekt";
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
                              return "ontbreekt";
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
                      return "ontbreekt";
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
    const minPrice = 0.0;
    const maxPrice = 20.0;
    return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text("Prijs", style: SubTitleCustom),
          Slider(
            value: _price,
            onChanged: (value) {
              if (this.mounted) {
                setState(() {
                  _price = value;
                });
              }
            },
            divisions: 40,
            activeColor: Blauw,
            inactiveColor: Grijs,
            min: minPrice,
            max: maxPrice,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(minPrice.toString() + "€", style: SizeParagraph),
              Text("$_price" + "€", style: SubTitleCustom),
              Text(maxPrice.toString() + "€", style: SizeParagraph),
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
              child: Text("Beschijving", style: SubTitleCustom)),
          TextFormField(
            validator: (input) {
              if (input.isEmpty) {
                return "ontbreekt";
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
          Text("Kenmerken", style: SubTitleCustom),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              CheckboxGroup(
                activeColor: Blauw,
                labels: <String>[
                  'Meerdere ingangen',
                  'Videobewaking',
                  'verlicht',
                  'gedekt',
                  'Buiten',
                ],
                onSelected: (List<String> checked) => _listChecked = checked,
              ),
              Text("Maximale hoogte :",
                  style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w500,
                      color: Zwart)),
              RadioButtonGroup(
                  picked: _high,
                  orientation: GroupedButtonsOrientation.HORIZONTAL,
                  activeColor: Blauw,
                  labels: <String>[
                    'Geen',
                    '1,90m',
                    '2,10m',
                    '2,30m',
                    '2,50m',
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

  Widget typesComponent() {
    List types = [
      {"label": "Tweewielers", "icon": Icons.motorcycle},
      {"label": "Klein", "icon": Icons.airport_shuttle},
      {"label": "Gemiddeld", "icon": Icons.directions_car},
      {"label": "Groot", "icon": Icons.directions_car},
      {"label": "Hoog", "icon": Icons.directions_bus},
      {"label": "Heel hoog", "icon": Icons.local_shipping}
    ];

    return Container(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: Text("Type aangepaste voertuigen", style: SubTitleCustom)),
        GridView.count(
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
                        color: _typeVoertuigen.contains(types[index]["label"])
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
        )
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

  void createGarage() async {
    final formState = _formKey.currentState;
    if (formState.validate()) {
      formState.save();

      calculateCoordonate(_street, _number, _city, _postcode).whenComplete(() {
        try {
          Firestore.instance.collection('garages').add({
            'eigenaar': globals.userId,
            'titel': _titel,
            'garageImg': _imageUrl,
            'time': new DateTime.now(),
            'street': _street + ", " + _number,
            'city': _city,
            'postcode': _postcode,
            'prijs': _price,
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
    }
  }
}
