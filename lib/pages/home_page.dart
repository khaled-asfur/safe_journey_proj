import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:safe_journey/models/auth.dart';

//import '../models/auth.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  final Map<String, dynamic> userData = {
    'name': 'fetching..',
    'email': 'fetching..',
    'imageURL':null
  };
  final databaseReference = Firestore.instance;
  @override
  void initState() {
    fillUserData();
    super.initState();
  }

  Future<void> fillUserData() async {
    FirebaseUser user = await Auth().currentUser;
    databaseReference
        .collection("users")
        .document(user.email)
        .get()
        .then((DocumentSnapshot doc) {
      if (doc.exists) {
        print(doc.data);
        setState(() {
          userData['name'] = doc.data['name'];
          userData['email'] = user.email;
          userData['imageURL']=doc.data['imageURL'];
        });
      }
    });
  }

  // Future<String> getUserDataUrl() async {
  //   FirebaseUser user = await Auth().currentUser;
  //   final ref = FirebaseStorage.instance.ref().child(user.email);
  //   var url = await ref.getDownloadURL();
  //   print(url);
  //   return(url);
  // }

  @override
  Widget build(BuildContext context) {
    print('in homepage build');
    //TODO:add slide show
    return Scaffold(
      drawer: buildDrawer(context),
      appBar: new AppBar(
        title: Text("Main page"),
      ),
      body: ListView(
        children: <Widget>[
          Center(child: Text('in the main page')),
        ],
      ),
    );
  }

  Widget buildDrawer(BuildContext context) {
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
            Navigator.pushReplacementNamed(context, '/');
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
    bool havaAvalidUrl=(userData['imageURL']!=null&&userData['imageURL']!='noURL');
    return Center(
        child: Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(vertical: deviceHeight * 0.01),
          child: CircleAvatar(
            radius: deviceWidth * 0.1,
            backgroundImage: havaAvalidUrl==false
            ? AssetImage("images/profile.png")
            :NetworkImage(userData['imageURL'])
          ),
        ),
        Text(userData['name']),
        Text(userData['email'], style: TextStyle(color: Colors.grey))
      ],
    ));
  }
}
