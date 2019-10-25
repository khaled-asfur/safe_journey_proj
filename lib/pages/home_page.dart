import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:safe_journey/models/global.dart';
import 'package:safe_journey/models/helpers.dart';

import '../widgets/drawer.dart';
import '../widgets/slide_show.dart';
import '../widgets/cards_grid.dart';
//import '../widgets/my_raised_button.dart';

class HomePage extends StatefulWidget {
  //from vs code

  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  final databaseReference = Firestore.instance;
  bool _loadedJournies=false;
  List<Map<String, dynamic>> _journies;

  @override
  void initState() {
    fetchJoinedJournies();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('in homepage build');
    return Global.user == null
        ? CircularProgressIndicator()
        : Scaffold(
            drawer: MyDrawer(),
            appBar: new AppBar(
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.notifications),
                  onPressed: () {
                    Navigator.pushNamed(context, 'notifications');
                  },
                ),
                IconButton(
                  icon: Icon(Icons.person),
                  onPressed: () {},
                )
              ],
              title: _buildSearchTextField(),
            ),
            body: ListView(
              children: <Widget>[
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
                  ),
                ),
                _loadedJournies? MyCardsGrid(_journies,'/showJourney/')
                :Center(child:CircularProgressIndicator()),
                SizedBox(
                  height: 30,
                )
              ],
            ),
          );
  }
  //*********************************** functions *******************************************

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
          fillColor: Colors.white10.withOpacity(0.8),
          enabledBorder: new OutlineInputBorder(
            borderRadius: new BorderRadius.circular(8.0),
            borderSide: new BorderSide(color: Colors.white),
          ),
        ),
        keyboardType: TextInputType.text,
        style: new TextStyle(
          fontSize: 10,
          fontFamily: "Poppins",
        ),
      ),
    );
  }
//***********************************  *******************************************
  Future<List<Map<String, dynamic>>> fetchJoinedJournies() async {
    List<Map<String,dynamic>>myJournies=List<Map<String,dynamic>>();
    int index=0;
    try {
      QuerySnapshot docs = await Firestore.instance
          .collection('journey_user')
          .where('userId', isEqualTo: Global.user.id)
          .getDocuments();
      List<DocumentSnapshot> allDocuments=docs.documents;
      allDocuments.forEach((doc) {
        fetchJourneyDetails(doc['journeyId']).then((Map<String, dynamic> details){
          Map<String, dynamic> journey = {
          'id': doc['userId'],
          'journeyImageURL': details['imageURL'],
          'name': details['name'],
        };
        myJournies.add(journey);
        index++;
        if(index==allDocuments.length){
        setState(() {
        _loadedJournies =true;
        _journies=myJournies;
        });
        }
        });
        
      });
    } catch (error) {
      Helpers.showErrorDialog(context, error);
    }
    return myJournies;
  }
//****************************************************************************
  Future<Map<String,dynamic>> fetchJourneyDetails(String journeyId) async {
    Map<String,dynamic> journeyDetails={
      'imageURL':null,
      'name':null
    };
    try {
       DocumentSnapshot journeyDocument = await Firestore.instance
          .collection('journies').document(journeyId).get();
       journeyDetails['imageURL'] = journeyDocument.data['imageURL'];
       journeyDetails['name'] = journeyDocument.data['name'];
    } catch (error) {
      Helpers.showErrorDialog(context, error.toString());
    }
    return journeyDetails;
  }
}
