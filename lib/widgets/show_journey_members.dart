import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:safe_journey/models/user.dart';
import 'package:safe_journey/widgets/titleText.dart';
import 'package:safe_journey/widgets/user_search_item.dart';

class ShowJourneyMembers extends StatefulWidget {
  final List<String> membersIds;
  final QuerySnapshot allUsers;
  final String journeyId;

  ShowJourneyMembers(this.membersIds, this.allUsers, this.journeyId);

  @override
  _ShowJourneyMembersState createState() => _ShowJourneyMembersState();
}


class _ShowJourneyMembersState extends State<ShowJourneyMembers> {
  
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> searchItemConfig = {
      'icon': Icon(
        Icons.delete,
        size: 30,
        color: Theme.of(context).accentColor,
      ),
      'buttonEnabled': true
    };
    List<UserSearchItem> membersList = [];
    List<User> members = _fillMembersList();
    members.forEach((User member) {
      membersList.add(
          UserSearchItem(member, _deleteMemberFromJourney, searchItemConfig));
    });
    List<Widget> result=[TitleText('Journey Members'),];
    result.addAll(membersList);
    return Column(children: result);
  }

  List<User> _fillMembersList() {
    List<User> journeyMembers = [];
    widget.membersIds.forEach((String userId) {
      DocumentSnapshot userDoc =
          widget.allUsers.documents.firstWhere((DocumentSnapshot document) {
        return document.documentID == userId ? true : false;
      }, orElse: () => null);
      if (userDoc != null) {
        User user = User.fromDocument(userDoc);
        journeyMembers.add(user);
      } else {
        print(
            "this user id '$userId' doesn't belong to any user in the database!");
      }
    });
    return journeyMembers;
  }

  _deleteMemberFromJourney(String memberId) async {
    try {
      widget.membersIds.remove(memberId);
      setState(() {});
      QuerySnapshot snap = await Firestore.instance
          .collection('journey_user')
          .where('userId', isEqualTo: memberId)
          .where('journeyId', isEqualTo: widget.journeyId)
          .getDocuments();
      List attendents = snap.documents[0].data['attendents'];
      String documentId = snap.documents[0].documentID;
      Firestore.instance
          .collection('journey_user')
          .document(documentId)
          .delete();
      attendents.forEach((dynamic att) {
        String attendentId = att.toString();
        _deleteTheDeletedMemberFromUserAttendentsList(memberId, attendentId);
      });
    } catch (error) {
      print("error occured $error");
    }
  }

  _deleteTheDeletedMemberFromUserAttendentsList(
      String deletedMemberId, String attendentId) async {
    try {
      QuerySnapshot snap = await Firestore.instance
          .collection('journey_user')
          .where('userId', isEqualTo: attendentId)
          .where('journeyId', isEqualTo: widget.journeyId)
          .getDocuments();
      String documentId = snap.documents[0].documentID;
      Firestore.instance
          .collection('journey_user')
          .document(documentId)
          .updateData({
        "attendents": FieldValue.arrayRemove([deletedMemberId]),
      });
    } catch (error) {
      print("error occured $error");
    }
  }
}
