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
  String get role{
    return this._role;
  }
  List<String> get attendents{
    return this._attendents;
  }
  String get imageURL{
    return this._imageURL;
  }

//جلب جميع الرحلات التي انضم لها اليوزر
  static Future<Map<String,dynamic>> fetchJoinedJournies() async {
    FetchResult result; 
    List<Journey> myJournies = List<Journey>();
    Map<String, dynamic> journey = {
      'id': " ",
      'name': ' ',
      'description': ' ',
      'startTime': DateTime.now(),
      'endTime': DateTime.now(),
      'places': List<String>(),
      'invitedUsers': List<String>(),
      'role': ' ',
      'attendents': List<String>(),
      'imageURL': ''
    };
    try {
      QuerySnapshot docs = await Firestore.instance
          .collection('journey_user')
          .where('userId', isEqualTo: Global.user.id)
          //.where('endTime',isGreaterThan: DateTime.now())
          .getDocuments();

      List<DocumentSnapshot> allDocuments = docs.documents;
      if (allDocuments.isEmpty) {
        result =FetchResult.EMPTY;
      }
      print(allDocuments.length);
      for(int i=0;i<allDocuments.length;i++){
        DocumentSnapshot doc=allDocuments[i];
        journey['id'] = doc['journeyId'];
        journey['role'] = doc['role'];
        journey['attendents'] = doc['attendents'];
         //fetch the details of each journey
         await _fetchJourneyDetails(doc['journeyId'],journey);
          Journey jour = _convertMapToJourneyObject(journey);
          result=FetchResult.SUCCESS;
          myJournies.add(jour);
      }
    } on PlatformException catch (error) {
      print("Error occured while fetching journey details ${error.toString()}");
      result=FetchResult.ERROR_OCCURED;
    }
    return {
      'result':result,
      'journies':myJournies
    };
  }

//****************************************************************************
//fetch one journey using its journey id
  static Future<void> _fetchJourneyDetails(
      String journeyId,Map<String,dynamic> journey) async {
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
        DateTime.parse(journey['startTime']),
        DateTime.parse(journey['endTime']),
        journey['places'],
        journey['invitedUsers'],
        journey['role'],
        journey['attendents'],
        journey['imageURL']);
    return journeyObj;
  }

  @override
  String toString() {
    return super.toString() +
        ("  id: $_id -- name: $_name  --description: $_description -- startTime: $_startTime  --endTime: $_endTime -- places: $_places -- invitedUsers: $_invitedUsers -- role: $_role -- attendents: $_attendents --imageURL: $_imageURL ");
  }
}
 