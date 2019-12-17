import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:meta/meta.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:safe_journey/models/journey.dart';
import 'package:safe_journey/models/sounds.dart';

import '../models/map_user.dart';

class PushNotification {
  // from 'https://console.firebase.google.com'
  // --> project settings --> cloud messaging --> "Server key"
  static const String serverKey =
      "AAAA3-lRzeE:APA91bEQmhn2ZkOIW1ZmfLV-BgaMFHbNpXn_0_sw4RyCZ3_QsPWqrtYvhv2Se3nH8YEnCYlT9lRqgrQPlRY9UlTKEbFwmsOerHwd7ZAxelfDhyDg_0nrHt5VJm628IyA7QLlJpZcHN-k";
  static final Client client = Client();
  static FirebaseMessaging _fcm = FirebaseMessaging();

  static Future<Response> sendToAll({
    @required String title,
    @required String body,
  }) {
    return sendToTopic(title: title, body: body, topic: 'all');
  }

  static Future<Response> sendToTopic(
      {@required String title,
      @required String body,
      @required String topic,
      String type}) {
    return type == null
        ? sendTo(title: title, body: body, fcmToken: '/topics/$topic')
        : sendTo(
            title: title, body: body, fcmToken: '/topics/$topic', type: type);
  }

  static Future<Response> sendTo(
      {@required String title,
      @required String body,
      @required String fcmToken,
      String type}) {
    return client.post(
      'https://fcm.googleapis.com/fcm/send',
      body: json.encode({
        'notification': {'body': '$body', 'title': '$title'},
        'priority': 'high',
        'click_action': 'FLUTTER_NOTIFICATION_CLICK',
        'data': {
          'click_action': 'FLUTTER_NOTIFICATION_CLICK',
          'id': '1',
          'status': 'done',
          'type': type,
        },
        'to': '$fcmToken',
      }),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverKey',
      },
    );
  }

  static setPushNotificationSettings(BuildContext context) {
    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        _onNotificationRecieved('onMessage', message, context);
      },
      onResume: (Map<String, dynamic> message) async {
        _onNotificationRecieved('onResume', message, context);
      },
      onLaunch: (Map<String, dynamic> message) async {
        _onNotificationRecieved('onLaunch', message, context);
      },
    );
    _fcm.getToken().then((String token) {});
  }

  static _onNotificationRecieved(
      String text, Map<String, dynamic> message, BuildContext context) {
    print("$text: $message");
    final data = message['data'];
    if (data['type'] != null) {
      print('1111111111');
      if (data['type'] == "START_JOURNEY"){
         print('2222222222222');
        MapUser.setmyLocationStream(message['notification']['body']);
        Sounds.playSound('../sounds/start_journey.mp3');
        SnackBar snack=SnackBar(content:Text('journey started by admin'),);
        Scaffold.of(context).showSnackBar(snack);
      }
      else if (data['type'] == "END_JOURNEY"){
         print('33333333');
        MapUser.closeSendLocationtoDBStream();
        Sounds.playSound('../sounds/end_send_location.mp3');
        SnackBar snack=SnackBar(content:Text('journey was ended by admin'),);
        Scaffold.of(context).showSnackBar(snack);
      }
    } else{
      print("data type = null");
      Sounds.playSound('../sounds/notification.mp3');

      Navigator.pushNamed(context, 'notifications');
      
    }
  }

  static subscribeToCloudMessagingTopic(String topic) {
    _fcm.subscribeToTopic(topic);
  }

  static Future<bool> addDeviceTokenToDatabase(String userId) async {
    //add the token of used device to the current user data document in data base
    bool result = true;
    try {
      String token = await _fcm.getToken();
      await Firestore.instance.collection('users').document(userId).updateData({
        'token': token,
      });
    } catch (error) {
      print("error occured while adding device token to database ");
      result = false;
    }
    return result;
  }

  static Future<bool> deleteDeviceTokenFromDatabase(String userId) async {
    //add the token of used device to the current user data document in data base
    bool result = true;
    try {
      await Firestore.instance.collection('users').document(userId).updateData({
        'token': "NO_TOKEN",
      });
    } catch (error) {
      print("error occured while adding device token to database ");
      result = false;
    }
    return result;
  }

  Future<void> subscribeToTobic(String topic) async {
    await _fcm.subscribeToTopic(topic);
  }

  static void subscribeToJourniesNotifications() async {
    //sub scribe to the notifications of all the journies this user was joined
    List<String> journies = await Journey.getJoinedJourniesIds();

    journies.forEach((String journeyId) {
      _fcm.subscribeToTopic(journeyId);
    });
  }

  static void unsubscribeFromJourniesNotifications() async {
    //sub scribe to the notifications of all the journies this user was joined
    List<String> journies = await Journey.getJoinedJourniesIds();

    journies.forEach((String journeyId) {
      _fcm.unsubscribeFromTopic(journeyId);
    });
  }

  static Future<bool> sendNotificationToUser(
      String userId, String notificationTitle, String notificationBody,
      {String type}) async {
    bool result = false;
    try {
      DocumentSnapshot doc =
          await Firestore.instance.collection('users').document(userId).get();
      String token = doc['token'];
      if (token == "NO_TOKEN")
        print("This user is currently not signed in to any device!");
      else {
        type == null
            ? sendTo(
                fcmToken: token,
                title: notificationTitle,
                body: notificationBody,
              )
            : sendTo(
                fcmToken: token,
                title: notificationTitle,
                body: notificationBody,
                type: type);
      }
      result = true;
    } catch (error) {
      print(
          'an error occured while sending notification to user with id= "$userId"');
    }
    return result;
  }
}
