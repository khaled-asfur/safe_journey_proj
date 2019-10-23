import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:safe_journey/models/user.dart';
import '../models/global.dart';
import '../widgets/notifications_builder.dart';
//TODO:show number of notifications in the main page
//TODO:send notification to the mobile while app isn't running

class Notifications extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('in notification page builder');
    User user = Global.user;
    return Scaffold(
        appBar: AppBar(
          title: Text('Notifications'),
        ),
        body: StreamBuilder(  
          stream: Firestore.instance
              .collection('notifications')
              .where('userId', isEqualTo: user.id)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) return Text('Loading...');
            
            /*MyNotification notification=MyNotification(document['senderId'],document['type'],'17/5/2019',document['journeyName']);
                notification.getSenderData()*/
            return NotificationsBuilder(snapshot);
          },
        ) ,
        floatingActionButton: new FloatingActionButton(
        child: new Icon(Icons.add),
        onPressed: () {
          Firestore.instance.collection('notifications').document().setData(
            {
              'journeyName': 'Al-bathan journey',
              'userId': 'NQxMofkgqibUl9gbUqt25S3ZPMw1',
              'senderId':'X0t4DtD5i5XnlgTzdZuwTzfW1ri1',
              'type':'attendenceRequest'
            },
          );
        },
      )
        );
  }

}
/****
  new ListView(
              children: snapshot.data.documents.map((document) {
                
               
                 /*return Text(
                    "attitude=${document['type']} and lattitude = ${document['userId']}");*/
                   MyNotification notification=MyNotification(document['senderId'],document['type'],'17/5/2019',document['journeyName']);
                notification.getSenderData().then((onValue){
                   return NotificationsBuilder(notification);
                });
               /* MyNotification notificaton=MyNotification(document['senderId'],document['type'],'17/5/2019',document['journeyName']);
              return Text(document['senderId']);*/
              }).toList(),
            );
 */
