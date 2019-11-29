import 'package:flutter/material.dart';
import 'package:safe_journey/models/Enum.dart';
import 'package:safe_journey/models/user.dart';
import 'package:safe_journey/pages/partner.dart';
import 'package:safe_journey/widgets/show_user.dart';
import '../widgets/header.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:safe_journey/models/journey.dart';
import '../widgets/show_user.dart';
import 'dart:async';
import '../models/Enum.dart';

class People extends StatefulWidget {
  Journey _journey;
  People(this._journey);

  @override
  _PeopleState createState() => _PeopleState();
}

class _PeopleState extends State<People> {
  List<String> usersJoinsThisJourney;
  List _users;
  List<User> final_value;
  QuerySnapshot userDocs;
  FetchState state;
  List<ShowUser> showUser = [];
  List<String> usersIDS = [];
  QuerySnapshot userDocs1;

  void initState() {
    _fetchUsers();
    _fetchUsersJoinsThisJourney(widget._journey.id);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Header(
        body: ListView(
      children: <Widget>[_build(), _buildUserList()],
    ));
  }

  Widget _buildUserList() {
    match();
    List<ShowUser> items = showUser;
    if (state == FetchState.FETCHING_IN_PROGRESS) {
      return Center(child: CircularProgressIndicator());
    } else if (items == null) {
      return Center(
        child: Text('No users found in the database!'),
      );
    } else if (state == FetchState.FETCHING_COMPLETED) {
      

      return Column(children: items);
    }
  }

  Widget _build() {
    return SingleChildScrollView(
        child: new Column(children: <Widget>[
      new Container(
          child: new Stack(children: <Widget>[
        new Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.group),
                onPressed: () {
                 Navigator.push(
                    context,
                    MaterialPageRoute<bool>(
                        builder: (BuildContext context) =>
                            People(widget._journey)
                            )
                            );
                },
              ),
              IconButton(
                icon: Icon(Icons.favorite),
               
               onPressed: () {
              
              Navigator.push(
                    context,
                    MaterialPageRoute<bool>(
                        builder: (BuildContext context) =>
                            Partner(widget._journey)
                            )
                            );
              },
              ),
            ]),
      ]))
    ]));
  }

  Future<QuerySnapshot> _fetchUsers() async {
    try {
      state = FetchState.FETCHING_IN_PROGRESS;
      QuerySnapshot users = await Firestore.instance
          .collection("users")
          .orderBy('name')
          .getDocuments();
      List<String> usersIDs =
          await _fetchUsersJoinsThisJourney(widget._journey.id);
      setState(() {
        usersJoinsThisJourney = usersIDs;
        userDocs = users;
      });
    } catch (error) {
      state = FetchState.FETCHING_FAILED;
      print(error);
    }
    return userDocs;
  }

  Future<List<String>> _fetchUsersJoinsThisJourney(String journeyId) async {
    QuerySnapshot snap = await Firestore.instance
        .collection('journey_user')
        .where('journeyId', isEqualTo: journeyId)
        .getDocuments();
    if (snap.documents.isNotEmpty) {
      snap.documents.forEach((DocumentSnapshot document) {
        usersIDS.add(document['userId']);
        //  print("000000");
        // print(usersIDS);
      });
    }

    return usersIDS;
  }

  match() async {
  
    //List<String> userId = await  _fetchUsersJoinsThisJourney(widget._journey.id) ;
    //QuerySnapshot user= await   _fetchUsers();
    // user.documents.forEach((DocumentSnapshot document) {
    userDocs.documents.forEach((DocumentSnapshot document) {
      String id = document.documentID.toLowerCase();
      //userId.forEach((String f){
        print("users");
        print(usersIDS);
      usersIDS.forEach((String f) {
        String userId = f.toLowerCase();
        if (id.contains(userId)) {
          //print(userId);
          User user = User.fromDocument(document);
          ShowUser __user = ShowUser(user,widget._journey);
          showUser.add(__user);
           
           // final_value.add(user);
                              
           }
           });
           
           });
           state = FetchState.FETCHING_COMPLETED;
           }
 }