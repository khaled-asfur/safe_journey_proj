import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import '../models/helpers.dart';

class Auth {
  final FirebaseAuth instance = FirebaseAuth.instance;
 //true returned means successful operation, false returned
  Future<bool> login(String email, String password,BuildContext context) async {
    bool result=false;
    try {
     /* AuthResult authResult = */await instance.signInWithEmailAndPassword(
          email: email, password: password);
          Navigator.pushReplacementNamed(context, 'homePage');
          return true;
    } on PlatformException catch (e) {
      print(e);
      Helpers.showErrorDialog(context, e.message);
    }
    return result;
  }
  //true returned means successful operation, false returned
  Future<bool> logout(BuildContext context) async {

     bool result=false;
    try {
      instance.signOut();
      return true;
    } on PlatformException catch (e) {
      print(e);
      Helpers.showErrorDialog(context, e.message);
    }
    return result;
  }
   //true returned means successful operation, false returned
    Future<bool> signup(String email,String password, BuildContext context) async {
      bool result=false;
    try{
    /*AuthResult authResult =*/ await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
            email: email, password: password);
            Navigator.pushReplacementNamed(context, 'homePage');
            result=true;
    }on PlatformException catch (e) {
      print(e);
      Helpers.showErrorDialog(context, e.message);
    }
    return result;
  }
  //اذا في يوزر عامل لوج ان برجع اليوزر واذا مش عامل لوج ان او صار اكسبشن برجع نل
  Future<FirebaseUser> get currentUser async {
    try {
      return await instance.currentUser();
    } catch (e) {
      print('error occured while getting current user');
      return null;
    }
  }
}
