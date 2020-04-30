import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong/latlong.dart';
import 'package:parkly/constant.dart';
import 'package:parkly/script/changeDate.dart';
import 'package:parkly/script/checkFavorite.dart';
import 'package:parkly/ui/button.dart';
import 'package:parkly/ui/listText.dart';
import 'package:parkly/ui/modal.dart';
import 'package:parkly/ui/ratingCard.dart';
import 'package:parkly/ui/ratingModal.dart';
import 'package:parkly/ui/showStars.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:snaplist/snaplist.dart';
import '../setup/globals.dart' as globals;
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:parkly/localization/keys.dart';

class DetailGarage extends StatefulWidget {
  final String idGarage;
  final bool isVanMij;

  DetailGarage({
    @required this.idGarage,
    this.isVanMij: false,
  });
  @override
  _DetailGarageState createState() =>
      _DetailGarageState(idGarage: idGarage, isVanMij: isVanMij);
}

class _DetailGarageState extends State<DetailGarage> {
  String idGarage;
  bool isVanMij;
  _DetailGarageState({Key key, this.idGarage, this.isVanMij});

  List betalingCard = [];
  List mijnFavorieten = [];
  DateTime beginDate;
  DateTime endDate;
  double prijs;

  String eigenaarName = "";
  String eigenaarId = "";

  getUserData() {
    Firestore.instance
        .collection('users')
        .document(globals.userId)
        .snapshots()
        .listen((userInstance) {
      if (this.mounted) {
        setState(() {
          mijnFavorieten = userInstance.data["favoriet"];
          betalingCard = userInstance.data["paymethode"];
        });
      }
    });
  }

  getEigenaarData() {
    var eigenaar = Firestore.instance
        .collection("users")
        .where('mijnGarage', arrayContains: idGarage)
        .getDocuments();

    eigenaar.then((value) {
      for (var item in value.documents) {
        if (this.mounted) {
          setState(() {
            eigenaarName = item.data["voornaam"];
            eigenaarId = item.documentID;
          });
        }
      }
      return;
    });
  }

  @override
  void initState() {
    getUserData();
    getEigenaarData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Zwart),
          backgroundColor: Wit,
          elevation: 0.0,
          title: Image.asset('assets/images/logo.png', height: 32),
          actions: <Widget>[
            isVanMij
                ? Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: IconButton(
                        icon: Icon(Icons.edit, color: Blauw), onPressed: () {}))
                : Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: IconButton(
                        icon: mijnFavorieten.contains(idGarage)
                            ? Icon(Icons.favorite, color: Blauw)
                            : Icon(Icons.favorite_border, color: Blauw),
                        onPressed: () {
                          CheckFav().isgarageInFavorite(idGarage);
                        })),
          ],
        ),
        body: StreamBuilder<DocumentSnapshot>(
            stream: Firestore.instance
                .collection('garages')
                .document(idGarage)
                .snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasData) {
                return SingleChildScrollView(
                    child: Column(
                  children: <Widget>[
                    Container(
                        height: 200,
                        child: Stack(
                            overflow: Overflow.visible,
                            alignment: Alignment.bottomRight,
                            children: <Widget>[
                              FlutterMap(
                                options: new MapOptions(
                                  center: new LatLng(snapshot.data["latitude"],
                                      snapshot.data["longitude"]),
                                  zoom: 15.0,
                                ),
                                layers: [
                                  new TileLayerOptions(
                                    urlTemplate:
                                        "https://api.tiles.mapbox.com/v4/"
                                        "{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}",
                                    additionalOptions: {
                                      'accessToken':
                                          'pk.eyJ1Ijoiam9obm5hdGhhbjk2IiwiYSI6ImNrM3p1M2pwcjFkYmIzZHA3ZGZ5dW1wcGIifQ.pcrBkGP2Jq3H6bcX1M0CYg',
                                      'id': 'mapbox.outdoors',
                                    },
                                  ),
                                  MarkerLayerOptions(
                                    markers: [
                                      new Marker(
                                          point: new LatLng(
                                              snapshot.data["latitude"],
                                              snapshot.data["longitude"]),
                                          height: 50,
                                          width: 50,
                                          builder: (ctx) => new Container(
                                                child: Icon(Icons.location_on,
                                                    color: Blauw),
                                              ))
                                    ],
                                  ),
                                ],
                              ),
                              Positioned(
                                right: 20,
                                bottom: -25,
                                child: FloatingActionButton(
                                  backgroundColor: Blauw,
                                  elevation: 0.0,
                                  onPressed: () async {
                                    var url =
                                        'https://www.waze.com/ul?ll=${snapshot.data["latitude"]}%2C${snapshot.data["longitude"]}&navigate=yes';

                                    if (await canLaunch(url)) {
                                      await launch(url);
                                    } else {
                                      throw 'Could not launch $url';
                                    }
                                  },
                                  child: Icon(Icons.navigation),
                                ),
                              )
                            ])),
                    Column(
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            child: headerComponent(snapshot.data)),
                        !isVanMij
                            ? Padding(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: reservatieComponent(snapshot.data))
                            : Container(),
                        Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            child: kenmerkenComponent(snapshot.data)),
                        Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: imageComponent(snapshot.data)),
                        snapshot.data["rating"].length != 0
                            ? Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
                                child: reviewsComponent(snapshot.data))
                            : Container(),
                        Padding(
                          padding: EdgeInsets.only(top: 10, bottom: 30),
                          child: Text(
                              translate(Keys.Apptext_Offeredby) + eigenaarName,
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                color: Grijs,
                              )),
                        )
                      ],
                    )
                  ],
                ));
              } else {
                return Container(
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(
                      valueColor: new AlwaysStoppedAnimation<Color>(Blauw)),
                );
              }
            }));
  }

  Widget headerComponent(DocumentSnapshot garage) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(garage['street'], style: SubTitleCustom),
                    Text(garage['city'] + " " + garage['postcode'],
                        style: SubTitleCustom),
                    Row(
                      children: <Widget>[
                        ShowStars(rating: garage["rating"]),
                        Padding(
                            padding: EdgeInsets.only(left: 10, top: 5),
                            child: Text("(" +
                                garage['rating'].length.toString() +
                                " reviews)"))
                      ],
                    ),
                  ]),
              Text(garage['prijs'].toString() + " €", style: ShowPriceStyle)
            ]),
        Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Text(garage['beschrijving'], style: SizeParagraph)),
        FlatButton(
            onPressed: () {
              //TODO: create new convers
            },
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.message, color: Blauw, size: 20),
                  Padding(
                      padding: EdgeInsets.only(left: 7),
                      child: Text(translate(Keys.Button_Sendmessageowner),
                          style: TextStyle(
                            color: Blauw,
                          )))
                ])),
        Divider(color: Grijs)
      ],
    );
  }

  Widget reservatieComponent(DocumentSnapshot garage) {
    var localizationDelegate = LocalizedApp.of(context).delegate;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: FlatButton(
                onPressed: () {
                  DatePicker.showDateTimePicker(context,
                      showTitleActions: true,
                      minTime: DateTime.now(),
                      currentTime: DateTime.now(),
                      locale: LocaleType.fr, onConfirm: (date) {
                    if (this.mounted) {
                      setState(() {
                        beginDate = date;
                        if (endDate != null) {
                          prijs = calculatePrice(
                              beginDate, endDate, garage["prijs"]);
                        }
                      });
                    }
                  });
                },
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                      color: Wit,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(Radius.circular(5.0))),
                  alignment: Alignment.center,
                  child: beginDate != null
                      ? Text(changeDateWithTime(beginDate))
                      : Text(translate(Keys.Inputs_Begindate),
                          style: TextStyle(color: Zwart)),
                ))),
        beginDate != null
            ? Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: FlatButton(
                    onPressed: () {
                      DatePicker.showDateTimePicker(context,
                          showTitleActions: true,
                          minTime: beginDate.add(Duration(hours: 1)),
                          currentTime: beginDate.add(Duration(hours: 1)),
                          locale: getCurrentLanguageLocalizationKey(
                              localizationDelegate.currentLocale.languageCode),
                          onConfirm: (date) {
                        if (this.mounted) {
                          setState(() {
                            endDate = date;
                            prijs = calculatePrice(
                                beginDate, endDate, garage["prijs"]);
                          });
                        }
                      });
                    },
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                          color: Wit,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.all(Radius.circular(5.0))),
                      alignment: Alignment.center,
                      child: endDate != null
                          ? Text(changeDateWithTime(endDate))
                          : Text(translate(Keys.Inputs_Enddate),
                              style: TextStyle(color: Zwart)),
                    )))
            : Container(),
        endDate != null
            ? Padding(
                padding: EdgeInsets.only(bottom: 10, right: 20, left: 20),
                child: Align(
                  alignment: AlignmentDirectional.bottomEnd,
                  child: Text(
                      translate(Keys.Apptext_Total) +
                          " " +
                          prijs.toString() +
                          "€",
                      style: SubTitleCustom),
                ))
            : Container(),
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: ButtonComponent(
              label: translate(Keys.Button_Reserve),
              onClickAction: endDate == null
                  ? null
                  : () {
                      if (betalingCard.isEmpty) {
                        showDialog(
                          context: context,
                          builder: (_) => ModalComponent(
                            modalTekst: translate(Keys.Modal_Nocard),
                            showAddCartBtn: true,
                          ),
                        );
                      } else {
                        createReservatie();
                      }
                    },
            ))
      ],
    );
  }

  Widget kenmerkenComponent(DocumentSnapshot garage) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        garage["kenmerken"].length != 0
            ? Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Text(translate(Keys.Subtitle_Features),
                    style: SubTitleCustom),
              )
            : Container(),
        garage["kenmerken"].length != 0
            ? GridView.count(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                childAspectRatio: 5,
                crossAxisSpacing: 30,
                crossAxisCount: 2,
                children: List.generate(garage["kenmerken"].length, (index) {
                  return ListTextComponent(label: garage["kenmerken"][index]);
                }))
            : Container(),
        garage["types"].length != 0
            ? Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Text(translate(Keys.Subtitle_Adaptedfor),
                    style: SubTitleCustom),
              )
            : Container(),
        garage["types"].length != 0
            ? GridView.count(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                crossAxisCount: 3,
                children: List.generate(garage["types"].length, (index) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(width: 2, color: Transparant),
                      color: Wit,
                    ),
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                    width: 110,
                    height: 110,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[Text(garage["types"][index])],
                    ),
                  );
                }))
            : Container()
      ],
    );
  }

  Widget imageComponent(DocumentSnapshot garage) {
    return ConstrainedBox(
        constraints: const BoxConstraints(minWidth: double.infinity),
        child: Container(
            height: 200,
            color: Zwart,
            child: Image.network(garage['garageImg'], fit: BoxFit.cover)));
  }

  Widget reviewsComponent(DocumentSnapshot garage) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(translate(Keys.Subtitle_Reviews), style: SubTitleCustom),
              !isVanMij
                  ? FlatButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (_) => RatingModal(idGarage: idGarage),
                        );
                      },
                      child: Text(translate(Keys.Button_Add) + " +",
                          style: TextStyle(color: Blauw)))
                  : Container()
            ],
          ),
        ),
        Container(
            height: 150,
            child: SnapList(
              sizeProvider: (index, data) => Size(
                  garage["rating"].length == 1
                      ? MediaQuery.of(context).size.width * 1
                      : MediaQuery.of(context).size.width * 0.85,
                  150.0),
              separatorProvider: (index, data) => Size(10.0, 10.0),
              builder: (context, index, data) {
                return RatingCardComponent(card: garage["rating"][index]);
              },
              count: garage["rating"].length,
            ))
      ],
    );
  }

  void createReservatie() async {
    try {
      Firestore.instance.collection('reservaties').add({
        'createDay': new DateTime.now(),
        'begin': beginDate,
        'end': endDate,
        'prijs': prijs,
        'eigenaar': eigenaarId,
        'aanvrager': globals.userId,
        'garageId': idGarage,
        'accepted': false,
      });
    } catch (e) {
      print(e.message);
    }
  }

  getCurrentLanguageLocalizationKey(String code) {
    switch (code) {
      case "nl":
        return LocaleType.nl;
      case "fr":
        return LocaleType.fr;
      case "en":
        return LocaleType.en;
      default:
        return LocaleType.nl;
    }
  }
}
