import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:safe_journey/models/user.dart';
import 'package:safe_journey/widgets/header.dart';
import '../models/global.dart';
import '../widgets/notifications_builder.dart';
//TODO: send notification to the mobile while app isn't running
//TODO: rebuild classes 

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
        ),
        );
  }

}
