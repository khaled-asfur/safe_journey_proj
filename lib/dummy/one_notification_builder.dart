import 'package:flutter/material.dart';
import '../widgets/my_raised_button.dart';
import '../models/notification.dart';

class NotificationsBuilder1 extends StatelessWidget {
  final MyNotification notification;
  NotificationsBuilder1(this.notification);
  /*Future<void> getSenderData()async{
    try{
   DocumentSnapshot doc= await fsInstance.collection('users').document(senderId).get();
   senderName = doc['name'];
   senderImageURL = doc['imageURL'];
    }on PlatformException catch (e){
      print(e);
    }
  }*/
  @override
  Widget build(BuildContext context) {
    print('in notification builder');

    return notification==null
        ? Center(child: Text('notification is empty'))
        :  Card(
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
                                notification.senderImageURL)),
                      ),
                    ),
                  ), //*************** */
                  Expanded(
                    flex: 3,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                         // _buildNotificationText(notification),
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
          
  }
/*
  Widget _buildNotificationText(MyNotification notification) {
    Widget text = Text('error');
    if (notification.type == 'journeyInvitation')
      text = Text(
          '${notification.senderName} added you to is journey \'${notification.journeyName}\' do you want to join it?');
    else if (notification.type == 'attendenceRequest')
      text = Text(
          '${notification.senderName} requested from you to to be his attendent in the  journey \'${notification.journeyName}\' do you accept?');
    return text;
  }*/
}
