import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:safe_journey/models/global.dart';

import '../models/Enum.dart';
import '../widgets/slide_show.dart';
import '../widgets/cards_grid.dart';
import '../widgets/header.dart';
import '../models/journey.dart';
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
  bool _loadedJournies = false;
  List<Journey> _journies ;
  
  bool userJoinedJournies=false;

  @override
  void initState() {
    Journey.fetchJoinedJournies().then((jour){
       print('in then');
      setState(() {
        print('in set state');
        _loadedJournies=true;
        print(jour['result'].toString());
        if(jour['result']==FetchResult.SUCCESS){
          _journies = jour['journies'];
          print(_journies.length);
          userJoinedJournies =true;
        }
        
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    
    //fetchJoinedJournies();;
    print('in homepage build');
    return Global.user == null
        ? CircularProgressIndicator()
        : Header(
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
                _loadedJournies
                    ? userJoinedJournies
                        ? MyCardsGrid(_journies)
                        : Center(
                            child: Text("You didn't join any journey yet."))
                    : Center(child: CircularProgressIndicator()),
                SizedBox(
                  height: 30,
                )
              ],
            ),
          );
  }
//***********************************  *******************************************
  /*Future<List<Map<String, dynamic>>> fetchJoinedJournies() async {
    List<Map<String, dynamic>> myJournies = List<Map<String, dynamic>>();
    int index = 0;
    try {
      QuerySnapshot docs = await Firestore.instance
          .collection('journey_user')
          .where('userId', isEqualTo: Global.user.id)
          .getDocuments();

      List<DocumentSnapshot> allDocuments = docs.documents;
      if (allDocuments.isEmpty){
        setState(() {
            userJoinedJournies = false;
            _loadedJournies=true;
        });
      
      } 
      allDocuments.forEach((doc) {
        fetchJourneyDetails(doc['journeyId'])
            .then((Map<String, dynamic> details) {
          Map<String, dynamic> journey = {
            'id': doc['userId'],
            'journeyImageURL': details['imageURL'],
            'name': details['name'],
          };
          myJournies.add(journey);
          index++;
          if (index == allDocuments.length) {
            setState(() {
              print('journies was fetched');
              _loadedJournies = true;
              _journies = myJournies;
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
  Future<Map<String, dynamic>> _fetchJourneyDetails(String journeyId) async {
    Map<String, dynamic> journeyDetails = {'imageURL': null, 'name': null};
    try {
      DocumentSnapshot journeyDocument = await Firestore.instance
          .collection('journies')
          .document(journeyId)
          .get();
      journeyDetails['imageURL'] = journeyDocument.data['imageURL'];
      journeyDetails['name'] = journeyDocument.data['name'];
    } catch (error) {
      Helpers.showErrorDialog(context, error.toString());
    }
    return journeyDetails;
  }*/ */
}
