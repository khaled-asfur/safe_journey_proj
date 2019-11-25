import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
//import 'package:safe_journey/models/helpers.dart';

import '../models/global.dart';
import '../models/journey.dart';

class RealTimeScreen extends StatefulWidget {
  final Journey _journey;
  RealTimeScreen(this._journey);
  @override
  _RealTimeScreenState createState() => _RealTimeScreenState();
}

class _RealTimeScreenState extends State<RealTimeScreen> {
  List<Marker> markers = [];
  CameraPosition cameraPosition;
  bool loaded = false;
  //List<User> _users = [];
  Geolocator _geolocator;
  LocationOptions locationOptions;
  Position myPosition;
  StreamSubscription<DocumentSnapshot> _usersLocationsStream;
  Map<String, dynamic> _myLocation = {'latitude': null, 'longitude': null};
  double allowedDistance = 15;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  Timer timer;
  bool allowedToSendCoordinates = true;
  Firestore _instance = Firestore.instance;
  StreamSubscription<Position> _sendLocationStream ;
  double _distance =0;

  @override
  void initState() {
    super.initState();
    //print('in realtime initstate');
    _geolocator = Geolocator();
    locationOptions = LocationOptions(
      accuracy: LocationAccuracy.best,
    );
    _setmyLocationStream(); //send my location to DB
    _checkPermission();
    _usersLocationsStream =
        _getUsersLocationsStream(); //read other users locations from DB
  }

  @override
  Widget build(BuildContext context) {
    // print("in map build${markers.length}");
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        /*'$_myLocation', style: TextStyle(fontSize: 10)*/
        title: Text('$_distance'),
      ),
      body: (loaded)
          ? GoogleMap(
              mapType: MapType.hybrid,
              initialCameraPosition: cameraPosition,
              markers: markers.toSet(),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  StreamSubscription<DocumentSnapshot> _getUsersLocationsStream() {
    //Listen to changes on other users locations, and set state to show changes on screen

    return Firestore.instance
        .collection('realtimeLocations')
        .document(widget._journey.id)
        .snapshots()
        .listen((DocumentSnapshot snapshot) {
      markers = [];
      if (snapshot != null) {
        // print('snap sata =');
        // print(snapshot.data);
        snapshot.data.forEach((String userId, dynamic coordinates) {
          //_users.add(User(userId));
          markers.add(Marker(
              // icon: BitmapDescriptor() ,
              markerId: MarkerId(userId),
              position: LatLng(
                coordinates['latitude'],
                coordinates['longitude'],
              ),
              infoWindow: InfoWindow(title: userId)));
        });
      }

      /// print('finished getting other users locations');
      _checkIfUsersInSafeDistance();
      setState(() {});
    });
  }

  _checkIfUsersInSafeDistance() async {
    SnackBar snackBar;

    //print('in check');
    String usersIds = "";
    String distances = '';
    bool unsafeUsersExist = false;
    for (Marker marker in markers) {
      String x = marker.markerId.value;
      // String y=Global.user.id;
      //  print("x="+x);
      // print("y="+y);
      if (_myLocation['latitude'] != null && x != Global.user.id) {
        //  print('in lat != null  ${ marker.position}$_myLocation');
        await Geolocator()
            .distanceBetween(
                marker.position.latitude,
                marker.position.longitude,
                _myLocation['latitude'],
                _myLocation['longitude'])
            .then((distance) {
              _distance=distance;
          //  print(distance);

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

  _sendUserLocationToDB(
    //send my coordinates to database
    double latitude,
    double longitude,
    String journeyId) async {
    String uid = Global.user.id;
    print('in send to db $journeyId');
    print(allowedToSendCoordinates);
    if(allowedToSendCoordinates){
      print('allowed');
      allowedToSendCoordinates=false;
      timer = Timer(Duration(seconds:5), () {
        print('timer done');
      allowedToSendCoordinates=true;
    });

    await _instance
        .collection('realtimeLocations')
        .document(journeyId)
        .updateData({
      uid: {'latitude': latitude, 'longitude': longitude}
      
    }).catchError((s){
      print(s);
    });
    
    print(' my position senttttttttt $uid $latitude $longitude');
    }
  }

  _setmyLocationStream() {
    //Listen to changes on my location, and send my coordinates to database

  _sendLocationStream= _geolocator.getPositionStream(locationOptions).listen((Position pos) {
      // print('in send Stream');
      _myLocation = {'latitude': pos.latitude, 'longitude': pos.longitude};
      if (!loaded) {
        cameraPosition = CameraPosition(
            target: LatLng(
              pos.latitude,
              pos.longitude,
            ),
            zoom: 15);
        setState(() {
          myPosition = pos;
          loaded = true;
        });
      }

      _sendUserLocationToDB(pos.latitude, pos.longitude, widget._journey.id);
    });
  }

  @override
  void dispose() {
    _usersLocationsStream.cancel();
    _sendLocationStream.cancel();
    super.dispose();
  }
}

class User {
  String name;

  User(this.name);
}
