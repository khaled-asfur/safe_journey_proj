import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
          } else {
            Helpers.showErrorDialog(context, 'error occured');
            Navigator.pushReplacementNamed(context, 'loginPage');
          }
        });
      } else if (currentFBuser == null && !Global.visitedWaitingPage) {
        print('current user = null go to login');
        Navigator.pushReplacementNamed(context, 'loginPage');
      }
    }).catchError((error) {
      print(error);
    });
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}