import 'package:flutter/material.dart';

class ShowJourney extends StatelessWidget {
  final String _journeyId;
  ShowJourney(this._journeyId);

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_journeyId),
      ),
      body: Center(
          child: Text('Welcome to show journey page of id : $_journeyId')),
    );
  }
  
}
