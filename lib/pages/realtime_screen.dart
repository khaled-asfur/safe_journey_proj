import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:safe_journey/models/Enum.dart';
import 'package:safe_journey/models/helpers.dart';
import 'package:safe_journey/models/push_notification.dart';
import 'package:safe_journey/models/sounds.dart';

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
  double allowedDistance = 2;
  //GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  // double _distance = 0;
  List<MapUser> _usersJoinsJourney;
  bool userStartedSendLocation = false;
  bool _allowedToSendNotifications = true;
  bool _markersReady = false;

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
    if (MapUser.sendLocationStream == null) {
      MapUser.setmyLocationStream(widget._journey.id);
      userStartedSendLocation = true;
    }

    setCamerPosition();
  }

  @override
  Widget build(BuildContext context) {
    Global.currentPageContext = context;
    print('in map build');
    MapUser.myLocationObservable.listen((Map<String, dynamic> location) {
      _myLocation = location;
    });
    if (_usersLocationsStream == null && _usersJoinsJourney != null)
      _usersLocationsStream = _getUsersLocationsStream();

    return Scaffold(
      // key: scaffoldKey,
      appBar: AppBar(
          // title: Text('${_distance.round()} m'),
          ),
      body: (_loadedCameraPositon && _markersReady)
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
        _checkIfUsersInSafeDistance(snapshot.data).then((bool x) {
          print('in then');
          updateMarkers(snapshot);
          setState(() {
            _markersReady = true;
          });
        });
      }
      // setState(() {});
    });
  }

  updateMarkers(DocumentSnapshot realtimeLocationsSnapshot) {
    realtimeLocationsSnapshot.data.forEach((String userId, dynamic data) {
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
      } else if (widget._journey.role == 'ADMIN') {
        //current user is admin, so add marker for all users
        if (user.role != 'PARENT') _addmarkerForUser(userId, data, 0.0);
      }
    });
  }

  MapUser _getMapUserObject(String userId) {
    _usersJoinsJourney.forEach((MapUser user) {
      //  print('${user.id} -- ${user.name}  joins journey ');
    });
    // print('userid= $userId ${_usersJoinsJourney.length}');
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
    String distance = _usersJoinsJourney
            .lastWhere((user) => user.id == userId)
            .distanceFromCurrentUser
            .toString() +
        " m";
 //   print('$userId distance on marker = $distance');
    return distance;
  }

  String getUserName(String userId) {
    String name = '';
    _usersJoinsJourney.forEach((MapUser user) {
      if (user.id == userId) name = user.name;
    });
    return name;
  }

  Future<bool>_checkIfUsersInSafeDistance(
      Map<String, dynamic> realtimeLocationsData) async {
         List<Map<String,dynamic>> lst= [];
         realtimeLocationsData.forEach((String id ,dynamic  element ){
        Map<String,dynamic> k= {
          'id':id,
          'latitude':element['latitude'],
          'longitude':element['longitude'],
          'time':element['time'],
        };
        lst.add(k);
         });
        
   
    List<String> unsafeUsers = [];
    String distances = '';
    bool unsafeUsersExist = false;
    //realtimeLocationsData.forEach((String userId, dynamic data) async
      for(var data in lst){
      //String userId = marker.markerId.value;
      if (_myLocation['latitude'] != null && data['id'] != Global.user.id) {
     var distance=   await Geolocator()
            .distanceBetween(data['latitude'], data['longitude'],
                _myLocation['latitude'], _myLocation['longitude']);
            //.then((distance) {
          _addDistanceToUserObject(distance,  data['id']);
         // print("user id=${ data['id']} and distance = $distance ");
          if (distance > widget._journey.distance) {
            //  print("the allowed distance= ${widget._journey.distance} -- ******************************");
            unsafeUsers.add( data['id']);
            int intDistance = distance.round();
            distances += "$intDistance, ";
            unsafeUsersExist = true;
          }
       // });
      }
    }

    if (unsafeUsersExist && widget._journey.role == "ADMIN") {
      String unsafeUsersStr =
          MapUser.getUsersNames(_usersJoinsJourney, unsafeUsers);
      distances = distances.substring(0, distances.length - 2);
      String message =
          'The users  ($unsafeUsersStr) are out side the allowed area' +
              '\n and far from you the following distances($distances)m.';
      if (_allowedToSendNotifications) {
        _allowedToSendNotifications = false;
        if (Global.activeJourneyId == widget._journey.id)
          _notifyAdminAboutUSersOutOfRange(message, unsafeUsers);
        Timer(Duration(minutes: 1), () {
          _allowedToSendNotifications = true;
        });
      }
    }
    return true;
  }

  _notifyAdminAboutUSersOutOfRange(String message, List<String> usersIds) {
    Helpers.showErrorDialog(context, message, warning: true);
    Sounds.playSound('../sounds/alert.mp3');
    usersIds.forEach((String userId) {
      PushNotification.sendNotificationToUser(
          userId,
          "Caution!, you went so far",
          'you ara out of the range allowed for you to be in, please go back and be close to the admin.',
          type: 'EXCCEEDED_ALLOWED_DISTANCE');
    });
  }

  _addDistanceToUserObject(distance, userId) {
    if (_usersJoinsJourney != null && _usersJoinsJourney.length != null) {
      _usersJoinsJourney.forEach((MapUser user) {
        if (user.id == userId) {
          user.distanceFromCurrentUser = distance ;
         // print('distance $distance added for user $userId');
        }
      });
    }
  }

  void _checkPermission() {
    _geolocator.checkGeolocationPermissionStatus().then((status) {
    //  print('status: $status');
    });
    _geolocator
        .checkGeolocationPermissionStatus(
            locationPermission: GeolocationPermission.locationAlways)
        .then((status) {
    //  print('always status: $status');
    });
    _geolocator
        .checkGeolocationPermissionStatus(
            locationPermission: GeolocationPermission.locationWhenInUse)
        .then((status) {
     // print('whenInUse status: $status');
    });
  }

  @override
  void dispose() {
    _usersLocationsStream.cancel();
    if (userStartedSendLocation) MapUser.closeSendLocationtoDBStream();
    MapUser.closeMyLocationObservable();
    super.dispose();
  }
}
