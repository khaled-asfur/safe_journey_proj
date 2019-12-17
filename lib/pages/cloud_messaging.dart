import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:safe_journey/models/map_user.dart';
import 'package:safe_journey/models/message.dart';

class CloudMessaging extends StatefulWidget {
  @override
  _CloudMessagingState createState() => _CloudMessagingState();
}

class _CloudMessagingState extends State<CloudMessaging> {
  FirebaseMessaging _fcm = FirebaseMessaging();
  String _token = "";
  List<Message> messages = [];

  @override
  void initState() {
    _fcm.onTokenRefresh.listen(sendTokenToServer);
        _fcm.getToken();
        _fcm.subscribeToTopic("all");
        _fcm.configure(
          onMessage: (Map<String, dynamic> message) async {
            print("onMessage: $message");
            MapUser.setmyLocationStream('6003157');
            /*final notification = message['notification'];
            setState(() {
              messages.add(Message(
                  title: notification['title'], body: notification['body']));
            });*/
          },
          onResume: (Map<String, dynamic> message) async {
            print(" on resume $message");
          },
          onLaunch: (Map<String, dynamic> message) async {
            print(" on launch $message");
          },
        );
        _fcm.getToken().then((String token) {
         
          setState(() {
            _token = token;
          });
          _fcm.requestNotificationPermissions();
        });
        super.initState();
      }
    
      @override
      Widget build(BuildContext context) {
         print( " token = $_token");
        return Scaffold(
          body: Center(
              child: ListView(
            children: messages.map(buildMessage).toList(),
          )),
        );
      }
    
      Widget buildMessage(Message message) {
        return ListTile(
          title: Text(message.title),
          subtitle: Text(message.body),
        );
      }
    
      void sendTokenToServer(String fcmTocen) {
        print("Token: $fcmTocen");
  }
}
/*
DATA='{"notification": {"body": "this is a body","title": "this is a title"}, "priority": "high", "data": {"click_action": "FLUTTER_NOTIFICATION_CLICK", "id": "1", "status": "done"}, "to": "/topics/all"}'
curl https://fcm.googleapis.com/fcm/send -H "Content-Type:application/json" -X POST -d "$DATA" -H "Authorization: key=AAAA3-lRzeE:APA91bEQmhn2ZkOIW1ZmfLV-BgaMFHbNpXn_0_sw4RyCZ3_QsPWqrtYvhv2Se3nH8YEnCYlT9lRqgrQPlRY9UlTKEbFwmsOerHwd7ZAxelfDhyDg_0nrHt5VJm628IyA7QLlJpZcHN-k"
*/