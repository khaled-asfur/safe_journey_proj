import 'package:flutter/material.dart';
import 'package:safe_journey/widgets/styled_text.dart';

class PlaceDetailsItem extends StatelessWidget {
  final IconData icon;
  final String text;

  PlaceDetailsItem(this.icon, this.text);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        SizedBox(
          height: 35,
        ),
        Expanded(
          flex: 1,
          child: Container(
            alignment: Alignment.center,
            child: Icon(
              icon,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
        Expanded(
          flex: 5,
          child: StyledText(
            text,
          ),
        )
      ],
    );
  }
}
