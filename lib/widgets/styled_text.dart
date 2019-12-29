import 'package:flutter/material.dart';

class StyledText extends StatelessWidget {
  final String text;

  const StyledText(this.text);
  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: TextStyle(
           // color: Colors.teal[600],
           // fontWeight: FontWeight.bold,
            fontSize: 16));
  }
}
