import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:safe_journey/models/user.dart';

import '../models/helpers.dart';
import '../models/global.dart';

class Auth {
  final FirebaseAuth _instance = FirebaseAuth.instance;
  //true returned means successful operation, false returned
  Future<bool> login(
      String email, String password, BuildContext context) async {
    bool result = false;

    try {
      AuthResult authResult = await _instance.signInWithEmailAndPassword(
          email: email, password: password);

      FirebaseUser currentFBuser = authResult.user;
      User user = User.empty();
      bool dataFitched = await user.getUserData(currentFBuser);
      dataFitched
          ? Navigator.pushReplacementNamed(context, 'homePage')
          : Helpers.showErrorDialog(context, 'error while fetching user data');
          Global.loadingObservable.add(false);
          Global.closeLoadingObservable();
      return dataFitched;
    } catch (e) {
      print(e);
      Helpers.showErrorDialog(context, e.message);
      Global.loadingObservable.add(false);
    }
    return result;
  }

  //true returned means successful operation, otherwise false returned
  Future<bool> logout(BuildContext context) async {
    bool result = false;
    try {
      _instance.signOut();
      Global.user = null;
      return true;
    } on PlatformException catch (e) {
      print(e);
      Helpers.showErrorDialog(context, e.message);
    }
    return result;
  }

  //true returned means successful operation, otherwise false returned
  //1-create new FB user,
  //2- add user information(name, phone number,image url)to FB users collection,using the email for the new document id
  //3- adds the image to firebase storage
  Future<bool> signup(String name, String phoneNumber, String email,
      String password, BuildContext context, File image) async {
    bool result = false;
    try {
      AuthResult authResult = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      

      String imageURL;
      if (image != null) {
        Map<String, dynamic> result = await uploadImage(image, context);
        // print('result from signup= $result');
        if (result['success']) imageURL = result['imageURL'];
      }
      FirebaseUser fbUser = authResult.user;
            User user =
          User(fbUser.uid, email, name, imageURL, phoneNumber, imageURL);
      Global.user = user;
      
      await _addUserInfoToFireStore(
          name: name,
          phoneNumber: phoneNumber,
          email: email,
          imageURL: imageURL,
          );
      result = true;
          Global.loadingObservable.add(false);
          Global.closeLoadingObservable();
      Navigator.pushReplacementNamed(context, 'homePage');
    } on PlatformException catch (e) {
      Global.loadingObservable.add(false);
      print('error occured');
      print(e);
      Helpers.showErrorDialog(context, e.message);
       
    }
    return result;
  }

  //اذا في يوزر عامل لوج ان برجع اليوزر واذا مش عامل لوج ان او صار اكسبشن برجع نل
  Future<FirebaseUser> get currentFBUser async {
    FirebaseUser user;
    try {
      user = await _instance.currentUser();
      return user;
    } catch (e) {
      print('error occured while getting current user');
      return null;
    }
  }

  Future<Map<String, dynamic>> uploadImage(
      File image, BuildContext context) async {
    Map<String, dynamic> result = {'success': false, 'uploadURL': null};
    try {
      User user = Global.user;
      String email;
      if (user == null) {
       FirebaseUser fbuser= await FirebaseAuth.instance.currentUser();
          email = fbuser.email;
      } else
        email = user.email;
      final StorageReference storageRef =
          FirebaseStorage.instance.ref().child(email);
      final StorageUploadTask task = storageRef.putFile(image);
      result['success'] = true;
      result['imageURL'] = await (await task.onComplete).ref.getDownloadURL();
    } catch (e) {
      Helpers.showErrorDialog(context, e.message);
    }
    return result;
  }

  Future<void> _addUserInfoToFireStore(
      {String name, String phoneNumber, String email, String imageURL}) async {
    if (imageURL == null) imageURL = "noURL";
    User user = Global.user;
    final fsInstance = Firestore.instance;
    String userId = user.id;

    fsInstance.collection('users').document(userId).setData({
      'name': name,
      'phoneNumber': phoneNumber,
      'imageURL': imageURL,
      'email': email,
      'bio':'Add your bio',
      'background':imageURL
    });
  }
  Future<bool> doit(String initial, String description, DateTime endTime,
      String name, DateTime startTime, BuildContext context, File image) async {
    bool result = false;
    try {
      /* /* AuthResult authResult = */ await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: name, password: startTime);*/

      // Global.currentUser=await currentUser;
      /*print('curent signed up user =');
          print(Global.currentUser);*/
      String imageURL;
      if (image != null) {
        Map<String, dynamic> result = await uploadImage(image, context);
        // print('result from signup= $result');
        if (result['success']) imageURL = result['imageURL'];
      }

      result = true;
      final fireStoreInstance = Firestore.instance;
      fireStoreInstance.collection('journies').document("$initial").setData({
        'description': description,
        'endTime': endTime,
        'imageURL': imageURL,
        'name': name,
        'startTime': startTime,
      });

//************ */
   User user= Global.user;

 fireStoreInstance.collection('journey_user').document().setData({
        'attendents': [],
        'journeyId': initial,
        'role': "ADMIN",
        'userId': user.id,
        'pendingAttendents':[],
      });



      // Navigator.pushReplacementNamed(context, 'homePage');

    } on PlatformException catch (e) {
      print(e);
      Helpers.showErrorDialog(context, e.message);
    }
    return result;
  }
    Future<void> update(String name, String pio, String phone, String email,
      BuildContext context, File imagepro, File imageback) async {
    try {
      //for profile
      String imageURL;
      if (imagepro != null) {
        Map<String, dynamic> result = await uploadImage(imagepro, context);
        print('result from signup= $result');
        if (result['success']) imageURL = result['imageURL'];
      }
      //for background
      String imageURL1;
      if (imageback != null) {
        Map<String, dynamic> result1 = await uploadback(imageback, context);
        // print('result from signup= $result');
        if (result1['success']) imageURL1 = result1['imageURL'];
      }

      FirebaseUser user = await FirebaseAuth.instance.currentUser();

      user.updateEmail("family_safe@hotmail.com");

      if (imageback != null && imagepro != null) {
        Firestore.instance.collection('users').document(user.uid).updateData({
          "background": imageURL1,
          "bio": pio,
          'imageURL': imageURL,
          'name': name,
          "phoneNumber": phone
        });
      } else if (imageback != null && imagepro == null) {
        Firestore.instance.collection('users').document(user.uid).updateData({
          "background": imageURL1,
          "bio": pio,
          'name': name,
          "phoneNumber": phone
        });
      } else if (imageback == null && imagepro != null) {
        Firestore.instance.collection('users').document(user.uid).updateData({
          "bio": pio,
          'imageURL': imageURL,
          'name': name,
          "phoneNumber": phone
        });
      } else {
        Firestore.instance
            .collection('users')
            .document(user.uid)
            .updateData({"bio": pio, 'name': name, "phoneNumber": phone});
      }

      // Navigator.pushReplacementNamed(context, 'homePage');

    } on PlatformException catch (e) {
      print(e);
      Helpers.showErrorDialog(context, e.message);
    }

  }
    Future<Map<String, dynamic>> uploadback(
      File image, BuildContext context) async {
    Map<String, dynamic> result = {'success': false, 'uploadURL': null};
    try {
      User user = Global.user;
      String email = user.email + "back";
      final StorageReference storageRef =
          FirebaseStorage.instance.ref().child(email);
      final StorageUploadTask task = storageRef.putFile(image);
      result['success'] = true;
      result['imageURL'] = await (await task.onComplete).ref.getDownloadURL();
      // print('complete upload');
      // print(task);
    } catch (e) {
      Helpers.showErrorDialog(context, e.message);
    }
    // print('result= $result');
    return result;
  }
   Future<bool> cheak(
      String email, String password, BuildContext context) async {
    bool result = false;
   
    try {
      /* AuthResult auth0Result = */ await _instance.signInWithEmailAndPassword(
          email: email, password: password);
     // Navigator.pushReplacementNamed(context, 'homePage');
    //  Global.currentUser=await  FirebaseAuth.instance.currentUser();
      /*print('curent logged in user =');
          print(Global.currentUser);*/

      return true;
    } on PlatformException catch (e) {
      print(e);
      Helpers.showErrorDialog(context, "Your Ennterd password is error");
    }
    return result;
  }

}
