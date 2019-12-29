import 'package:flutter/material.dart';
import 'package:safe_journey/models/global.dart';

class InfoCard extends StatefulWidget {
  final String text;
  final IconData icon;
 final Function onPressed;

  InfoCard({
    @required this.text,
    @required this.icon,
    this.onPressed,
  });

  @override
  _InfoCardState createState() => _InfoCardState();
}

class _InfoCardState extends State<InfoCard> {
  @override
  Widget build(BuildContext context) {
    Global.currentPageContext = context;
    return GestureDetector(
      onTap: widget.onPressed,
      child: Card(
        color: Colors.white,
        margin: EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
        child: ListTile(
          leading: Icon(
            widget.icon,
            color:Color(0xFF197278) ,
          ),
          title: Text(
            widget.text,
            style: TextStyle(
              fontFamily: 'Source Sans Pro',
              fontSize: 20.0,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}