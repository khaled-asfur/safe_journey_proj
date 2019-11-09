import 'package:flutter/material.dart';
import 'package:safe_journey/pages/add_attendents.dart';
import 'package:safe_journey/pages/add_people.dart';
import 'package:safe_journey/widgets/my_raised_button.dart';
import '../models/journey.dart';

class ShowJourney extends StatelessWidget {
  final Journey _journey;
  ShowJourney(this._journey);

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_journey.name),
      ),
      body: Column(
        children: <Widget>[
          MyRaisedButton('add people', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (BuildContext context) {
                return AddPeople(_journey);
              }),
            );
          }),
          MyRaisedButton('add attendent', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (BuildContext context) {
                return AddAttendents(_journey);
              }),
            );
          }),
          Center(
            child: Text('Welcome to show journey page of id : ${_journey.id}'),
          ),
        ],
      ),
    );
  }
}
