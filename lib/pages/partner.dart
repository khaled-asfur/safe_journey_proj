import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:safe_journey/models/Enum.dart';
import 'package:safe_journey/models/user.dart';
import 'package:safe_journey/pages/people.dart';
//import 'package:safe_journey/widgets/show_user.dart';
import '../widgets/header.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:safe_journey/models/journey.dart';
//import '../widgets/show_user.dart';
import '../widgets/show_partner.dart';
import 'dart:async';
import '../models/Enum.dart';

class Partner extends StatefulWidget{
  final Journey _journey;
  Partner(this._journey);
  @override
 PartnerState createState() => PartnerState();
  
}

class PartnerState extends State<Partner>{
  List<ShowPartner> showUser = [];
  List<String> partnersIDS = [];
  QuerySnapshot userDocs;
  FetchState state;
  
 void initState() {

   _fetchPartners(widget._journey.id);
   _fetchUsers();

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
    List<ShowPartner> items = showUser;
    if (state == FetchState.FETCHING_IN_PROGRESS) {
      return Center(child: CircularProgressIndicator());
    } else if (items == null || items == []) {
      return Center(
        child: Text('No users found in the database!'),
      );
    } else if (state == FetchState.FETCHING_COMPLETED) {
      print("error in line 84");
      print(items);
      return Column(children: items);
    }
    return null;
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

  Future<List<String>> _fetchPartners(String journeyId) async {

    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    QuerySnapshot snap = await Firestore.instance
        .collection('journey_user')
        .where('journeyId', isEqualTo: journeyId).where('userId',isEqualTo:user.uid)
        .getDocuments();
         print("1111111");
    if (snap.documents.isNotEmpty) {
      print("snap is not empty");
      //print(snap);
     //partnersIDS= snap.documents.first['attendents'] as List<String>;
      print(partnersIDS);
     // PartnersIDS = snap.documents[' attendents '] as List<String>;
     snap.documents.forEach((DocumentSnapshot document) {
        partnersIDS=List.from( document['attendents']);
          print("000000");
         print(partnersIDS);
      });
     
    }
     else {
        print("snap empty");
      }
    return partnersIDS;
  }

Future<QuerySnapshot> _fetchUsers() async {
    try {
      state = FetchState.FETCHING_IN_PROGRESS;
      QuerySnapshot users = await Firestore.instance
          .collection("users")
          .orderBy('name')
          .getDocuments();
      
      
          await _fetchPartners(widget._journey.id);
      setState(() {
        
        userDocs = users;
        print(userDocs);
      });
    } catch (error) {
      state = FetchState.FETCHING_FAILED;
      print(error);
    }
    print("from fetch user");
    return userDocs;
  }

 match() async {
    print("hi");
   // _fetchPartners(widget._journey.id);
    //_fetchUsers();

    userDocs.documents.forEach((DocumentSnapshot document) {
      String id = document.documentID.toLowerCase();
      print(id);
      print("======");
      partnersIDS.forEach((String f) {
        String userId = f.toLowerCase();
        if (id.contains(userId)) {
          User user = User.fromDocument(document);
          ShowPartner __user = ShowPartner(user,widget._journey);
            
           showUser.add(__user);
           print("////////////////////////");
           print(showUser);
                              
           }
           });
           });
           state = FetchState.FETCHING_COMPLETED;
           }

 

}