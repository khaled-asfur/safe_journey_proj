import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:safe_journey/models/global.dart';
import 'package:safe_journey/widgets/show_list_of_users.dart';

class ShowAttendents extends ShowListOfUsers {
  ShowAttendents(
      List<String> membersIds, QuerySnapshot allUsers, String journeyId)
      : super(membersIds, allUsers, journeyId, "Your attendents",Icons.clear);

  @override
  listButtonPressedFunction(String memberId) {
    super.membersIds.remove(memberId);
    super.refreshStream.add(true);
    removeAttendence(Global.user.id, memberId);
    removeAttendence(memberId, Global.user.id);
    return null;
  }

   removeAttendence(String userId, String attendentId) async {
    try {
      Firestore instance = Firestore.instance;
      QuerySnapshot snap = await instance
          .collection('journey_user')
          .where('userId', isEqualTo: userId)
          .where('journeyId', isEqualTo:  super.journeyId)
          .getDocuments();
      String documentId = snap.documents[0].documentID;
      instance.collection('journey_user').document(documentId).updateData({
        "attendents": FieldValue.arrayRemove([attendentId]),
      });
    } catch (error) {
      print("error occured $error");
    }
  }
}
