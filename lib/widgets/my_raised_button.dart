import 'package:flutter/material.dart';
class MyRaisedButton extends StatefulWidget {
 final  String text;
 final Color color;
 final Function onPressed;
 MyRaisedButton(this.text,this.onPressed,{this.color});

  @override
  _MyRaisedButtonState createState() => _MyRaisedButtonState();
}

class _MyRaisedButtonState extends State<MyRaisedButton> {
  @override
  Widget build(BuildContext context) {
    Color color;
    widget.color==null?color=Theme.of(context).accentColor: color= widget.color;
    return RaisedButton(
      child: Text(widget.text),
      onPressed: widget.onPressed,
      color: color,
      textColor: Colors.white,
    );
  }
}