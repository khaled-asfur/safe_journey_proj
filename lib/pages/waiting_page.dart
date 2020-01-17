import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:safe_journey/widgets/titleText.dart';

import '../models/global.dart';
import '../models/helpers.dart';
import '../models/user.dart';

class WaitingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('in waiting build');
    FirebaseAuth.instance.currentUser().then((FirebaseUser currentFBuser) {
      User user = User.empty();
      if (currentFBuser != null) {
        user.getUserData(currentFBuser).then((fetchedSuccessfully) {
          if (fetchedSuccessfully) {
            Navigator.pushReplacementNamed(context, 'homePage');
          } else
            Helpers.showErrorDialog(context, 'error occured');
        });
      } else if (currentFBuser == null && !Global.visitedWaitingPage) {
        print('current user = null go to login');
        Navigator.pushReplacementNamed(context, 'loginPage');
      }
    }).catchError((error) {
      print(error);
    });
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/8),
            child: Image.asset("images/logo.jpg"),
          ),
          TitleText("Loading ..",color: Colors.black54,),
        ],
      ),
    );
  }
}
