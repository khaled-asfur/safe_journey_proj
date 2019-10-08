import 'package:flutter/material.dart';

class ShowJourney extends StatelessWidget{
  final String placeName;
  ShowJourney(this.placeName);
  Widget build(BuildContext context){
    return Scaffold(appBar: AppBar(title:Text(placeName) ,),
      body: Center(child:Text('Welcome to show journey page of $placeName')),);
  }
}