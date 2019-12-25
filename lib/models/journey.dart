import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:flutter/material.dart';

import '../models/global.dart';
import '../models/map_user.dart';
import '../models/notification.dart';
import '../models/Enum.dart';
import '../models/push_notification.dart';

class Journey {
  final String _id;
  final String _name;
  final String _description;
  final DateTime _startTime;
  final DateTime _endTime;
  final String _places;
  final List _invitedUsers;
  final String _role;
  final List _attendents;
  final List _pendingAttendents;
  final String _imageURL;
  final int _distance;

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
      this._imageURL,
      this._distance);
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

  String get places {
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
  int get distance {
    return this._distance;
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
        return {'result': result, 'journies': myJournies};
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
      'places': String,
      'invitedUsers': List(),
      'role': ' ',
      'attendents': List(),
      'pendingAttendents': List(),
      'imageURL': '',
      'allowedDistance' :0
    };
    try {
      if (firestoreDocument != null)
        document = firestoreDocument;
      else {
        QuerySnapshot snapshot = await Firestore.instance
            .collection('journey_user')
            .where('userId', isEqualTo: Global.user.id)
            .where('journeyId', isEqualTo: journeyId)
            .limit(1)
            .getDocuments();
        if (snapshot.documents.isNotEmpty) document = snapshot.documents[0];
      }
      if (document != null) {
        //if no error occured && the journey found
        journey['id'] = document['journeyId'];
        journey['role'] = document['role'];
        journey['attendents'] = document['attendents'];
        journey['pendingAttendents'] = document['pendingAttendents'];
        await _fetchDetailsFromJourniesCollection(
            document['journeyId'], journey);
        journeyObject = _convertMapToJourneyObject(journey);
      }
    } on PlatformException catch (error) {
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
      journey['allowedDistance']=journeyDocument.data['allowedDistance'];
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
        journey['imageURL'],
        journey['allowedDistance'],);
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

  static Future<void> addRealtimeDocumentforJourney(String journeyId) async {
    String userId = Global.user.id;
    try {
      await Firestore.instance
          .collection('realtimeLocations')
          .document(journeyId)
          .setData({
        userId: {'latitude': 0, 'longitude': 0}
      });
    } catch (error) {
      print('error occured while adding the testing document ');
    }
  }

  Future<List<MapUser>> getUsersJoinsJourney() async {
    //fetch the details of the users who joins this journey
    Firestore instance = Firestore.instance;
    List<MapUser> usersjoinsJourney = List<MapUser>();
    try {
      QuerySnapshot snap = await instance.collection('users').getDocuments();
      List<DocumentSnapshot> allUsers = snap.documents;
      QuerySnapshot snapshot = await instance
          .collection('journey_user')
          .where('journeyId', isEqualTo: id)
          .getDocuments();
      if (snapshot.documents.isNotEmpty) {
        snapshot.documents.forEach((DocumentSnapshot document) {
          MapUser user = _getUserInfo(allUsers, document);
          usersjoinsJourney.add(user);
        });
      }
      _setRelations(usersjoinsJourney);
    } on PlatformException catch (error) {
      print('error occured while fetching users joins jorney');
      print(error);
    }
    return usersjoinsJourney;
  }

  MapUser _getUserInfo(
      List<DocumentSnapshot> allUsers, DocumentSnapshot userjourneyDocument) {
    MapUser mapUser;
    String userId = userjourneyDocument['userId'];
    allUsers.forEach((DocumentSnapshot user) {
      if (user.documentID == userId) {
        mapUser = MapUser(userId, user['name'], userjourneyDocument['role'],
            userjourneyDocument['attendents']);
      }
    });
    return mapUser;
  }

  static Future<bool> addUserJourneyDocument(
      String userId, String role, String journeyId,
      {List attendents, List pendingAttendents}) async {
    bool result = false;
    try {
      await Firestore.instance.collection('journey_user').add({
        'userId': userId,
        'journeyId': journeyId,
        'role': role,
        'attendents': attendents != null ? attendents : [],
        'pendingAttendents': pendingAttendents != null ? pendingAttendents : []
      });
      result = true;
    } catch (error) {
      print('error occured while adding user_journey document $error ');
    }
    return result;
  }

  static Future<bool> removeUserFromUsersRequestedToJoinJourney(
      MyNotification notification) async {
    bool succeeded = false;
    try {
      await Firestore.instance
          .collection('journies')
          .document(notification.journeyId)
          .updateData({
        'usersRequestedToJoinJourney':
            FieldValue.arrayRemove([notification.senderId]),
      });
      succeeded = true;
    } on PlatformException catch (error) {
      succeeded = false;
      print(
          'error occured while removing user${notification.senderName} from users requested to join the journey ${notification.journeyName} ');
      print(error);
    }
    return succeeded;
  }

  _setRelations(List<MapUser> usersJoinsJourney) {
    MapUser currentUser = usersJoinsJourney.firstWhere((MapUser user) {
      return user.id == Global.user.id ? true : false;
    });
    usersJoinsJourney.forEach((MapUser user) {
      if (isAttendent(currentUser, user)) user.relation = Relation.ATTENDENT;
    });
  }

  bool isAttendent(MapUser currentUser, MapUser otherUser) {
    String result = currentUser.attendents.firstWhere((element) {
      String attendent = element as String;
      return otherUser.id == attendent ? true : false;
    }, orElse: () {
      return "NOT_CURRENT_USER_ATTENDENT";
    });
    return result == 'NOT_CURRENT_USER_ATTENDENT' ? false : true;
  }

  static Future<List<String>> getJoinedJourniesIds() async {
    //the id`s of journies you not joined as parent
    List<String> journies = [];
    try {
      QuerySnapshot snap = await Firestore.instance
          .collection('journey_user')
          .where('userId', isEqualTo: Global.user.id)
          .getDocuments();
      snap.documents.forEach((DocumentSnapshot doc) {
        if (doc.data['role'] != 'PARENT') journies.add(doc.data['journeyId']);
        print('you joins the journey ${doc.data['journeyId']} ');
      });
    } catch (error) {
      print('error occured while getting the journies this user was joined');
    }
    print(journies);
    return journies;
  }
  static startJourney(String journeyId,BuildContext context) async {
    Response response = await PushNotification.sendToTopic(
        title: "The admin started the journey",
        body: journeyId,
        topic: journeyId,
        type:"START_JOURNEY");
    if (response.statusCode != 200) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content:
            Text('[${response.statusCode}] Error message: ${response.body}'),
      ));
    }
  }
  static endJourney(String journeyId,BuildContext context) async {
    MapUser.closeSendLocationtoDBStream();
    Response response = await PushNotification.sendToTopic(
        title: "The admin stopped the journey",
        body: journeyId,
        topic: journeyId,
        type:"END_JOURNEY");
    if (response.statusCode != 200) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content:
            Text('[${response.statusCode}] Error message: ${response.body}'),
      ));
    }
  }
   


  @override
  String toString() {
    return super.toString() +
        ("  id: $_id -- name: $_name  --description: $_description -- startTime: $_startTime  --endTime: $_endTime -- places: $_places -- invitedUsers: $_invitedUsers -- role: $_role -- attendents: $_attendents -- pendingAttendents: $pendingAttendents--imageURL: $_imageURL ");
  }
}
