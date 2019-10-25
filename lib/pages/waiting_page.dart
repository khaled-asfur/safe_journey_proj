import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:safe_journey/models/auth.dart';
import 'package:safe_journey/models/global.dart';
import 'package:safe_journey/models/helpers.dart';
import '../models/user.dart';

class WaitingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
     print('in waiting build');
    FirebaseAuth.instance.currentUser().then((FirebaseUser currentFBuser) {
      User user = User.empty();
      if (currentFBuser != null) {
        user.getUserData(currentFBuser).then((fetchedSuccessfully) {
          if (fetchedSuccessfully)
            Navigator.pushReplacementNamed(context, 'homePage');
            else
            Helpers.showErrorDialog(context, 'error occured');
            //Auth().logout(context);
            //Navigator.pushReplacementNamed(context, 'loginPage');
        });
      } else if (currentFBuser == null && !Global.visitedWaitingPage) {
        print('current user = null go to login');
        Navigator.pushReplacementNamed(context, 'loginPage');
      }
    }).catchError((error) {
      print("sdsdsdsdsdsdsdsdsd");
      print(error);
    });
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
