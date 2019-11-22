import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:safe_journey/models/global.dart';
import 'package:safe_journey/models/journey.dart';

class RealTimeScreen extends StatefulWidget {
  final Journey _journey;
  RealTimeScreen(this._journey);
  @override
  _RealTimeScreenState createState() => _RealTimeScreenState();
}

class _RealTimeScreenState extends State<RealTimeScreen> {
  @override
  Widget build(BuildContext context) {
    print('in map build');
    print(markers.length);

    return Scaffold(
      appBar: AppBar(
        title: Text('Monitoring All Locations'),
      ),
      body: (loaded)
          ? GoogleMap(
              initialCameraPosition: cameraPosition,
              markers: markers.toSet(),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  @override
  void initState() {
    super.initState();
    print('in initstate');
    _geolocator = Geolocator();
    locationOptions = LocationOptions(
      accuracy: LocationAccuracy.high,
    );
    _setmyLocationStream();
    _checkPermission();
    Firestore.instance
        .collection('realtimeLocations')
        .snapshots()
        .listen((QuerySnapshot snapshot) {
      markers = [];
      for (var doc in snapshot.documents) {
        if (doc != null) {
          if (doc.documentID.trim() != 'IHJA4sYuIreak96nQpOP'.trim()) {//مشان ما اجبيب بيانات الدكيومنت الخربان 
             print(doc.documentID);
            print('looooooooooooooooooooooooooooooooool');
            print(doc.data);
            
            _users.add(User(doc.documentID));
            markers.add(Marker(
                markerId: MarkerId(doc.documentID),
                position: LatLng(
                  doc['latitude'],
                  doc['longitude'],
                ),
                infoWindow: InfoWindow(title: doc.documentID)));
            setState(() {});
          }
        }
      }
    });
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
    _geolocator.checkGeolocationPermissionStatus(
        locationPermission: GeolocationPermission.locationWhenInUse)
      ..then((status) {
        print('whenInUse status: $status');
      });
  }

  void _sendUserLocationToDB(double latitude, double longitude) {
    String uid = Global.user.id;
    print(uid);
    Firestore.instance
        .collection('realtimeLocations')
        .document(uid)
        .setData({'latitude': latitude, 'longitude': longitude});
  }

  _setmyLocationStream() {
    _geolocator.getPositionStream(locationOptions).listen((Position pos) {
      print('sending my positions');
      if (!loaded) {
        print('in not loaded');
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
      print(pos);

      _sendUserLocationToDB(pos.latitude, pos.longitude);
    });
  }

  List<Marker> markers = [];
  CameraPosition cameraPosition;
  bool loaded = false;
  List<User> _users = [];
  Geolocator _geolocator;
  LocationOptions locationOptions;
  Position myPosition;
}

class User {
  String name;

  User(this.name);
}
