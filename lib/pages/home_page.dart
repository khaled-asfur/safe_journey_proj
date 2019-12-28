import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:safe_journey/models/global.dart';
import 'package:safe_journey/models/notification.dart';
import 'package:safe_journey/models/user.dart';
//import 'package:safe_journey/widgets/my_raised_button.dart';
import 'package:safe_journey/widgets/titleText.dart';

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
    refreshUserAndJourneyData();
    super.initState();
  }

  Future<bool> fetchJourniesData() async {
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
 Future<bool> refreshUserAndJourneyData()async {
   bool fetchedUserdData=false;
   bool fetchedjourneiesData=false;
  fetchedjourneiesData= await fetchJourniesData();
    FirebaseUser fbUser = await FirebaseAuth.instance.currentUser();
     User user = User.empty();
    fetchedUserdData=await  user.getUserData(fbUser);
    return fetchedUserdData & fetchedjourneiesData;
 }
  @override
  Widget build(BuildContext context) {
    print('in homepage build');
    return Global.user == null
        ? CircularProgressIndicator()
        : Header(
            body: RefreshIndicator(
              onRefresh: () {
                return refreshUserAndJourneyData();
              },
              child: ListView(
               children: <Widget>[
                //   MyRaisedButton("add ",(){//   }),
                  Container(
                      decoration: BoxDecoration(color: Colors.grey[200]),
                      child: MySlideShow()),
                  Container(
                    padding: EdgeInsets.all(10),
                    alignment: Alignment.center,
                    child: TitleText(
                      'Journeys you joined',
                    )
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
