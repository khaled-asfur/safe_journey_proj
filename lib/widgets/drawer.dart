import 'package:flutter/material.dart';
import 'package:safe_journey/models/auth.dart';


class MyDrawer extends StatelessWidget {
  final Map<String, dynamic> userData;

  MyDrawer(this.userData);

  Widget build(BuildContext context) {
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
            Navigator.pushNamed(context, 'stream');
          },
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.inbox),
          title: Text("Not finished journeis"),
          onTap: () {
            Navigator.pushReplacementNamed(context, '/');
          },
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.add),
          title: Text("Add dangerous area"),
          onTap: () {
            Navigator.pushReplacementNamed(context, '/');
          },
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.settings),
          title: Text("Settings"),
          onTap: () {
            Navigator.pushReplacementNamed(context, '/');
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
    print('user data=');
    print(userData['imageURL']);
    print('user data=');

    bool havaAvalidUrl =
        (userData['imageURL'] != null && userData['imageURL'] != 'noURL');
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
}
