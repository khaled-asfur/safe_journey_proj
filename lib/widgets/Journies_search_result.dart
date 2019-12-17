import 'package:flutter/material.dart';
import 'package:safe_journey/models/enum.dart';
import 'package:safe_journey/models/global.dart';
import '../models/journey_search_element.dart';

class JourniesSearchResult extends StatefulWidget {
  final String searchValue;
  final List<JourneySearchElement> allJournies;
  final List<String> joinedJournies;
  final List<String> pendingJournies;
  final Function fetchData;
  JourniesSearchResult(
    this.searchValue,
    this.allJournies,
    this.joinedJournies,
    this.pendingJournies,
    this.fetchData,
  );
  @override
  _JourniesSearchResultState createState() => _JourniesSearchResultState();
}

class _JourniesSearchResultState extends State<JourniesSearchResult> {
  @override
  void initState() {
    super.initState();
    
  }

  List<JourneySearchElement> allJournies;
  List<String> joinedJournies;
  List<String> pendingJournies;
  List<JourneySearchElement> journiesSatisfiesSearchValue;
  String searchValue;

  @override
  Widget build(BuildContext context) {
    searchValue=widget.searchValue;
    allJournies = widget.allJournies;
    joinedJournies = widget.joinedJournies;
    pendingJournies = widget.pendingJournies;
    journiesSatisfiesSearchValue=JourneySearchElement.filterSearchResult(allJournies,searchValue);
    JourneySearchElement.setUserStateForJournies(
        journiesSatisfiesSearchValue, pendingJournies, joinedJournies);
    TextStyle boldStyle = TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
    );
    return RefreshIndicator(
      onRefresh: () {
        // setState(() {});
        return widget.fetchData();
       
      },
      child: ListView.builder(
          itemCount: journiesSatisfiesSearchValue.length,
          itemBuilder: (BuildContext context, int index) {
            JourneySearchElement journey = journiesSatisfiesSearchValue[index];
            return Column(
              children: [
                ListTile(
                  leading: CircleAvatar(
                    radius: 27,
                    backgroundImage: NetworkImage(journey.photoUrl),
                    backgroundColor: Colors.grey,
                  ),
                  title: Text(journey.name, style: boldStyle),
                  subtitle: Text(journey.id),
                  trailing: RaisedButton(
                    textColor: Colors.white,
                    color: Colors.blue,
                    disabledTextColor: Colors.white,
                    child: _buttonLabel(journey),
                    onPressed: journey.currentUserStateInJourney !=
                            UserStateInJourney.NOT_JOINED
                        ? null
                        : () {
                            JourneySearchElement.sendJoinJourneyRequest(
                                journey.id,journey.name);
                            pendingJournies.add(journey.id);
                            Global.pendingJournies.add(journey.id);
                            setState(() {});
                          },
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0),
                    ),
                  ),
                ),
                Divider()
              ],
            );
          }),
    );
  }

  Widget _buttonLabel(JourneySearchElement journey) {
    if (journey.currentUserStateInJourney == UserStateInJourney.JOINED) {
      return Icon(Icons.done);
    } else if (journey.currentUserStateInJourney ==
        UserStateInJourney.PENDING) {
      return Icon(Icons.hourglass_full);
    }
    return Text("Join");
  }
}
