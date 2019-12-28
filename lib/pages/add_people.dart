import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:safe_journey/models/global.dart';
import 'package:safe_journey/models/journey.dart';
import 'package:safe_journey/models/push_notification.dart';
import 'package:safe_journey/widgets/show_journey_members.dart';
import 'dart:async';

import '../widgets/user_search_item.dart';
import '../models/user.dart';
import '../widgets/header.dart';
import '../models/Enum.dart';

class AddPeople extends StatefulWidget {
  final Journey _journey;
  AddPeople(this._journey);
  @override
  _AddPeopleState createState() => _AddPeopleState();
}

class _AddPeopleState extends State<AddPeople> {
  List<String> usersJoinsThisJourney;
  QuerySnapshot userDocs;
  FetchState state;
  String searchItem;
  List invitedUsers;
  Journey _journey;
  @override
  void initState() {
    _journey = widget._journey;
    _fetchData();
    super.initState();
  }

  Future<void> _fetchData() async {
    invitedUsers = List();
    _fetchAllUsersData();
    _journey = await Journey.fetchOneJourneyDetails(widget._journey.id);
    if (_journey.invitedUsers != null)
      _journey.invitedUsers.forEach((user) {
        invitedUsers.add(user);
      });
  }

  @override
  Widget build(BuildContext context) {
    return Header(
      body: RefreshIndicator(
        onRefresh: _fetchData,
        child: ListView(
          children: <Widget>[
            buildSearchField(),
            _buildBody(),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (state == FetchState.FETCHING_IN_PROGRESS && searchItem != null) {
      return Center(child: CircularProgressIndicator());
    } else if (userDocs == null) {
      return MyStyledText('Please check your internet connection');
    } /*else if (_journey.role != 'ADMIN') {
      return new MyStyledText(
          'Your role is not \'ADMIN\', so you are not authorized to add users to this journey.');
    } */
    else if (searchItem == null || searchItem == '') {
      //اليوزر ما بحث عن اشي
      return ShowJourneyMembers(
          usersJoinsThisJourney, userDocs, widget._journey.id);
    } else if (state == FetchState.FETCHING_IN_PROGRESS && searchItem != null) {
      //اذا قاعد بعمل بحث على اشي بس داتا اليوزرز بعدها مش واصلة
      return Center(child: CircularProgressIndicator());
    } else if (state == FetchState.FETCHING_COMPLETED && searchItem != null) {
      //اليوزر عامل بحث وجبت النتيجة بنجاح
      if (userDocs.documents.isEmpty) {
        //لا يوجد يوزرز بالداتا بيس
        return MyStyledText('No users found in the database!');
      }

      List<UserSearchItem> items = doSearch(searchItem);
      return items.isNotEmpty
          ? Column(children: items)
          : MyStyledText('No users match your search.');
    }
    return MyStyledText("Error occured while fetching data");
  }

  _fetchAllUsersData() async {
    //fetches the data of all the users in the firebase
    try {
      state = FetchState.FETCHING_IN_PROGRESS;
      QuerySnapshot users = await Firestore.instance
          .collection("users")
          .orderBy('name')
          .getDocuments();
      List<String> usersIDs = await Journey.fetchUsersJoinsJourney(_journey.id);
      setState(() {
        usersJoinsThisJourney = usersIDs;
        userDocs = users;
        state = FetchState.FETCHING_COMPLETED;
      });
    } catch (error) {
      state = FetchState.FETCHING_FAILED;
      print(error);
    }
  }

  List<UserSearchItem> doSearch(String searchValue) {
    searchItem = searchValue;
    List<User> users = _findUsersMatchsearchValue(searchValue, userDocs);
    List<UserSearchItem> userSearchItems = [];
    Map<String, dynamic> searchItemConfig;
    if (users != null && users.isNotEmpty) {
      users.forEach((User user) {
        searchItemConfig =
            _fillSearchItemConfig(user, invitedUsers, usersJoinsThisJourney);
        UserSearchItem searchItem =
            UserSearchItem(user, _sendJoinJourneyRequest, searchItemConfig);
        userSearchItems.add(searchItem);
      });
    }
    return userSearchItems;
  }

  void _sendJoinJourneyRequest(String userID) {
    setState(() {
      invitedUsers.add(userID);
    });
    Firestore.instance.collection('notifications').add(
      {
        'journeyId': _journey.id,
        'userId': userID,
        'senderId': Global.user.id,
        'type': 'JOURNEY_INVITATION',
        'time': DateTime.now()
      },
    );
    Firestore.instance.collection('journies').document(_journey.id).updateData({
      'invitedUsers': FieldValue.arrayUnion([userID]),
    });
    String userName = Global.user.name;
    PushNotification.sendNotificationToUser(userID, 'Journey invitation',
        '$userName invited you to join the journey ${_journey.name}');
  }

  List<User> _findUsersMatchsearchValue(
      String searchValue, QuerySnapshot allUsersDocs) {
    List<User> usersMatchSearch = List<User>();
    allUsersDocs.documents.forEach((DocumentSnapshot document) {
      String userName = document['name'].toLowerCase();
      String userId = document.documentID.toLowerCase();
      String lowerCaseSearchValue = searchValue.toLowerCase();
      if (userName.contains(lowerCaseSearchValue) ||
          userId.contains(lowerCaseSearchValue)) {
        User user = User.fromDocument(document);
        usersMatchSearch.add(user);
      }
    });
    return usersMatchSearch;
  }

  buildSearchField() {
    return Form(
      child: TextFormField(
        decoration: InputDecoration(labelText: 'Search for a user...'),
        onChanged: submit,
      ),
    );
  }

  submit(String value) {
    setState(() {
      searchItem = value;
    });
  }
}

Map<String, dynamic> _fillSearchItemConfig(
    User user, List invitedUsers, List usersJoinsThisJourney) {
  Map<String, dynamic> searchItemConfig = {
    'icon': null,
    'message': '',
    'buttonEnabled': false
  };
  if (invitedUsers != null && invitedUsers.contains(user.id)) {
    searchItemConfig['icon'] = Icon(
      Icons.hourglass_full,
      size: 30,
    );
    searchItemConfig['message'] = 'Invitation was sent before';
  } else if (usersJoinsThisJourney.contains(user.id)) {
    searchItemConfig['icon'] = Icon(
      Icons.done,
      size: 30,
    );
    searchItemConfig['message'] =
        'This user is already a member in this journey';
  } else {
    searchItemConfig['icon'] = Icon(
      Icons.person_add,
      size: 30,
    );
    searchItemConfig['message'] = 'Successfullly sended invitation ';
    searchItemConfig['buttonEnabled'] = true;
  }

  return searchItemConfig;
}

class MyStyledText extends StatelessWidget {
  final String text;
  MyStyledText(this.text);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(10),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.red[900], fontSize: 18),
        ),
      ),
    );
  }
}