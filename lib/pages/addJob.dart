import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:mapbox_search/mapbox_search.dart';
import 'package:parkly/constant.dart';
import 'package:parkly/localization/keys.dart';
import '../setup/globals.dart' as globals;

class AddJob extends StatefulWidget {
  @override
  _AddJobState createState() => _AddJobState();
}

class _AddJobState extends State<AddJob> {
  List listAdresses = [];
  String searchQuery = "";

  var placesSearch = PlacesSearch(
    apiKey:
        'pk.eyJ1Ijoiam9obm5hdGhhbjk2IiwiYSI6ImNrM3p1M2pwcjFkYmIzZHA3ZGZ5dW1wcGIifQ.pcrBkGP2Jq3H6bcX1M0CYg',
    limit: 10,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
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
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(10),
                  color: Grijs.withOpacity(0.6),
                  child: TextFormField(
                    onChanged: (input) {
                      getPlaces(input);
                      if (input.isEmpty) {
                        if (this.mounted) {
                          setState(() {
                            listAdresses = [];
                          });
                        }
                      }
                    },
                    decoration: InputDecoration(
                        suffixIcon: Icon(Icons.search),
                        border: InputBorder.none,
                        filled: true,
                        fillColor: Wit,
                        hintText: translate(Keys.Inputs_Searchadress),
                        labelStyle: TextStyle(color: Zwart)),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: listAdresses.length == 0 ? 0 : 300,
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
                            updateProfile(
                                context,
                                listAdresses[index].placeName,
                                listAdresses[index].center[1],
                                listAdresses[index].center[0]);
                          },
                          title: Text(listAdresses[index].placeName),
                        ),
                      );
                    },
                  ),
                )
              ],
            )));
  }

  getPlaces(searchQuery) {
    if (searchQuery.isNotEmpty) {
      Future<List<MapBoxPlace>> places = placesSearch.getPlaces(searchQuery);
      places.then((value) {
        if (this.mounted) {
          setState(() {
            listAdresses = value;
          });
        }
      });
    }
  }

  updateProfile(BuildContext context, _homeAdress, _latitude, _longitude) {
    try {
      Firestore.instance
          .collection('users')
          .document(globals.userId)
          .updateData({
        "job": {
          'adress': _homeAdress,
          'latitude': _latitude,
          'longitude': _longitude
        }
      }).whenComplete(() {
        Navigator.of(context).pop();
      });
    } catch (e) {
      print(e.message);
    }
  }
}
