import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:safe_journey/models/enum.dart';
import 'package:safe_journey/models/global.dart';

class JourneySearchElement {
  final String photoUrl;
  final String name;
  final String description;
  final DateTime endDate;
  final DateTime startDate;
  final String id;
  List invitedUsers;
  List usersRequestedToJoinJourney;
  UserStateInJourney currentUserStateInJourney;

  JourneySearchElement({
    this.name,
    this.photoUrl,
    this.description,
    this.endDate,
    this.startDate,
    this.id,
    this.invitedUsers,
    this.usersRequestedToJoinJourney,
    this.currentUserStateInJourney,
  });

  factory JourneySearchElement.fromDocument(DocumentSnapshot document) {
    return JourneySearchElement(
      name: document['name'],
      photoUrl: document['imageURL'],
      id: document.documentID,
      description: document['description'],
      startDate: new DateTime.fromMillisecondsSinceEpoch(
          (document["startTime"].millisecondsSinceEpoch)),
      endDate: new DateTime.fromMillisecondsSinceEpoch(
          document["endTime"].millisecondsSinceEpoch),
      invitedUsers: document['invitedUsers'],
      usersRequestedToJoinJourney: document['usersRequestedToJoinJourney'],
      currentUserStateInJourney: document['currentUserStateInJourney'],
    );
  }
  static Future<List<JourneySearchElement>> getUnfinishedJournies() async {
    List allJournies = List<JourneySearchElement>();
    try {
      QuerySnapshot snap = await Firestore.instance
          .collection('journies')
          .where('endTime', isGreaterThanOrEqualTo: DateTime.now())
          .getDocuments();
      snap.documents.forEach((DocumentSnapshot document) {
        JourneySearchElement jour = JourneySearchElement.fromDocument(document);
        allJournies.add(jour);
      });
    } catch (error) {
      print("error ocured while fetching unfinshed journies");
    }
    return allJournies;
  }

  static Future<List<String>> getJourniesUserJoined() async {
    // returns the id's of the journies which this user is a mumber with
    List<String> journiesUserJoined = List<String>();
    try {
      QuerySnapshot snap = await Firestore.instance
          .collection('journey_user')
          .where('userId', isEqualTo: Global.user.id)
          .getDocuments();
      snap.documents.forEach((DocumentSnapshot document) {
        journiesUserJoined.add(document['journeyId']);
      });
    } catch (error) {
      print("error ocured while fetching the journies user joined");
    }
    return journiesUserJoined;
  }

  static List<String> getPendingJournies(
      List<JourneySearchElement> allJournies) {
    List<String> pendingJournies = [];
    allJournies.forEach((JourneySearchElement journey) {
      //check if the user is in the invited users of the journey

      String result = journey.invitedUsers.firstWhere((userId) {
        if (userId == Global.user.id)
          return true;
        else
          return false;
      }, orElse: () => "-1");
      if (result != "-1") pendingJournies.add(journey.id);
      //check if the user is in the users who requested to join the journey
      result = journey.usersRequestedToJoinJourney.firstWhere((userId) {
        if (userId == Global.user.id)
          return true;
        else
          return false;
      }, orElse: () => "-1");
      if (result != "-1") pendingJournies.add(journey.id);
    });
    return pendingJournies;
  }

  static void setUserStateForJournies(List<JourneySearchElement> allJournies,
      List<String> pendingJournies, List<String> joinedJournies) {
    allJournies.forEach((JourneySearchElement journey) {
      if (joinedJournies.contains(journey.id))
        journey.currentUserStateInJourney = UserStateInJourney.JOINED;
      else if (pendingJournies.contains(journey.id))
        journey.currentUserStateInJourney = UserStateInJourney.PENDING;
      else
        journey.currentUserStateInJourney = UserStateInJourney.NOT_JOINED;
    });
  }

  static void sendJoinJourneyRequest(
    String journeyId,
  ) async {
    String adminId = await getJourneyAdminId(journeyId);
    _addCurrentUserToJourneyPendingUsers(journeyId);
    _sendjoinJourneyNotification(journeyId, adminId);
  }

  static void _addCurrentUserToJourneyPendingUsers(String journeyId) {
    try {
      Firestore.instance.collection("journies").document(journeyId).updateData({
        'usersRequestedToJoinJourney': FieldValue.arrayUnion([Global.user.id]),
      });
    } catch (error) {
      print(
          'an error occured while adding user to users who requested to join gourney $error');
    }
  }

  static Future<bool> _sendjoinJourneyNotification(
      String journeyId, String adminId) async {
    bool result = false;
    try {
      await Firestore.instance.collection("notifications").add({
        "journeyId": journeyId,
        "senderId": Global.user.id,
        "time": DateTime.now(),
        "type": "JOIN_JOURNEY_REQUEST",
        "userId": adminId,
      });
      result = true;
    } catch (error) {
      print("error whilt fetching journey admin id $error");
    }
    return result;
  }

  static Future<String> getJourneyAdminId(String journeyId) async {
    String adminId;
    try {
      QuerySnapshot snap = await Firestore.instance
          .collection("journey_user")
          .where('journeyId', isEqualTo: journeyId)
          .getDocuments();
      DocumentSnapshot document =
          snap.documents.firstWhere((DocumentSnapshot doc) {
        return doc.data["role"] == "ADMIN" ? true : false;
      }, orElse: () => null);
      if (document == null) {
        print('the admin of journey with id= $journeyId is not found');
        return null;
      }
      adminId = document['userId'];
    } catch (error) {
      print("error while fetching journey admin id $error");
    }
    return adminId;
  }

  static List<JourneySearchElement> filterSearchResult(
      List<JourneySearchElement> allJournies, String searchValue) {
    List<JourneySearchElement> journiesSatisfiesSearchValue = [];
    String lowerCaseSearchValue = searchValue.toLowerCase();

    allJournies.forEach((JourneySearchElement journey) {
      String journeyName = journey.name.toLowerCase();
      String journeyId = journey.id.toLowerCase();
      if (journeyName.contains(lowerCaseSearchValue) ||
          journeyId.contains(lowerCaseSearchValue)) {
        journiesSatisfiesSearchValue.add(journey);
      }
    });

    return journiesSatisfiesSearchValue;
  }

  @override
  String toString() {
    return super.toString() +
        ("  id: $id -- name: $name  --description: $description -- startTime: $startDate  --endTime: $endDate -- usersRequestedToJoinJourney: $usersRequestedToJoinJourney -- invitedUsers: $invitedUsers -- currentUserStateInJourney: $currentUserStateInJourney --photoUrl: $photoUrl ");
  }
}
