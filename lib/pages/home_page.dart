import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:safe_journey/models/global.dart';
import 'package:safe_journey/models/notification.dart';

import '../models/Enum.dart';
import '../widgets/slide_show.dart';
import '../widgets/cards_grid.dart';
import '../widgets/header.dart';
import '../models/journey.dart';

class HomePage extends StatefulWidget {
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
    MyNotification.setNotificationListener();
    doFetch();
    super.initState();
  }

  Future<bool> doFetch() async {
    bool result = false;
    await Journey.fetchJoinedJournies().then((jour) {
      setState(() {
        _loadedJournies = true;

        if (jour['result'] == FetchResult.SUCCESS) {
          _journies = jour['journies'];
          userJoinedJournies = true;
        }
      });
    });
    return result;
  }

  @override
  Widget build(BuildContext context) {
    print('in homepage build');
    return Global.user == null
        ? CircularProgressIndicator()
        : Header(
            body: RefreshIndicator(
              onRefresh: () {
                return doFetch();
              },
              child: ListView(
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
            ),
          );
  }
}
