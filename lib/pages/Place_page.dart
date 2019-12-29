import 'package:flutter/material.dart';
import 'package:safe_journey/models/global.dart';
import 'package:safe_journey/widgets/header.dart';

class PlacePage extends StatelessWidget {
  final Map<String, dynamic> place;

  const PlacePage(this.place);
  @override
  Widget build(BuildContext context) {
    Global.currentPageContext = context;
    return Header(
      body: Column(
        children: <Widget>[
          Text(place['name']),
          Divider(),
          Text(place['description']),
          Divider(),
          Text(place['imageURL']),
          Divider(),
          Text(place['address']),
          Divider(),
        ],
      ),
    );
  }
}
