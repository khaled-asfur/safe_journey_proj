import 'package:flutter/material.dart';

class MyRaisedButton extends StatefulWidget {
  final String text;
  final Color color;
  final Function onPressed;
  final bool large;
  MyRaisedButton(this.text, this.onPressed, {this.color, this.large});

  @override
  _MyRaisedButtonState createState() => _MyRaisedButtonState();
}

class _MyRaisedButtonState extends State<MyRaisedButton> {
  @override
  Widget build(BuildContext context) {
    Color color;
    widget.color == null ? color = Color(0xFF197278) : color = widget.color;
    return SizedBox(//150 50
        width:widget.large==null? 100:150,
        height: widget.large==null? 35:50,
        child: RaisedButton(
          child: Text(widget.text),
          onPressed: widget.onPressed,
          color: color,
          // disabledColor: Colors.grey[300],
          textColor: Colors.white,
        ),
        );
  }
}
