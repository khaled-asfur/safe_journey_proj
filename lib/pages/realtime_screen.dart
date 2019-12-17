import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:safe_journey/models/Enum.dart';

import '../models/global.dart';
import '../models/journey.dart';
import '../models/map_user.dart';

class RealTimeScreen extends StatefulWidget {
  final Journey _journey;
  RealTimeScreen(this._journey);
  @override
  _RealTimeScreenState createState() => _RealTimeScreenState();
}

class _RealTimeScreenState extends State<RealTimeScreen> {
  List<Marker> markers = [];
  CameraPosition _cameraPosition;
  bool _loadedCameraPositon = false;
  Geolocator _geolocator;
  Position _myPosition;
  StreamSubscription<DocumentSnapshot> _usersLocationsStream;
  Map<String, dynamic> _myLocation = {'latitude': null, 'longitude': null};
  double allowedDistance = 15;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  double _distance = 0;
  List<MapUser> _usersJoinsJourney;

  @override
  void initState() {
    super.initState();
    _geolocator = Geolocator();
    _checkPermission();
    widget._journey.getUsersJoinsJourney().then((List<MapUser> allUsers) {
      setState(() {
        _usersJoinsJourney = allUsers;
      });
    });

    if (MapUser.sendLocationStream == null ||
        MapUser.activeJourneyId != widget._journey.id) {
      MapUser.setmyLocationStream(widget._journey.id);
    }

    setCamerPosition();
  }

  @override
  Widget build(BuildContext context) {
    MapUser.myLocationObservable.listen((Map<String, dynamic> location) {
      _myLocation = location;
    });
    if (_usersLocationsStream == null && _usersJoinsJourney != null)
      _usersLocationsStream = _getUsersLocationsStream();

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('$_distance'),
      ),
      body: (_loadedCameraPositon)
          ? GoogleMap(
              mapType: MapType.hybrid,
              initialCameraPosition: _cameraPosition,
              markers: markers.toSet(),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  void setCamerPosition() async {
    _myPosition = await _geolocator.getCurrentPosition();
    _cameraPosition = CameraPosition(
        target: LatLng(
          _myPosition.latitude,
          _myPosition.longitude,
        ),
        zoom: 15);
    setState(() {
      _loadedCameraPositon = true;
    });
  }

  StreamSubscription<DocumentSnapshot> _getUsersLocationsStream() {
    //Listen to changes on other users locations, and set state to show changes on screen

    return Firestore.instance
        .collection('realtimeLocations')
        .document(widget._journey.id)
        .snapshots()
        .listen((DocumentSnapshot snapshot) {
      markers = [];
      print("trying to get markersssssssssssssssssssssssssssssssssss");
      if (snapshot != null && _usersJoinsJourney != null) {
        snapshot.data.forEach((String userId, dynamic data) {
          MapUser user = _getMapUserObject(userId);
          if (user.id == Global.user.id) {
            //add markers only for attendents
            _addmarkerForUser(userId, data, 60.0);
          } else if (user.relation == Relation.ATTENDENT) {
            //add markers only for attendents
            _addmarkerForUser(userId, data, 120.0);
          } else if (user.role == 'ADMIN') {
            //اذا اليوزر الي بحاول اعرضه هو مسؤول الرحلة مشان يظهر لون مختلف للماركر
            _addmarkerForUser(userId, data, 240);
          } else if (widget._journey.role == 'ADMIN')
            //current user is admin, so add marker for all users
            _addmarkerForUser(userId, data, 0.0);
        });
      }
      if (widget._journey.role == "ADMIN") _checkIfUsersInSafeDistance();
      setState(() {});
    });
  }

  MapUser _getMapUserObject(String userId) {
    MapUser user = _usersJoinsJourney.firstWhere((MapUser u) {
      return u.id == userId ? true : false;
    });
    return user;
  }

  _addmarkerForUser(String userId, dynamic data, double markerColor) {
//marker colors: hueRed = 0.0; hueOrange = 30.0;hueYellow = 60.0;hueGreen = 120.0;hueCyan =180.0;
//hueAzure = 210.0; hueBlue = 240.0; hueViolet = 270.0;hueMagenta = 300.0; hueRose = 330.0;
    bool usersDataLoaded =
        _usersJoinsJourney != null && _usersJoinsJourney.length > 0;
    double inActiveUserColor = 300.0;
    DateTime timeCoordinatesSent = data['time'].toDate();
    double color = DateTime.now().difference(timeCoordinatesSent).inSeconds > 15
        ? inActiveUserColor
        : markerColor;
    markers.add(
      Marker(
        icon: BitmapDescriptor.defaultMarkerWithHue(color),
        markerId: MarkerId(userId),
        position: LatLng(
          data['latitude'],
          data['longitude'],
        ),
        infoWindow: InfoWindow(
          title: usersDataLoaded ? getUserName(userId) : "Fetching..",
          snippet: usersDataLoaded
              ? getDistanceFromCurrentUser(userId)
              : "Fetching..",
        ),
      ),
    );
  }

  String getDistanceFromCurrentUser(String userId) {
    if (userId == Global.user.id) {
      return "This is your marker";
    }
    return _usersJoinsJourney
            .lastWhere((user) => user.id == userId)
            .distanceFromCurrentUser
            .toString() +
        " m";
  }

  String getUserName(String userId) {
    String name = '';
    _usersJoinsJourney.forEach((MapUser user) {
      if (user.id == userId) name = user.name;
    });
    return name;
  }

  _checkIfUsersInSafeDistance() async {
    SnackBar snackBar;

    String usersIds = "";
    String distances = '';
    bool unsafeUsersExist = false;
    for (Marker marker in markers) {
      String userId = marker.markerId.value;
      if (_myLocation['latitude'] != null && userId != Global.user.id) {
        //  print('in lat != null  ${ marker.position}$_myLocation');
        await Geolocator()
            .distanceBetween(
                marker.position.latitude,
                marker.position.longitude,
                _myLocation['latitude'],
                _myLocation['longitude'])
            .then((distance) {
          _distance = distance;
          _addDistanceToUserObject(distance, userId);
          if (distance > allowedDistance) {
            usersIds += "${marker.markerId.value}, ";
            distances += "$distance, ";
            unsafeUsersExist = true;
          }
        });
      }
    }
    if (unsafeUsersExist) {
      snackBar = SnackBar(
          content: Text(
              'The users with id\'s ($usersIds) are out side the allowed area' +
                  '\n and far from you the following distances($distances)'));
      scaffoldKey.currentState.showSnackBar(snackBar);
    }
  }

  _addDistanceToUserObject(distance, userId) {
    if (_usersJoinsJourney != null && _usersJoinsJourney.length != null) {
      _usersJoinsJourney.forEach((MapUser user) {
        if (user.id == userId) {
          user.distanceFromCurrentUser = distance;
        }
      });
    }
  }

  void _checkPermission() {
    _geolocator.checkGeolocationPermissionStatus().then((status) {
      print('status: $status');
    });
    _geolocator
        .checkGeolocationPermissionStatus(
            locationPermission: GeolocationPermission.locationAlways)
        .then((status) {
      print('always status: $status');
    });
    _geolocator
        .checkGeolocationPermissionStatus(
            locationPermission: GeolocationPermission.locationWhenInUse)
        .then((status) {
      print('whenInUse status: $status');
    });
  }

  @override
  void dispose() {
    _usersLocationsStream.cancel();
    MapUser.closeSendLocationtoDBStream();
    MapUser.closeMyLocationObservable();
    super.dispose();
  }
}
