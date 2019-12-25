import 'package:flutter/material.dart';

import '../models/auth.dart';
import '../models/global.dart';
import '../models/user.dart';

class MyDrawer extends StatelessWidget {
  final Map<String, dynamic> userData = {
    'name': 'fetching..',
    'email': 'fetching..',
    'imageURL': null,
  };

  MyDrawer();

  Widget build(BuildContext context) {
    fillUserData();

    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    return Drawer(
        child: ListView(
      children: <Widget>[
        AppBar(
          centerTitle: true,
          automaticallyImplyLeading:
              false, //بتحدد اذا بدك يخمن اول عنصر في الليست او لا ، وجودها بخرب الليست مشان هيك عملناها فولس
          title: Text("App sections"),
          actions: <Widget>[],
        ),
        _buildProfile(deviceWidth, deviceHeight),
        Divider(),
        ListTile(
          leading: Icon(Icons.create),
          title: Text("create journey"),
          onTap: () {
            Navigator.pushNamed(context, 'createJourney');
          },
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.settings),
          title: Text("Settings"),
          onTap: () {
            Navigator.pushNamed(context, 'settings');
          },
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.exit_to_app),
          title: Text("Logout"),
          onTap: () {
            Auth().logout(context);
            Navigator.pushReplacementNamed(context, '/');
          },
        ),
        Divider(),
      ],
    ));
  }

  _buildProfile(deviceWidth, deviceHeight) {
    bool havaAvalidUrl = (userData['imageURL'] != null &&
        userData['imageURL'] != 'noURL' &&
        userData['imageURL'] != '');
    return Center(
        child: Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(vertical: deviceHeight * 0.01),
          child: CircleAvatar(
              radius: deviceWidth * 0.1,
              backgroundImage: havaAvalidUrl == false
                  ? AssetImage("images/profile.png")
                  : NetworkImage(userData['imageURL'])),
        ),
        Text(userData['name']),
        Text(userData['email'], style: TextStyle(color: Colors.grey))
      ],
    ));
  }

  fillUserData() {
    User user = Global.user;
    userData['name'] = user.name;
    userData['email'] = user.email;
    userData['imageURL'] = user.imageURL;
  }
}
