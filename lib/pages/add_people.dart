import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:safe_journey/models/global.dart';
import 'package:safe_journey/models/journey.dart';
import 'dart:async';

import '../widgets/user_search_item.dart';
import '../models/user.dart';
import '../widgets/header.dart';
import '../models/Enum.dart';

class AddPeople extends StatefulWidget {
  Journey _journey ;
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
  @override
  void initState() {
    _fetchAllUsersData();
    _fetchUsersJoinsJourney(widget._journey.id);
    invitedUsers=List();
    
    widget._journey.invitedUsers.forEach((user){
      invitedUsers.add(user);
    });
    print(invitedUsers);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Header(
      body: ListView(
        children: <Widget>[
          buildSearchField(),
          _buildBody(),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (userDocs == null) {
      return Center(child: Text('Please check your internet connection'));
    }
    if (searchItem == null || searchItem == '') {
      //اليوزر ما بحث عن اشي
      return Container();
    } else if (state == FetchState.FETCHING_IN_PROGRESS && searchItem != null) {
      //اذا قاعد بعمل بحث على اشي بس داتا اليوزرز بعدها مش واصلة
      return Center(child: CircularProgressIndicator());
    } else if (state == FetchState.FETCHING_COMPLETED && searchItem != null) {
      //اليوزر عامل بحث وجبت النتيجة بنجاح
      if (userDocs.documents.isEmpty) {
        //لا يوجد يوزرز بالداتا بيس
        return Center(
          child: Text('No users found in the database!'),
        );
      }

      List<UserSearchItem> items = doSearch(searchItem);
      return items.isNotEmpty
          ? Column(children: items)
          : Center(
              child: Text('No users match your search.'),
            );
    }
    return Center(child: Text("Error occured while fetching data"));
  }

  _fetchAllUsersData() async {
    try {
      state = FetchState.FETCHING_IN_PROGRESS;
      QuerySnapshot users = await Firestore.instance
          .collection("users")
          .orderBy('name')
          .getDocuments();
       List<String> usersIDs=await _fetchUsersJoinsJourney(widget._journey.id);
      setState(() {
        usersJoinsThisJourney=usersIDs;
        userDocs = users;
        state = FetchState.FETCHING_COMPLETED;
      });
    } catch (error) {
      state = FetchState.FETCHING_FAILED;
      print(error);
    }
  }

  Future<List<String>> _fetchUsersJoinsJourney(String journeyId) async {
    List<String> usersIDS = [];
    try {
      QuerySnapshot snap = await Firestore.instance
          .collection('journey_user')
          .where('journeyId', isEqualTo: widget._journey.id)
          .getDocuments();
      if (snap.documents.isNotEmpty) {
        snap.documents.forEach((DocumentSnapshot document) {
          usersIDS.add(document['userId']);
        });
      }
    } on PlatformException catch (error) {
      print('error occured while fetching users joins jorney$journeyId');
      print(error);
    }
    return usersIDS;
  }

  List<UserSearchItem> doSearch(String searchValue) {
    searchItem = searchValue;
    List<User> users = _findUsersMatchsearchValue(searchValue, userDocs);
    List<UserSearchItem> userSearchItems = [];
    if (users != null && users.isNotEmpty) {
      users.forEach((User user) {
        UserSearchItem searchItem = UserSearchItem(user,_sendJoinJourneyRequest,invitedUsers,usersJoinsThisJourney);
        userSearchItems.add(searchItem);
      });
    }
    return userSearchItems;
  }
  void _sendJoinJourneyRequest(String userID){
    setState(() {
      invitedUsers.add(userID);
    });
    Firestore.instance.collection('notifications').add(
            {
              'journeyId': widget._journey.id,
              'userId': userID,
              'senderId': Global.user.id,
              'type':'JOURNEY_INVITATION',
              'time':DateTime.now()
            },
          );
          Firestore.instance.collection('journies').document(widget._journey.id)
          .updateData({
        'invitedUsers': FieldValue.arrayUnion([userID]),
      });
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
