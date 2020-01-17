import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

import 'package:flutter/material.dart';
import 'package:safe_journey/models/global.dart';

import 'package:rxdart/subjects.dart' as rx;

class MyNotification {
  String id;
  String senderId;
  String type;
  DateTime time;
  String senderImageURL;
  String senderName;
  String journeyId;
  String journeyName;
  Firestore _fsInstance = Firestore.instance;
  MyNotification(this.id, this.senderId, this.type, this.time, this.journeyId);

  Widget buildNotificationText() {
    Widget text = Text('error');
    if (this.type == 'JOURNEY_INVITATION')
      text = Text(
          '${this.senderName} added you to journey \'${this.journeyName}\' do you want to join it?');
    else if (this.type == 'ATTENDENCE_REQUEST')
      text = Text(
          '${this.senderName} requested from you to be his attendent in the  journey \'${this.journeyName}\' do you accept?');
    else if (this.type == 'EXIT_JOURNEY')
      text = Text(
          '${this.senderName} requested from you to leave the journey \'${this.journeyName}\' do you accept?');
    else if (this.type == 'PARENT_REQUEST')
      text = Text(
          '${this.senderName} requested from you to be his parent in the  journey \'${this.journeyName}\' do you accept?');
          else if (this.type == 'JOIN_JOURNEY_REQUEST')
      text = Text(
          '${this.senderName} requested to join the  journey you supervise \'${this.journeyName}\' do you accept?');

    return text;
  }

  Future<void> getSenderData() async {
    try {
      DocumentSnapshot doc =
          await _fsInstance.collection('users').document(senderId).get();

      senderName = doc['name'];
      senderImageURL = doc['imageURL'];
    } on PlatformException catch (e) {
      print(e);
    }
  }

  Future<void> getJourneyName(String journeyID) async {
    try {
      DocumentSnapshot doc = await Firestore.instance
          .collection('journies')
          .document(journeyID)
          .get();
      this.journeyName = doc.data['name'];
    } catch (error) {
      print(error);
    }
  }

  Future<bool> deleteNotificationFromFireStore() async {
    bool result = false;
    try {
      await _fsInstance.collection('notifications').document(id).delete();
      result = true;
    } catch (error) {
      print(error);
    }
    return result;
  }

  static void setNotificationListener() {
    Global.notificationObservable = rx.PublishSubject<int>();
    Firestore.instance
        .collection('notifications')
        .where('userId', isEqualTo: Global.user.id)
        .snapshots()
        .listen((QuerySnapshot snapshot) {
          if(Global.notificationsCount != snapshot.documents.length){
            Global.notificationObservable.add(snapshot.documents.length);
          }
          print(snapshot.documents.length);
          print(Global.notificationsCount);
      Global.notificationsCount = snapshot.documents.length;
      
     // print(snapshot.documents.length);
      /*snapshot.documentChanges.forEach((DocumentChange change) {
      /*  if (change.type == DocumentChangeType.added)
          Global.notificationsCount++;
        else if (change.type == DocumentChangeType.removed)
         if (Global.notificationsCount > 0)
           Global.notificationsCount--;
           print(Global.notificationsCount);*/
      });*/
    });
  }
}
