//marker: 30/03/20 - https://lottiefiles.com/1705-mappoint
import 'package:app_settings/app_settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:parkly/constant.dart';
import 'package:latlong/latlong.dart';
import 'package:parkly/script/mapcontroller.dart';
import 'package:parkly/ui/button.dart';
import 'package:parkly/ui/modalMaps.dart';
import 'package:parkly/ui/navigation.dart';
import '../setup/globals.dart' as globals;
import 'package:lottie/lottie.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:parkly/localization/keys.dart';
import 'package:location_permissions/location_permissions.dart';
// import 'package:search_map_place/search_map_place.dart';

class MapsPage extends StatefulWidget {
  const MapsPage();
  @override
  _MapsPageState createState() => new _MapsPageState();
}

class _MapsPageState extends State<MapsPage> with TickerProviderStateMixin {
  static final GlobalKey<ScaffoldState> scaffoldKey =
      new GlobalKey<ScaffoldState>();

  MapController mapController = new MapController();
  double userLat = 0;
  double userLon = 0;

  bool showMaps = false;

  Position position;
  List<Marker> markers = [];

  String searchQuery = "";

  Map showGarage = {};

  MarkerClusterPlugin plugin;

  @override
  initState() {
    _getUserPosition();
    _getGaragePosition();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Zwart),
          actionsIconTheme: IconThemeData(color: Zwart),
          title: Image.asset('assets/images/logo.png', height: 32),
          backgroundColor: Wit,
          elevation: 0.0,
        ),
        floatingActionButton: showMaps
            ? FloatingActionButton(
                heroTag: "location",
                backgroundColor: Blauw,
                child: Icon(Icons.my_location),
                onPressed: () async {
                  GeolocationStatus geolocationStatus =
                      await Geolocator().checkGeolocationPermissionStatus();

                  if (geolocationStatus == GeolocationStatus.granted) {
                    Position userPosition = await Geolocator()
                        .getCurrentPosition(
                            desiredAccuracy:
                                LocationAccuracy.bestForNavigation);

                    zoomToPosition(
                        mapController,
                        LatLng(userPosition.latitude, userPosition.longitude),
                        15,
                        this);
                  }
                })
            : Container(),
        body: showFlutterMap(),
        drawer: Navigation(activeMap: true));
  }

  Widget showFlutterMap() {
    return showMaps
        ? Stack(
            alignment: AlignmentDirectional.topCenter,
            children: <Widget>[
              FlutterMap(
                mapController: mapController,
                options: new MapOptions(
                  center: new LatLng(userLat, userLon),
                  zoom: 13.0,
                  plugins: [plugin],
                ),
                layers: [
                  new TileLayerOptions(
                    urlTemplate: "https://api.tiles.mapbox.com/v4/"
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
                          point: new LatLng(userLat, userLon),
                          height: 50,
                          width: 50,
                          builder: (ctx) => new Container(
                                child:
                                    Lottie.asset('assets/anim/position.json'),
                              )),
                    ],
                  ),
                  (plugin != null)
                      ? MarkerClusterLayerOptions(
                          maxClusterRadius: 120,
                          size: Size(40, 40),
                          fitBoundsOptions: FitBoundsOptions(
                            padding: EdgeInsets.all(50),
                          ),
                          markers: markers,
                          polygonOptions: PolygonOptions(
                              borderColor: Blauw,
                              color: Colors.black12,
                              borderStrokeWidth: 3),
                          builder: (context, markers) {
                            return FloatingActionButton(
                              heroTag: "markers",
                              child: Text(markers.length.toString()),
                              backgroundColor: Blauw,
                              onPressed: null,
                            );
                          },
                        )
                      : MarkerLayerOptions(
                          markers: markers,
                        ),
                ],
              ),
              // Padding(
              //     padding: const EdgeInsets.only(top: 10),
              //     child: SearchMapPlaceWidget(
              //       apiKey: "",
              //       onSelected: (Place place) async {
              //         print(place.geolocation);
              //       },
              //     )),
            ],
          )
        : Container(
            margin: EdgeInsets.symmetric(horizontal: 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ButtonComponent(
                    onClickAction: () {
                      AppSettings.openLocationSettings();
                    },
                    label: "Activer votre Geolocalitation"),
                FlatButton(
                    onPressed: () {
                      _getUserPosition();
                    },
                    child: Text(translate(Keys.Button_Refresh),
                        style: TextStyle(color: Blauw)))
              ],
            ),
          );
  }

  _getUserPosition() async {
    await LocationPermissions().requestPermissions();

    GeolocationStatus geolocationStatus =
        await Geolocator().checkGeolocationPermissionStatus();

    if (geolocationStatus == GeolocationStatus.denied) {
      if (this.mounted) {
        setState(() {
          showMaps = false;
        });
      }
    }

    if (geolocationStatus == GeolocationStatus.granted) {
      Position positionUser = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

      Geolocator()
          .getPositionStream(LocationOptions(
              accuracy: LocationAccuracy.bestForNavigation, distanceFilter: 0))
          .listen((Position position) {
        if (this.mounted) {
          setState(() {
            userLat = position.latitude;
            userLon = position.longitude;
          });
        }
      });

      if (this.mounted) {
        setState(() {
          showMaps = true;
          userLat = positionUser.latitude;
          userLon = positionUser.longitude;
        });
      }

      zoomToPosition(mapController,
          LatLng(positionUser.latitude, positionUser.longitude), 15, this);
    }
  }

  _getGaragePosition() async {
    final QuerySnapshot result =
        await Firestore.instance.collection('garages').getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    documents.forEach((data) {
      if (data.data["eigenaar"] != globals.userId) {
        markers.add(
          Marker(
            width: 60,
            point: new LatLng(data.data["location"]["geopoint"].latitude,
                data.data["location"]["geopoint"].longitude),
            builder: (ctx) => GestureDetector(
                onTap: () {
                  zoomToPosition(
                      mapController,
                      new LatLng(data.data["location"]["geopoint"].latitude,
                          data.data["location"]["geopoint"].longitude),
                      15,
                      this);
                  _showModalBottomSheet(context, data);
                },
                child: Container(
                  decoration: new BoxDecoration(
                      color: Wit,
                      borderRadius: new BorderRadius.all(Radius.circular(5)),
                      border: Border.all(width: 2.0, color: Blauw)),
                  alignment: Alignment.center,
                  child: Text(data.data["prijs"].toString() + "€",
                      style:
                          TextStyle(color: Blauw, fontWeight: FontWeight.w500)),
                )),
          ),
        );
      }
    });
    if (this.mounted) {
      setState(() {
        plugin = MarkerClusterPlugin();
      });
    }
  }

  _showModalBottomSheet(context, DocumentSnapshot garage) {
    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Transparant,
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 330,
            decoration: BoxDecoration(
                color: Wit,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20))),
            child: ModalMapComponent(garage: garage),
          );
        });
  }
}
