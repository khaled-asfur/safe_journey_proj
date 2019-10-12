import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:safe_journey/models/global.dart';

import '../widgets/drawer.dart';
import '../widgets/slide_show.dart';
//import '../widgets/my_raised_button.dart';

class HomePage extends StatefulWidget {
  //from vs code

  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> journeyDetails = [
    {
      'name': 'Megaland',
      'imageURL':
          'https://murtahil.com/wp-content/uploads/2018/07/IMG_43073.jpg'
    },
    {
      'name': 'Dubai journey',
      'imageURL':
          'https://www.hoteliermiddleeast.com/sites/default/files/hme/styles/full_img/public/images/2018/11/13/JBH1.jpg?itok=P3PfnIHI'
    }
  ];

  final Map<String, dynamic> userData = {
    'name': 'fetching..',
    'email': 'fetching..',
    'imageURL': null
  };
  final databaseReference = Firestore.instance;
  @override
  void initState() {
    fillUserData();
    super.initState();
  }
  Future<void> addDataTofirebaseUnknown()async {
     final fireStoreInstance = Firestore.instance;
     fireStoreInstance.collection('students').add({
      'name': 'ahmad',
      'phoneNumber': 0564444555,
      'age': 15,
      'lol':'loooool'
    });
  }
  Future<void> addDataTofirebaseknown()async {
     final fireStoreInstance = Firestore.instance;
     fireStoreInstance.collection('students').document('3').setData({
      'name': 'ahmad',
      'phoneNumber': 0564444555,
      'age': 15,
      'lol':'loooool'
    });
  }

  @override
  Widget build(BuildContext context) {
    print('in homepage build');
    return Scaffold(
      drawer: MyDrawer(userData),
      appBar: new AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              Navigator.pushNamed(context, 'notifications');
            },
          ),
          IconButton(
            //face .. nature ..perm_identity ..person ..portrait
            icon: Icon(Icons.person),
            onPressed: () {},
          )
        ],
        title: _buildSearchTextField(),
      ),
      body: ListView(
        children: <Widget>[
          //***********
          RaisedButton(
              child: Text('add data to firestore with known id'),
              onPressed: () {
                addDataTofirebaseknown();
              }),
          //***********
           RaisedButton(
              child: Text('add data to firestore without known id'),
              onPressed: () {
               addDataTofirebaseUnknown();
              }),
          //***********
          Container(
              decoration: BoxDecoration(color: Colors.grey[200]),
              child: MySlideShow()),
          Container(
              padding: EdgeInsets.all(10),
              alignment: Alignment.center,
              child: Text(
                'Journeys you joined',
                style: TextStyle(
                    color: Colors.teal[600],
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              )),
          Container(
            color: Colors.white30,
            child: GridView.count(
                physics: ScrollPhysics(),
                shrinkWrap: true,
                crossAxisCount: 2,
                childAspectRatio: 1.0,
                padding: const EdgeInsets.all(4.0),
                mainAxisSpacing: 4.0,
                crossAxisSpacing: 4.0,
                children: journeyDetails.map((Map<String, dynamic> journey) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                          context, '/showJourney/${journey['name']}');
                    },
                    child: Card(
                      semanticContainer: true,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Container(
                        alignment: Alignment.bottomCenter,
                        decoration: new BoxDecoration(
                          image: new DecorationImage(
                            image: new NetworkImage(journey['imageURL']),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Container(
                          padding: EdgeInsets.all(5),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.blueGrey[900].withOpacity(0.5),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black38,
                                blurRadius:
                                    9.0, // has the effect of softening the shadow
                                spreadRadius:
                                    10.0, // has the effect of extending the shadow
                                offset: Offset(
                                  10.0, // horizontal, move right 10
                                  0.0, // vertical, move down 10
                                ),
                              )
                            ],
                          ),
                          child: Text(
                            journey['name'],
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      elevation: 5,
                      margin: EdgeInsets.all(10),
                    ),
                  );
                  /* GridTile(
                      child: new Image.network(journey['imageURL'],
                          fit: BoxFit.cover));*/
                }).toList()),
          ),
          SizedBox(
            height: 30,
          )
        ],
      ),
    );
  }

  Future<void> fillUserData() async {
   FirebaseUser user= Global.currentUser;
  // print(doc.data['name']);
  // print(user);
    databaseReference
        .collection("users")
        .document(user.uid)
        .get()
        .then((DocumentSnapshot doc) {
      if (doc.exists) {
       // print(doc.data);
        setState(() {
          userData['name'] = doc.data['name'];
          userData['email'] = user.email;
          userData['imageURL'] = doc.data['imageURL'];
        });
      }
    });
  }

  Widget _buildSearchTextField() {
    return Container(
      padding: EdgeInsets.all(5),
      child: TextField(
        maxLines: null,
        textAlignVertical: TextAlignVertical.center,
        decoration: new InputDecoration(
          focusColor: Colors.white,

          hintText: "Enter journey name/id",

          filled: true,
          // labelText: "Enter journey name/id",
          fillColor: Colors.white10.withOpacity(0.8),
          enabledBorder: new OutlineInputBorder(
            borderRadius: new BorderRadius.circular(8.0),
            borderSide: new BorderSide(color: Colors.white),
          ),
          //fillColor: Colors.green
        ),
        keyboardType: TextInputType.text,
        style: new TextStyle(
          //color: Colors.white,
          fontSize: 10,
          fontFamily: "Poppins",
        ),
      ),
    );
  }
}
