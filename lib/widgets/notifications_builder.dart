import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:safe_journey/models/global.dart';
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
  //bool dataRetrieved;

  @override
  void initState() {
    notifications = List<MyNotification>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('in notification builder build');
    if (widget.snapshots.data.documents.length > 0) {
      //اذا السناب شوت الي وصلت الصفحة فيها داتا
      if (notifications.length != widget.snapshots.data.documents.length) {
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
                ), //*************** */
                Expanded(
                  flex: 3,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        _buildNotificationText(notification),
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
                              notifications.removeAt(index);
                              notification.deleteNotificationFromFireStore();
                              if (notification.type == 'JOURNEY_INVITATION') {
                                Firestore.instance
                                    .collection('journey_user')
                                    .add({
                                  'userId': Global.user.id,
                                  'journeyId': notification.journeyid,
                                  'role': 'USER',
                                  'attendents': [],
                                });
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

  Widget _buildNotificationText(MyNotification notification) {
    Widget text = Text('error');
    if (notification.type == 'JOURNEY_INVITATION')
      text = Text(
          '${notification.senderName} added you to journey \'${notification.journeyName}\' do you want to join it?');
    else if (notification.type == 'ATTENDENCE_REQUEST')
      text = Text(
          '${notification.senderName} requested from you to to be his attendent in the  journey \'${notification.journeyName}\' do you accept?');
    return text;
  }

  _fillNotificationList() async {
    print('in fill notification list');
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
          if (i == widget.snapshots.data.documents.length) setState(() {});
        });
      });
    });
  }
}
