import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:meta/meta.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:safe_journey/models/journey.dart';
import 'package:safe_journey/pages/creat.dart';

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
      {@required String title, @required String body, @required String topic}) {
    return sendTo(title: title, body: body, fcmToken: '/topics/$topic');
  }

  static Future<Response> sendTo({
    @required String title,
    @required String body,
    @required String fcmToken,
  }) {
    return client.post(
      'https://fcm.googleapis.com/fcm/send',
      body: json.encode({
        'notification': {'body': '$body', 'title': '$title'},
        'priority': 'high',
        'data': {
          'click_action': 'FLUTTER_NOTIFICATION_CLICK',
          'id': '1',
          'status': 'done',
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
        print("onMessage: $message");
        final notification = message['notification'];
        if (notification['title'] == "Send location notification")
          MapUser.setmyLocationStream(notification['body']);
        else
          Navigator.pushNamed(context, 'notifications');
      },
      onResume: (Map<String, dynamic> message) async {
        //the body has journey id
        final notification = message['notification'];
        if (notification['title'] == "Send location notification")
          MapUser.setmyLocationStream(notification['body']);
        else
          Navigator.pushNamed(context, 'notifications');
        print(" on resume $message");
      },
      onLaunch: (Map<String, dynamic> message) async {
        print(" on launch $message");
        final notification = message['notification'];
        if (notification['title'] == "Send location notification")
          MapUser.setmyLocationStream(notification['body']);
        else
          Navigator.pushNamed(context, 'notifications');
      },
    );
    _fcm.getToken().then((String token) {});
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
      String userId, String notificationTitle, String notificationBody) async {
    bool result = false;
    try {
      DocumentSnapshot doc =
          await Firestore.instance.collection('users').document(userId).get();
      String token = doc['token'];
      if (token == "NO_TOKEN")
        print("This user is currently not signed in to any device!");
      else
        sendTo(
            fcmToken: token, title: notificationTitle, body: notificationBody);
      result = true;
    } catch (error) {
      print(
          'an error occured while sending notification to user with id= "$userId"');
    }
    return result;
  }
}
