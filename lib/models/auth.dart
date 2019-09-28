import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/helpers.dart';

class Auth {
  final FirebaseAuth _instance = FirebaseAuth.instance;
  //true returned means successful operation, false returned
  Future<bool> login(
      String email, String password, BuildContext context) async {
    bool result = false;
    try {
      /* AuthResult authResult = */ await _instance.signInWithEmailAndPassword(
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
    bool result = false;
    try {
      _instance.signOut();
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
     /* AuthResult authResult = */await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      String imageURL;
      if (image != null){
        Map<String,dynamic >result = await uploadImage(image, context);
        print('result from signup= $result');
        if(result['success'])
          imageURL=result['imageURL'];
      }

      result = true;
      await _addUserInfoToFireStore(
          name: name, phoneNumber: phoneNumber, email: email,imageURL: imageURL);
          Navigator.pushReplacementNamed(context, 'homePage');
      
    } on PlatformException catch (e) {
      print(e);
      Helpers.showErrorDialog(context, e.message);
    }
    return result;
  }

  //اذا في يوزر عامل لوج ان برجع اليوزر واذا مش عامل لوج ان او صار اكسبشن برجع نل
  Future<FirebaseUser> get currentUser async {
    FirebaseUser user = await _instance.currentUser();
    try {
      return user;
    } catch (e) {
      print('error occured while getting current user');
      return null;
    }
  }

  Future<Map<String,dynamic>> uploadImage(File image, BuildContext context) async {
    Map<String,dynamic>result={
      'success':false,
      'uploadURL':null
    };
    try {
      FirebaseUser user = await Auth().currentUser;
      String email = user.email;
      final StorageReference storageRef =
          FirebaseStorage.instance.ref().child(email);
      final StorageUploadTask task = storageRef.putFile(image);
      result['success']=true;
      result['imageURL'] = await(await task.onComplete).ref.getDownloadURL();
      print('complete upload');
      print(task);
    } catch (e) {
      Helpers.showErrorDialog(context, e.message);
    }
     print('result= $result');
    return result;
   
  }

  Future<void> _addUserInfoToFireStore(
      {String name,
      String phoneNumber,
      String email,
      String imageURL}) async {
        if(imageURL==null)imageURL="noURL";
    FirebaseUser user = await currentUser;
    final fsInstance = Firestore.instance;
    fsInstance.collection('users').document(user.email).setData({
      'name': name,
      'phoneNumber': phoneNumber,
      'imageURL': imageURL,
    });
  }
}
