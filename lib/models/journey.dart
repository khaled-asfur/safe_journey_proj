import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:safe_journey/models/global.dart';

import '../models/Enum.dart';

class Journey {
  final String _id;
  final String _name;
  final String _description;
  final DateTime _startTime;
  final DateTime _endTime;
  final List _places;
  final List _invitedUsers;
  final String _role;
  final List _attendents;
  final List _pendingAttendents;
  final String _imageURL;

  Journey(
      this._id,
      this._name,
      this._description,
      this._startTime,
      this._endTime,
      this._places,
      this._invitedUsers,
      this._role,
      this._attendents,
      this._pendingAttendents,
      this._imageURL);
//fetches the details of all the journies this user is joining now & still not ended yet

  String get id {
    return _id;
  }

  String get name {
    return _name;
  }

  String get description {
    return _description;
  }

  DateTime get startTime {
    return _startTime;
  }

  DateTime get endTime {
    return _endTime;
  }

  List<Object> get places {
    return _places;
  }

  List<Object> get invitedUsers {
    return _invitedUsers;
  }

  String get role {
    return this._role;
  }

  List get attendents {
    return this._attendents;
  }
  List get pendingAttendents {
    return this._pendingAttendents;
  }

  String get imageURL {
    return this._imageURL;
  }

//جلب جميع الرحلات التي انضم لها اليوزر
  static Future<Map<String, dynamic>> fetchJoinedJournies() async {
    FetchResult result;
    List<Journey> myJournies = List<Journey>();

    try {
      QuerySnapshot docs = await Firestore.instance
          .collection('journey_user')
          .where('userId', isEqualTo: Global.user.id)
          .getDocuments();

      List<DocumentSnapshot> allDocuments = docs.documents;
      if (allDocuments.isEmpty) {
        result = FetchResult.EMPTY;
      }
      for (int i = 0; i < allDocuments.length; i++) {
        Journey jour = await fetchOneJourneyDetails(
            allDocuments[i]['journeyId'],
            firestoreDocument: allDocuments[i]);
        myJournies.add(jour);
      }
      result = FetchResult.SUCCESS;
    } on PlatformException catch (error) {
      print("Error occured while fetching journey details ${error.toString()}");
      result = FetchResult.ERROR_OCCURED;
    }
    return {'result': result, 'journies': myJournies};
  }

//fetch one journey using its journey id..
//if error occured or journey not found, this method returns null
  static Future<Journey> fetchOneJourneyDetails(String journeyId,
      {DocumentSnapshot firestoreDocument}) async {
        Journey journeyObject;
    DocumentSnapshot document;
    Map<String, dynamic> journey = {
      'id': "-1",
      'name': ' ',
      'description': ' ',
      'startTime': DateTime.now(),
      'endTime': DateTime.now(),
      'places': List<String>(),
      'invitedUsers': List<String>(),
      'role': ' ',
      'attendents': List<String>(),
      'pendingAttendents': List<String>(),
      'imageURL': ''
    };
    try{
    if (firestoreDocument != null)
      document = firestoreDocument;
    else {
      QuerySnapshot snapshot = await Firestore.instance
          .collection('journey_user')
          .where('userId', isEqualTo: Global.user.id)
          .limit(1)
          .getDocuments();
      if (snapshot.documents.isNotEmpty) document = snapshot.documents[0];
    }
    if(document!=null){//if no error occured && the journey found
    journey['id'] = document['journeyId'];
    journey['role'] = document['role'];
    journey['attendents'] = document['attendents'];
     journey['pendingAttendents'] = document['pendingAttendents'];
    await _fetchDetailsFromJourniesCollection(document['journeyId'], journey);
    journeyObject = _convertMapToJourneyObject(journey);
    }
    }on PlatformException catch(error ) {
      print('error occured while fetching one journey details');
      print(error);
    }
    return journeyObject;
  }

//****************************************************************************

  static Future<void> _fetchDetailsFromJourniesCollection(
      String journeyId, Map<String, dynamic> journey) async {
    try {
      DocumentSnapshot journeyDocument = await Firestore.instance
          .collection('journies')
          .document(journeyId)
          .get();
      journey['name'] = journeyDocument.data['name'];
      journey['description'] = journeyDocument.data['description'];
      journey['startTime'] = journeyDocument.data['startTime'];
      journey['endTime'] = journeyDocument.data['endTime'];
      journey['imageURL'] = journeyDocument.data['imageURL'];
      journey['places'] = journeyDocument.data['places'];
      journey['invitedUsers'] = journeyDocument.data['invitedUsers'];
    } on PlatformException catch (error) {
      print('An error occured in fetchJourneyDetails method');
      print(error);
    }
  }

//converts the details of the journey from a Map into a journey object
  static Journey _convertMapToJourneyObject(Map<String, dynamic> journey) {
    Journey journeyObj = Journey(
        journey['id'],
        journey['name'],
        journey['description'],
        journey['startTime'].toDate(),
        journey['endTime'].toDate(),
        journey['places'],
        journey['invitedUsers'],
        journey['role'],
        journey['attendents'],
        journey['pendingAttendents'],
        journey['imageURL']);
    return journeyObj;
  }
  static Future<List<String>> fetchUsersJoinsJourney(String journeyId) async {
    List<String> usersIDS = [];
    try {
      QuerySnapshot snap = await Firestore.instance
          .collection('journey_user')
          .where('journeyId', isEqualTo: journeyId)
          .getDocuments();
      if (snap.documents.isNotEmpty) {
        snap.documents.forEach((DocumentSnapshot document) {
          usersIDS.add(document['userId']);
        });
      }
    } on PlatformException catch (error) {
      print('error occured while fetching users joins jorney$journeyId');
      print(error);
    }
    return usersIDS;
  }

  @override
  String toString() {
    return super.toString() +
        ("  id: $_id -- name: $_name  --description: $_description -- startTime: $_startTime  --endTime: $_endTime -- places: $_places -- invitedUsers: $_invitedUsers -- role: $_role -- attendents: $_attendents -- pendingAttendents: $pendingAttendents--imageURL: $_imageURL ");
  }
}
