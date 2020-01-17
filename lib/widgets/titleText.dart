import 'package:flutter/material.dart';

class TitleText extends StatelessWidget {
  final String text;
  final Color color;

  const TitleText(this.text,{this.color}) ;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
          color: color!=null?color:Colors.teal[600], fontWeight: FontWeight.bold, fontSize: 20),
    );
  }
}
