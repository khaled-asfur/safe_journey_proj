import 'package:flutter/material.dart';
import 'package:safe_journey/models/enum.dart';
import 'package:safe_journey/models/global.dart';
import 'package:safe_journey/models/journey_search_element.dart';
import '../widgets/Journies_search_result.dart';
import 'package:safe_journey/widgets/drawer.dart';
import 'package:safe_journey/widgets/notification_icon.dart';
//import 'package:safe_journey/widgets/user_search_item.dart';

class Header extends StatefulWidget {
  final Widget body;
  final Widget floatingActionButton;

  Header({@required this.body, this.floatingActionButton});

  @override
  _HeaderState createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  var searchController = new TextEditingController();
  String searchValue;
  List<JourneySearchElement> allJournies;
  List<String> joinedJournies;
  List<String> pendingJournies;
  FetchState dataFetchingState;
  @override
  void initState() {
    super.initState();
    dataFetchingState = FetchState.FETCHING_IN_PROGRESS;
    if (Global.allJournies == null)
      fetchData();
    else {
      JourneySearchElement.getNumberOfAllJournies()
          .then((int noOfJourniesOnDatabase) {
            if (noOfJourniesOnDatabase != Global.numberOfcurrentFetchedJournies) {
               fetchData();
        } else {
          allJournies = Global.allJournies;
          joinedJournies = Global.joinedJournies;
          pendingJournies = Global.pendingJournies;
          dataFetchingState = FetchState.FETCHING_COMPLETED;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: new AppBar(
        actions: <Widget>[
          NotificationIcon(),
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              Navigator.pushNamed(context, 'profilePage');
            },
          )
        ],
        title: _buildSearchTextField(),
      ),
      body: (searchController.text.isEmpty)
          ? widget.body
          : dataFetchingState == FetchState.FETCHING_COMPLETED
              ? JourniesSearchResult(
                  searchValue,
                  allJournies,
                  joinedJournies,
                  pendingJournies,
                  fetchData,
                )
              : CircularProgressIndicator(),
      floatingActionButton: this.widget.floatingActionButton == null
          ? null
          : this.widget.floatingActionButton,
    );
  }

  Future<bool> fetchData() async {
    allJournies = await JourneySearchElement.getUnfinishedJournies();
    joinedJournies = await JourneySearchElement.getJourniesUserJoined();
    pendingJournies = JourneySearchElement.getPendingJournies(allJournies);
    Global.allJournies = allJournies;
    Global.joinedJournies = joinedJournies;
    Global.pendingJournies = pendingJournies;
    if (this.mounted) {
      setState(() {
        dataFetchingState = FetchState.FETCHING_COMPLETED;
      });
    }
    return true;
  }

  Widget _buildSearchTextField() {
    return Container(
      padding: EdgeInsets.all(5),
      child: TextField(
        controller: searchController,
        maxLines: null,
        textAlignVertical: TextAlignVertical.center,
        decoration: new InputDecoration(
          prefix: Icon(Icons.search),
          focusColor: Colors.purple,
          hintText: "Enter journey name/id",
          filled: true,
          fillColor: Colors.white10.withOpacity(0.8),
          enabledBorder: new OutlineInputBorder(
            borderRadius: new BorderRadius.circular(8.0),
            borderSide: new BorderSide(color: Colors.white),
          ),
          //fillColor: Colors.green
        ),
        keyboardType: TextInputType.text,
        style: new TextStyle(
          fontSize: 10,
          fontFamily: "Poppins",
        ),
        onChanged: (String txt) {
          setState(() {
            searchValue = txt;
          });
        },
      ),
    );
  }
}
