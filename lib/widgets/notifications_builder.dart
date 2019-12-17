import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:safe_journey/models/global.dart';
import 'package:safe_journey/models/helpers.dart';
import 'package:safe_journey/models/journey.dart';
import 'package:safe_journey/models/push_notification.dart';
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
                                // ** */
                                notifications.removeAt(index);
                                _addCurrentUserToJourney(notification);
                                removeCurrentUserFrominvitedUsers(notification);
                                notification.deleteNotificationFromFireStore();
                              } else if (notification.type ==
                                  'ATTENDENCE_REQUEST') {
                                _doAttendence(notification, index);
                              } else if (notification.type ==
                                  'PARENT_REQUEST') {
                                
                                _addUserAsParentToSender(notification);
                              } else if (notification.type ==
                                  'JOIN_JOURNEY_REQUEST') {
                                _addUserToJourney(notification);
                              }
                            }),
                            RaisedButton(
                              child: Text('Decline'),
                              onPressed: () {
                                if (notification.type == 'JOURNEY_INVITATION') {
                                  notifications.removeAt(index);
                                  removeCurrentUserFrominvitedUsers(
                                      notification);
                                  notification
                                      .deleteNotificationFromFireStore();
                                } else if (notification.type ==
                                    'ATTENDENCE_REQUEST') {
                                  notifications.removeAt(index);
                                  removeCurrentUserFromPendingAttendents(
                                      notification);

                                  notification
                                      .deleteNotificationFromFireStore();
                                } else if (notification.type ==
                                    'PARENT_REQUEST') {
                                  notifications.removeAt(index);
                                  removeCurrentUserFromPendingAttendents(
                                      notification);
                                  notification
                                      .deleteNotificationFromFireStore();
                                } else if (notification.type ==
                                    'JOIN_JOURNEY_REQUEST') {
                                  notifications.removeAt(index);
                                  Journey
                                      .removeUserFromUsersRequestedToJoinJourney(
                                          notification);
                                  notification
                                      .deleteNotificationFromFireStore();
                                }

                                //add data to users_journeis collection
                                //remove from attendents array on journey collection
                              },
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
  _addUserToJourney(MyNotification notification) async {
    bool result = false;
    result = await Journey.addUserJourneyDocument(
        notification.senderId, 'USER', notification.journeyId);
    result =
        await Journey.removeUserFromUsersRequestedToJoinJourney(notification);
    if (result == true) {
      notification.deleteNotificationFromFireStore();
      PushNotification.subscribeToCloudMessagingTopic(notification.journeyId);
      String userName = Global.user.name;
      PushNotification.sendNotificationToUser(
          notification.senderId,
          'You are accepted to join journey ${notification.journeyName} ',
          "Hey ${notification.senderName}, $userName accepted your request to join the journey \" ${notification.journeyName} \" ");
    }
  }

  void _addCurrentUserToJourney(MyNotification notification) {
    Firestore.instance.collection('journey_user').add({
      'userId': Global.user.id,
      'journeyId': notification.journeyId,
      'role': 'USER',
      'attendents': [],
      'pendingAttendents': [],
    });
    PushNotification.subscribeToCloudMessagingTopic(notification.journeyId);
    String userName = Global.user.name;
    PushNotification.sendNotificationToUser(
        notification.senderId,
        '$userName accepted your invitation!',
        "Hey ${notification.senderName}, $userName acepted your invitation to \" ${notification.journeyName} \" ");
  }

  Future<bool> removeCurrentUserFrominvitedUsers(MyNotification not) async {
    bool succeeded = false;
    try {
      await Firestore.instance
          .collection('journies')
          .document(not.journeyId)
          .updateData({
        'invitedUsers': FieldValue.arrayRemove([Global.user.id]),
      });
      succeeded = true;
    } on PlatformException catch (error) {
      succeeded = false;
      print(
          'error occured while removing user${Global.user.name} from ${not.journeyName} invited users');
      print(error);
    }
    return succeeded;
  }

  Future<bool> removeCurrentUserFromPendingAttendents(
      MyNotification not) async {
    bool succeeded = false;
    try {
      QuerySnapshot snapshot = await Firestore.instance
          .collection('journey_user')
          .where('userId', isEqualTo: not.senderId)
          .where('journeyId', isEqualTo: not.journeyId)
          .getDocuments();
      String documentId = snapshot.documents[0].documentID;
      Firestore.instance
          .collection('journey_user')
          .document(documentId)
          .updateData({
        'pendingAttendents': FieldValue.arrayRemove([Global.user.id]),
      });
      succeeded = true;
    } on PlatformException catch (error) {
      succeeded = false;
      print(
          'error occured while removing user${Global.user.name} from pending users of ${not.senderId}  for the journey ${not.journeyName} ');
      print(error);
    }
    return succeeded;
  }

  Future<bool> _doAttendence(MyNotification notification, int index) async {
    notifications.removeAt(index);
    bool x1 = await _addSenderToUserAttendentsList(notification);
    bool x2 = await _addUserToSenderAttendentsList(notification);
    if (x1 && x2) {
      notification.deleteNotificationFromFireStore();
      removeCurrentUserFromPendingAttendents(notification);
      String userName = Global.user.name;
      PushNotification.sendNotificationToUser(
          notification.senderId,
          '$userName accepted to be youe attendent',
          "Hey ${notification.senderName}, $userName accepted to be your attendent in journey \" ${notification.journeyName} \" ");

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
    try {
      var snapshot = await Firestore.instance
          .collection('journey_user')
          .where('userId', isEqualTo: not.senderId)
          .where('journeyId', isEqualTo: not.journeyId)
          .limit(1)
          .getDocuments();
      if (snapshot.documents.length > 0) {
        String documentId = snapshot.documents[0].documentID;
        await Firestore.instance
            .collection('journey_user')
            .document(documentId)
            .updateData({
          'attendents': FieldValue.arrayUnion([Global.user.id]),
        }).then((void x) {
          result = true;
        });
      }
    } catch (e) {
      print('An error occured +$e');
    }
    return result;
  }

  Future<bool> _addUserAsParentToSender(MyNotification not) async {
    bool result = false;
    String documentId =
        await _getJourneyUserDocument(Global.user.id, not.journeyId);
    if (documentId != "NO_DOCUMENTS_FOUND") {
      //add the child id to the parent attendents
      result = await _addUserToAttendents(documentId, not.senderId);
    } else {
      //the parent has no previous children and doesn`t join the journey
      result = await Journey.addUserJourneyDocument(
          Global.user.id, 'PARENT', not.journeyId,
          attendents: [not.senderId]);
    }
    if (result == true) {
      not.deleteNotificationFromFireStore();
      removeCurrentUserFromPendingAttendents(not);
      String userName = Global.user.name;
      PushNotification.sendNotificationToUser(
          not.senderId,
          '$userName accepted to be your parent',
          "Hey ${not.senderName}, $userName accepted to be your attendent in journey \" ${not.journeyName} \" ");

      return true;
    }
    Helpers.showErrorDialog(
        context, 'failed to make you a parent for this user');
    return result;
  }

  Future<bool> _addUserToAttendents(
      String documentId, String attendentId) async {
    bool result = false;
    try {
      await Firestore.instance
          .collection('journey_user')
          .document(documentId)
          .updateData({
        'attendents': FieldValue.arrayUnion([attendentId]),
      });
      result = true;
    } catch (error) {
      print(error);
    }
    return result;
  }

  Future<String> _getJourneyUserDocument(
      String userId, String journeyId) async {
    Firestore _instance = Firestore.instance;
    String documentId = "NO_DOCUMENTS_FOUND";
    QuerySnapshot snap = await _instance
        .collection('journey_user')
        .where('userId', isEqualTo: userId)
        .where('journeyId', isEqualTo: journeyId)
        .limit(1)
        .getDocuments();
    if (snap.documents.length > 0) {
      documentId = snap.documents[0].documentID;
    }
    return documentId;
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
