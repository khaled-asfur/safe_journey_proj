import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:safe_journey/models/helpers.dart';
import '../models/user.dart';

class WaitingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FirebaseAuth.instance.currentUser().then((FirebaseUser currentFBuser) {
      User user = User(currentFBuser);
      // print(currentFBuser);
      if (currentFBuser != null) {
        user.getUserData(currentFBuser).then((fetchedSuccessfully) {
          if (fetchedSuccessfully)
            Navigator.pushReplacementNamed(context, 'homePage');
            else
            Helpers.showErrorDialog(context, 'error occured');
        });
      } else if (currentFBuser == null) {
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
