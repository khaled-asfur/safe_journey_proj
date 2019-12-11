import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:safe_journey/models/global.dart';
import 'package:safe_journey/models/journey.dart';
import 'dart:async';

import '../widgets/user_search_item.dart';
import '../models/user.dart';
import '../widgets/header.dart';
import '../models/Enum.dart';

class AddAttendents extends StatefulWidget {
  final Journey _journey;
  AddAttendents(this._journey);
  @override
  _AddAttendentsState createState() => _AddAttendentsState();
}

class _AddAttendentsState extends State<AddAttendents> {
  List<String> usersJoinsThisJourney;
  QuerySnapshot userDocs;
  FetchState state;
  String searchItem;
  List _pendingAttendents;
  List _attendents;

  Journey _journey;
  Map<String, dynamic> _attendenceSwitch;
  Map<String, dynamic> _parentSwitch;
  bool addingattendents = true;
  @override
  void initState() {
    _attendenceSwitch = {'value': addingattendents, 'title': 'add attendents'};
    _parentSwitch = {'value': !addingattendents, 'title': 'add parents'};
    _journey = widget._journey;
    _fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _attendenceSwitch['value'] = addingattendents;
    _parentSwitch['value'] = !addingattendents;
    return Header(
      body: RefreshIndicator(
        onRefresh: _fetchData,
        child: ListView(
          children: <Widget>[
            _buildSwitch(_attendenceSwitch),
            _buildSwitch(_parentSwitch),
            buildSearchField(),
            _buildBody(),
          ],
        ),
      ),
    );
  }

  Future<void> _fetchData() async {
    _pendingAttendents = List();
    _attendents = List();
    _fetchAllUsersData();
    _journey = await Journey.fetchOneJourneyDetails(widget._journey.id);
    _journey.pendingAttendents.forEach((user) {
      _pendingAttendents.add(user);
    });
    _journey.attendents.forEach((user) {
      _attendents.add(user);
    });
  }

  Widget _buildSwitch(Map<String, dynamic> switchData) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double padding = deviceWidth * 0.25;
    double width = deviceWidth * 0.6;

    return Container(
      width: width,
      alignment: Alignment.topLeft,
      padding: EdgeInsets.only(right: padding),
      child: SwitchListTile(
        value: switchData["value"],
        onChanged: (bool value) {
          setState(() {
            if (switchData["title"] == 'add attendents')
              addingattendents = value;
            else
              addingattendents = !value;
          });
        },
        title: Text(switchData['title']),
      ),
    );
  }

  Widget _buildBody() {
    if (searchItem == null || searchItem == '') {
      //اليوزر ما بحث عن اشي
      return Container();
    } else if (userDocs == null) {
      return Center(child: Text('Please check your internet connection'));
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
    SearchingFor searchingFor =
        addingattendents ? SearchingFor.ATTENDENT : SearchingFor.PARENT;
    List<User> users =
        _findUsersMatchsearchValue(searchValue, userDocs, searchingFor);
    List<UserSearchItem> userSearchItems = [];
    Map<String, dynamic> searchItemConfig;
    if (users != null && users.isNotEmpty) {
      users.forEach((User user) {
        searchItemConfig = _fillAttendentsSearchItemConfig(
            _pendingAttendents, _attendents, user);
        UserSearchItem searchItem =
            UserSearchItem(user, _sendAttendenceRequest, searchItemConfig);
        userSearchItems.add(searchItem);
      });
    }
    return userSearchItems;
  }

  void _sendAttendenceRequest(String userID) {
    setState(() {
      _pendingAttendents.add(userID);
    });
    Firestore.instance.collection('notifications').add(
      {
        'journeyId': _journey.id,
        'userId': userID,
        'senderId': Global.user.id,
        'type':addingattendents?'ATTENDENCE_REQUEST':'PARENT_REQUEST',
        'time': DateTime.now()
      },
    );

    Firestore.instance
        .collection('journey_user')
        .where('userId', isEqualTo: Global.user.id)
        .where('journeyId', isEqualTo: _journey.id)
        .getDocuments()
        .then((QuerySnapshot snap) {
      String journeyUserDocumentID = snap.documents[0].documentID;
      Firestore.instance
          .collection('journey_user')
          .document(journeyUserDocumentID)
          .updateData({
        'pendingAttendents': FieldValue.arrayUnion([userID]),
      });
    });
  }

  List<User> _findUsersMatchsearchValue(String searchValue,
      QuerySnapshot allUsersDocs, SearchingFor searchingFor) {
    List<User> usersMatchSearch = List<User>();
    allUsersDocs.documents.forEach((DocumentSnapshot document) {
      String userId = document.documentID.toLowerCase();
      String userName = document['name'].toLowerCase();
      if (document.documentID != Global.user.id) {//مشان ما اعرض اليوزر الحالي ضمن نتائج البحث
        if (!(searchingFor == SearchingFor.ATTENDENT &&
            !usersJoinsThisJourney.contains(document.documentID))) {
          //اذا كنت بدي اضيف اتندنت رح يضيف بس المشاركين بالرحلة
          String lowerCaseSearchValue = searchValue.toLowerCase();
          if (userName.contains(lowerCaseSearchValue) ||
              userId.contains(lowerCaseSearchValue)) {
            User user = User.fromDocument(document);
            usersMatchSearch.add(user);
          }
        }
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

  Map<String, dynamic> _fillAttendentsSearchItemConfig(
      List pendingAttendents, List attendents, user) {
    Map<String, dynamic> searchItemConfig = {
      'icon': null,
      'message': '',
      'buttonEnabled': false
    };
    if (attendents.contains(user.id)) {
      searchItemConfig['icon'] = Icon(
        Icons.done,
        size: 30,
      );
      searchItemConfig['message'] =
          'This user is already a member in this journey';
    } else if (pendingAttendents != null &&
        pendingAttendents.contains(user.id)) {
      searchItemConfig['icon'] = Icon(
        Icons.hourglass_full,
        size: 30,
      );
      searchItemConfig['message'] = 'Invitation was sent before';
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
}
