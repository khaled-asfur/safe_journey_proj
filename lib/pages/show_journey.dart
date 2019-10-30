import 'package:flutter/material.dart';
import '../models/journey.dart';

class ShowJourney extends StatelessWidget {
  final Journey _journey;
  ShowJourney(this._journey);

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_journey.name),
      ),
      body: Center(
          child: Text('Welcome to show journey page of id : ${_journey.id}')),
    );
  }
  
}
