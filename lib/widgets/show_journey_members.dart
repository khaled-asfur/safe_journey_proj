import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:safe_journey/widgets/show_list_of_users.dart';

class ShowJourneyMembers extends ShowListOfUsers {
  ShowJourneyMembers(
      List<String> membersIds, QuerySnapshot allUsers, String journeyId)
      : super(membersIds, allUsers, journeyId,'Journey members',Icons.delete);

  @override
  listButtonPressedFunction(String memberId) {
    _deleteMemberFromJourney(memberId);
    return null;
  }

  _deleteMemberFromJourney(String memberId) async {
    try {
      super.membersIds.remove(memberId);
      super.refreshStream.add(true);
      QuerySnapshot snap = await Firestore.instance
          .collection('journey_user')
          .where('userId', isEqualTo: memberId)
          .where('journeyId', isEqualTo: super.journeyId)
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
          .where('journeyId', isEqualTo: super.journeyId)
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
