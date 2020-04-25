//marker: 30/03/20 - https://lottiefiles.com/1705-mappoint
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:parkly/constant.dart';
import 'package:latlong/latlong.dart';
import 'package:parkly/script/mapcontroller.dart';
import 'package:parkly/ui/modalMaps.dart';
import 'package:parkly/ui/navigation.dart';
import '../setup/globals.dart' as globals;
import 'package:lottie/lottie.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:parkly/localization/keys.dart';

class MapsPage extends StatefulWidget {
  const MapsPage();
  @override
  _MapsPageState createState() => new _MapsPageState();
}

class _MapsPageState extends State<MapsPage> with TickerProviderStateMixin {
  static final GlobalKey<ScaffoldState> scaffoldKey =
      new GlobalKey<ScaffoldState>();

  MapController mapController = new MapController();
  Position position;
  List<Marker> markers = [];
  List<Marker> userPositionMarker = [];

  TextEditingController _searchQuery;
  bool _isSearching = false;
  String searchQuery = "";

  Map showGarage = {};
  DateTime dateTime;

  MarkerClusterPlugin plugin;

  @override
  initState() {
    dateTime = DateTime.now();
    _getUserPosition();
    _getGaragePosition();
    _searchQuery = new TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Zwart),
          actionsIconTheme: IconThemeData(color: Zwart),
          title: _isSearching
              ? _buildSearchField()
              : Image.asset('assets/images/logo.png', height: 32),
          backgroundColor: Wit,
          elevation: 0.0,
          actions: _buildActions(),
        ),
        floatingActionButton: FloatingActionButton(
          heroTag: "lacation",
          backgroundColor: Blauw,
          child: Icon(Icons.my_location),
          onPressed: () async {
            DocumentSnapshot positionUser = await Firestore.instance
                .collection('users')
                .document(globals.userId)
                .get();
            Map positionLatLng = positionUser.data["position"];

            zoomToPosition(
                mapController,
                LatLng(positionLatLng["latitude"], positionLatLng["longitude"]),
                15,
                this);
          },
        ),
        body: StreamBuilder<DocumentSnapshot>(
          stream: Firestore.instance
              .collection('users')
              .document(globals.userId)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasData) {
              return FlutterMap(
                mapController: mapController,
                options: new MapOptions(
                  center: new LatLng(snapshot.data["position"]["latitude"],
                      snapshot.data["position"]["longitude"]),
                  zoom: 2.0,
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
                    markers: userPositionMarker,
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
              );
            } else {
              return Container(
                alignment: Alignment.center,
                child: CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(Blauw)),
              );
            }
          },
        ),
        drawer: Navigation(activeMap: true));
  }

  _getUserPosition() async {
    var geolocator = Geolocator();
    Position position = await Geolocator().getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    position = position;

    var locationOptions = LocationOptions(
        accuracy: LocationAccuracy.bestForNavigation, distanceFilter: 0);

    Firestore.instance
        .collection('users')
        .document(globals.userId)
        .snapshots()
        .listen((snapshot) {
      userPositionMarker = [
        new Marker(
            point: new LatLng(position.latitude, position.longitude),
            height: 50,
            width: 50,
            builder: (ctx) => new Container(
                  child: Lottie.asset('assets/anim/position.json'),
                )),
      ];
    });

    geolocator.getPositionStream(locationOptions).listen((Position position) {
      if (this.mounted) {
        setState(() {
          position = position;
        });
      }
      if (this.mounted) {
        if (DateTime.now().difference(dateTime).inSeconds > 5) {
          Firestore.instance
              .collection('users')
              .document(globals.userId)
              .updateData({
            "position": {
              'latitude': position.latitude,
              'longitude': position.longitude,
            }
          });
          setState(() {
            dateTime = DateTime.now();
          });
        }
      }
    });
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
            point: new LatLng(data.data["latitude"], data.data["longitude"]),
            builder: (ctx) => GestureDetector(
                onTap: () {
                  zoomToPosition(
                      mapController,
                      LatLng(data.data["latitude"], data.data["longitude"]),
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

  void _startSearch() {
    ModalRoute.of(context)
        .addLocalHistoryEntry(new LocalHistoryEntry(onRemove: _stopSearching));

    if (this.mounted) {
      setState(() {
        _isSearching = true;
      });
    }
  }

  void _stopSearching() {
    _clearSearchQuery();

    if (this.mounted) {
      setState(() {
        _isSearching = false;
      });
    }
  }

  void _clearSearchQuery() {
    if (this.mounted) {
      setState(() {
        _searchQuery.clear();
      });
    }
  }

  Widget _buildSearchField() {
    return new TextField(
      controller: _searchQuery,
      autofocus: true,
      decoration: InputDecoration(
        filled: true,
        fillColor: Wit,
        hintText: translate(Keys.Inputs_Search),
        border: InputBorder.none,
        hintStyle: const TextStyle(color: Grijs),
      ),
      style: SizeParagraph,
      onChanged: updateSearchQuery,
    );
  }

  void updateSearchQuery(String newQuery) {
    if (this.mounted) {
      setState(() {
        searchQuery = newQuery;
      });
    }
  }

  List<Widget> _buildActions() {
    if (_isSearching) {
      return <Widget>[
        new IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            if (_searchQuery == null || _searchQuery.text.isEmpty) {
              Navigator.pop(context);
              return;
            }
            _clearSearchQuery();
          },
        ),
      ];
    }

    return <Widget>[
      new IconButton(
        icon: Icon(Icons.search),
        onPressed: _startSearch,
      ),
    ];
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
