import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'auth.dart';

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

  static void showDoneDialog(BuildContext context, String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Done"),
            content: Text(message, style: TextStyle(color: Color(0xFF197278))),
            actions: <Widget>[
              FlatButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                  if(message=="Your Email is update")
                         {
                              Navigator.pushReplacementNamed(context, '/');
                         }
                },
              ),
            ],
          );
        });
  }

  static void showemailDialog(
      BuildContext context, String message, String newemail, emaiuser) {
    var currentpassController1 = new TextEditingController();
    showDialog(
      
        context: context,
        builder: (BuildContext context) {
          
           return   AlertDialog(
             
              title: Text(message),
              content: Column(
                
                children: <Widget>[
                  
                  TextField(
                    controller: currentpassController1,
                    obscureText: true,
                    decoration: InputDecoration(
                      icon: Icon(Icons.lock),
                      labelText: 'current Password',
                    ),
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
              
                DialogButton(
                  onPressed: () {
                    new Auth()
                        .cheak(emaiuser, currentpassController1.text, context)
                        .then((bool result) {
                      if (result == true) {
                        FirebaseAuth.instance
                            .currentUser()
                            .then((FirebaseUser user) {
                          user.updateEmail(newemail);
                        });
                   Navigator.of(context).pop();
                    Helpers.showDoneDialog(context, "Your Email is update");

                      }
                    });
                  },
                  child: Text(
                    "confirm",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ]));

          //////////////////////////////////////////////////////////////////////////////////////////////////////////////
        });
  }
}
