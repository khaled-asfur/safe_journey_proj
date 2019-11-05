import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:safe_journey/models/global.dart';
import 'package:safe_journey/models/helpers.dart';
import 'my_raised_button.dart';
import '../models/notification.dart';

class NotificationsBuilder extends StatefulWidget {
  final AsyncSnapshot<QuerySnapshot> snapshots;

  NotificationsBuilder(this.snapshots);
  @override
  _NotificationsBuilderState createState() => _NotificationsBuilderState();
}

class _NotificationsBuilderState extends State<NotificationsBuilder> {
  List<MyNotification> notifications;
  bool isFetching = false;

  @override
  void initState() {
    notifications = List<MyNotification>();
    _fillNotificationList();
    isFetching = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.snapshots.data.documents.length > 0) {
      //اذا السناب شوت الي وصلت الصفحة فيها داتا
      if (isFetching) return Center(child: CircularProgressIndicator());
      if (notifications.length != widget.snapshots.data.documents.length &&
          !isFetching) {
        _fillNotificationList();
        return Center(child: CircularProgressIndicator());
      } else
        return ListView.builder(
          itemCount: widget.snapshots.data.documents.length,
          itemBuilder: (BuildContext context, int index) {
            MyNotification notification = notifications[index];
            return Card(
                child: Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    height: 100,
                    alignment: Alignment.center,
                    child: Container(
                      child: CircleAvatar(
                          radius: MediaQuery.of(context).size.width * 0.1,
                          backgroundImage: NetworkImage(
                              notification.senderImageURL
                              /*'https://murtahil.com/wp-content/uploads/2018/07/IMG_43073.jpg'*/)),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        notification.buildNotificationText(),
                        Container(
                          child: Text(
                            notification.time.toString(),
                            textAlign: TextAlign.left,
                            style: TextStyle(fontSize: 10),
                          ),
                          alignment: Alignment.centerLeft,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            MyRaisedButton('Accept', () {
                              if (notification.type == 'JOURNEY_INVITATION') {
                                _addCurrentUserToJourney(
                                    notification.journeyId);
                                    notifications.removeAt(index);
                              notification.deleteNotificationFromFireStore();
                              }
                              if (notification.type == 'ATTENDENCE_REQUEST') {
                                _doAttendence(notification, index);
                              }
                              
                              //add data to users_journeis collection
                              //remove from attendents array on journey collection
                            }),
                            RaisedButton(
                              onPressed: () {},
                              child: Text('Decline'),
                            )
                          ],
                        )
                      ]),
                )
              ],
            ));
          },
        );
    }
    return Center(child: Text('You don\'t have any notification'));
  }

  //****************** fUNCTIONS  ******************* */
  _addCurrentUserToJourney(String journeyId) {
    Firestore.instance.collection('journey_user').add({
      'userId': Global.user.id,
      'journeyId': journeyId,
      'role': 'USER',
      'attendents': [],
    });
  }

  Future<bool> _doAttendence(MyNotification notification, int index) async {
    bool x1 = await _addSenderToUserAttendentsList(notification);
    bool x2 = await _addUserToSenderAttendentsList(notification);
    if (x1 && x2) {
      notifications.removeAt(index);
      notification.deleteNotificationFromFireStore();
      return true;
    }
    Helpers.showErrorDialog(context, 'failed to accomplsh attendence');
    return false;
  }

  Future<bool> _addSenderToUserAttendentsList(MyNotification not) async {
    bool result = false;
    var snapshot = await Firestore.instance
        .collection('journey_user')
        .where('userId', isEqualTo: Global.user.id)
        .where('journeyId', isEqualTo: not.journeyId)
        .limit(1)
        .getDocuments();
    if (snapshot.documents.length > 0) {
      String documentId = snapshot.documents[0].documentID;
      print(snapshot.documents[0].documentID);
      await Firestore.instance
          .collection('journey_user')
          .document(documentId)
          .updateData({
        'attendents': FieldValue.arrayUnion([not.senderId]),
      }).then((x) {
        result = true;
      });
    }
    return result;
  }

  _addUserToSenderAttendentsList(MyNotification not) async {
    bool result = false;
    var snapshot = await Firestore.instance
        .collection('journey_user')
        .where('userId', isEqualTo: not.senderId)
        .where('journeyId', isEqualTo: not.journeyId)
        .limit(1)
        .getDocuments();
    if (snapshot.documents.length > 0) {
      String documentId = snapshot.documents[0].documentID;
      print(snapshot.documents[0].documentID);
      await Firestore.instance
          .collection('journey_user')
          .document(documentId)
          .updateData({
        'attendents': FieldValue.arrayUnion([Global.user.id]),
      }).then((void x) {
        result = true;
      });
    }
    return result;
  }

  _fillNotificationList() async {
    int i = 0;
    notifications = List<MyNotification>();
    widget.snapshots.data.documents.forEach((document) {
      MyNotification notification = MyNotification(
          document.documentID,
          document['senderId'],
          document['type'],
          document['time'].toDate(),
          document['journeyId']);
      notification.getSenderData().then((x) {
        notification.getJourneyName(document['journeyId']).then((l) {
          notifications.add(notification);
          i++;
          if (i == widget.snapshots.data.documents.length)
            setState(() {
              isFetching = false;
            });
        });
      });
    });
  }
}
/***
 * add user to invited users
 * add notification to the user notifications
 * 
 */
