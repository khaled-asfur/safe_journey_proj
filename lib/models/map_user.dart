import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:safe_journey/models/global.dart';
import 'package:rxdart/subjects.dart' as rx;

import '../models/Enum.dart';

class MapUser {
  String id;
  String name;
  String role;
  List attendents;
  double distanceFromCurrentUser;
  Relation relation; // علاقة اليوزر باليوزر الحالي
  static bool _allowedToSendCoordinates = true;
  //static String activeJourneyId; //for the stream to speecify for what journey
  static StreamSubscription<Position> sendLocationStream;
  static rx.PublishSubject<Map<String, dynamic>> myLocationObservable;

  //invoke the super class constructor.. necessary for inheritence
  MapUser(
    this.id,
    this.name,
    this.role,
    this.attendents,
  );
  static setmyLocationStream(String journeyId) async {
    //Listen to changes on my location, and send my coordinates to database
    if (sendLocationStream != null) await sendLocationStream.cancel();
    //activeJourneyId = journeyId;
    LocationOptions locationOptions = LocationOptions(
      accuracy: LocationAccuracy.best,
    );
    myLocationObservable = rx.PublishSubject<Map<String, dynamic>>();
    Map<String, dynamic> _myLocation = {'latitude': null, 'longitude': null};
    Geolocator _geolocator = Geolocator();
    sendLocationStream =
        _geolocator.getPositionStream(locationOptions).listen((Position pos) {
      _myLocation = {'latitude': pos.latitude, 'longitude': pos.longitude};
      if (!myLocationObservable.isClosed) myLocationObservable.add(_myLocation);
      _sendUserLocationToDB(pos.latitude, pos.longitude, journeyId);
    });
  }

  static _sendUserLocationToDB(
      //send my coordinates to database
      double latitude,
      double longitude,
      String journeyId) async {
    String uid = Global.user.id;
    if (_allowedToSendCoordinates) {
      _allowedToSendCoordinates = false;
      Timer(Duration(seconds: 5), () {
        _allowedToSendCoordinates = true;
      });

      await Firestore.instance
          .collection('realtimeLocations')
          .document(journeyId)
          .updateData({
        uid: {
          'latitude': latitude,
          'longitude': longitude,
          'time': DateTime.now()
        }
      }).catchError((s) {
        print(s);
      });
      SystemSound.play(SystemSoundType.click);
      print(' my position sentttttt id: $uid  jour: $journeyId ');
    }
  }

  static closeMyLocationObservable() {
    myLocationObservable.close();
  }

  static closeSendLocationtoDBStream() async {
    print('in close locatin stream');
    if (sendLocationStream != null) {
      await sendLocationStream.cancel();
      sendLocationStream = null;
      print('sendLocationStream cancelled');
    }
  }
}
