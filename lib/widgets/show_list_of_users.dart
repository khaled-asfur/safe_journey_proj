import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:safe_journey/models/user.dart';
import 'package:safe_journey/widgets/empty_result.dart';
import 'package:safe_journey/widgets/titleText.dart';
import 'package:safe_journey/widgets/user_search_item.dart';
import 'package:rxdart/subjects.dart' as rx;

abstract class  ShowListOfUsers extends StatefulWidget {
  final List<String> membersIds;
  final QuerySnapshot allUsers;
  final String journeyId;
  final String title;
  final IconData iconName;
  final rx.PublishSubject<bool> refreshStream = rx.PublishSubject<bool>();
  listButtonPressedFunction(String id);
  closeRefreshStream(){
    refreshStream.close();
  }


  ShowListOfUsers(this.membersIds, this.allUsers, this.journeyId,this.title,this.iconName);

  @override
  _ShowListOfUsersState createState() => _ShowListOfUsersState();
}


 class _ShowListOfUsersState extends State<ShowListOfUsers> {
   callback() {
    setState(() {
    });
}
   
  
  @override
  Widget build(BuildContext context) {
    widget.refreshStream.listen((bool) {
     if (this.mounted) {
        setState(() {});
      }
    });
    Map<String, dynamic> searchItemConfig = {
      'icon': Icon(
        widget.iconName,
        size: 30,
        color: Theme.of(context).accentColor,
      ),
      'buttonEnabled': true
    };
    List<UserSearchItem> membersList = [];
    List<User> members = _fillMembersList();
    members.forEach((User member) {
      membersList.add(
          UserSearchItem(member, widget.listButtonPressedFunction, searchItemConfig));
    });
    List<Widget> result=[TitleText(widget.title),];
    result.addAll(membersList);
    if(widget.membersIds.isEmpty){
      result.add(EmptyResult('nothing'));
    }
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
  @override
  void dispose() {
    widget.closeRefreshStream();
    super.dispose();
  }
   
 
}
