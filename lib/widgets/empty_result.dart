import 'package:flutter/material.dart';

class EmptyResult extends StatelessWidget {
  final String text;
  EmptyResult(this.text);
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Container(
      decoration: BoxDecoration(
       // backgroundBlendMode: BlendMode.darken,
//color: Colors.white
      ),
      child: Column(
        children: <Widget>[
          Image.asset(
            'images/empty1.jpg',
            width: double.infinity,
            //height: height /1.8,
            fit: BoxFit.cover,
          ),
          Text(text)
        ],
      ),
    );
  }
}
