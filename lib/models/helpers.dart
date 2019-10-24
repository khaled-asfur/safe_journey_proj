import 'package:flutter/material.dart';
//not staged change

class Helpers {
  static void showErrorDialog(BuildContext context, String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("An error occured"),
            content: Text(message),
            actions: <Widget>[
              FlatButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }
}
