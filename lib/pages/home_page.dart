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
  List<Journey> _journies;

  bool userJoinedJournies = false;

  @override
  void initState() {
    doFetch();
    super.initState();
  }

  Future<bool> doFetch() async {
    bool result=false;
   await Journey.fetchJoinedJournies().then((jour) {

      print('in then');
      setState(() {
        print('in set state');
        _loadedJournies = true;
        print(jour['result'].toString());
        if (jour['result'] == FetchResult.SUCCESS) {
          _journies = jour['journies'];
          print(_journies.length);
          userJoinedJournies = true;
          
        }
      });
     
    });
     return result;
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
}