import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:safe_journey/models/user.dart';
import 'package:safe_journey/widgets/header.dart';
import '../models/global.dart';
import '../widgets/notifications_builder.dart';
//TODO:show number of notifications in the main page
//TODO:send notification to the mobile while app isn't running

class Notifications extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('in notification page builder');
    User user = Global.user;
    return Header(
        body: StreamBuilder(  
          stream: Firestore.instance
              .collection('notifications')
              .where('userId', isEqualTo: user.id)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) return Text('Loading...');
            return NotificationsBuilder(snapshot);
          },
        ) ,
        floatingActionButton: new FloatingActionButton(
        child: new Icon(Icons.add),
        onPressed: () {
          Firestore.instance.collection('notifications').add(
            {
              'journeyId': 'IHJA4sYuIreak96nQpOP',
              'userId': '3tjm0pfPBGO8kEGJH62tyLjtoF42',
              'senderId':'NQxMofkgqibUl9gbUqt25S3ZPMw1',
              'type':'ATTENDENCE_REQUEST',
              'time':DateTime.now()
            },
          );
        },
      )
        );
  }

}
