import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/global.dart';
class WaitingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FirebaseAuth.instance.currentUser().then((FirebaseUser user){
      if(user != null){
        Global.currentUser =user;
        Navigator.pushReplacementNamed(context, 'homePage');
      }
      else{
        Navigator.pushReplacementNamed(context, 'loginPage');
      }
    });
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}