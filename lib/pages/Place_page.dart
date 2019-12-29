import 'package:flutter/material.dart';
import 'package:safe_journey/models/global.dart';
import 'package:safe_journey/widgets/header.dart';
import 'package:safe_journey/widgets/place_details_item.dart';
import 'package:safe_journey/widgets/titleText.dart';

class PlacePage extends StatelessWidget {
  final Map<String, dynamic> place;

  const PlacePage(this.place);
  @override
  Widget build(BuildContext context) {
    Global.currentPageContext = context;
    return Header(
      body: ListView(
        children: <Widget>[
          Image.network(place['imageURL']),
          SizedBox(
            height: 10,
          ),
          TitleText(place['name']),
          Divider(),
          PlaceDetailsItem(
            Icons.location_on,
            place['address'],
          ),
          PlaceDetailsItem(
            Icons.phone_android,
            place['phone'],
          ),
          PlaceDetailsItem(
            Icons.description,
            place['description'],
          ),
        ],
      ),
    );
  }
}
