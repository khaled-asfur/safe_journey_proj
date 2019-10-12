import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'my_raised_button.dart';
import '../models/notification.dart';

class NotificationsBuilder extends StatefulWidget {
//  final L
  final AsyncSnapshot<QuerySnapshot> snapshots;

  NotificationsBuilder(this.snapshots);
  @override
  _NotificationsBuilderState createState() => _NotificationsBuilderState();
}

class _NotificationsBuilderState extends State<NotificationsBuilder> {
  int _startingDocumentsLength;
  List<MyNotification> notifications;
  bool dataRetrieved;

  @override
  void initState() {
    _startingDocumentsLength = widget.snapshots.data.documents.length;
    print('in initState');
    dataRetrieved = false;
  //  _fillNotificationList();
    super.initState();
  }

  _fillNotificationList() {
    int i = 0;
    dataRetrieved = false;
    notifications = List<MyNotification>();
    widget.snapshots.data.documents.forEach((document) {
      /*  print('in initstate ***************************');
          print(document['type']);
       print(document['senderId']);
          print(document['journeyName']);*/

      MyNotification notification = MyNotification(document['senderId'],
          document['type'], '17/5/2019', document['journeyName']);
      notification.getSenderData().then((x) {
        notifications.add(notification);
        print(
            'index= $i and length = ${widget.snapshots.data.documents.length}');
        i++;
        if (i == widget.snapshots.data.documents.length) {
          setState(() {
            dataRetrieved = true;
            print(dataRetrieved);
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    /* widget.snapshots.data.documentChanges.any((x) {
    //  _fillNotificationList();
    print('document changed');
    });*/

    print('in builder build $dataRetrieved***************************');
    if (widget.snapshots.data.documents.length > 0) {
      if (dataRetrieved == false || _startingDocumentsLength !=
                widget.snapshots.data.documents.length) {
                  _startingDocumentsLength = widget.snapshots.data.documents.length;
        _fillNotificationList();
        return Text('fetching...');
      } else
        return ListView.builder(
          itemCount: widget.snapshots.data.documents.length,
          itemBuilder: (BuildContext context, int index) {
           /* if () {
              _startingDocumentsLength = widget.snapshots.data.documents.length;
              setState(() {
                dataRetrieved = false;
              });
              
             
            }*/
            print(
                'index= $index and length = ${widget.snapshots.data.documents.length} ***');
            print('index= $index and length = ${notifications.length} ***');

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
                            notification.time,
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
                              //delete notification from notifications collection
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
    return Center(child: Text('You don\'t have any notifications'));
  }

  Widget _buildNotificationText(MyNotification notification) {
    Widget text = Text('error');
    if (notification.type == 'journeyInvitation')
      text = Text(
          '${notification.senderName} added you to is journey \'${notification.journeyName}\' do you want to join it?');
    else if (notification.type == 'attendenceRequest')
      text = Text(
          '${notification.senderName} requested from you to to be his attendent in the  journey \'${notification.journeyName}\' do you accept?');
    return text;
  }
}
