import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import '../models/global.dart';

class User {
  String _id;
  String _name = 'user name';
  String _email = 'user email';
  String _imageURL =
      'https://us.123rf.com/450wm/kritchanut/kritchanut1406/kritchanut140600112/29213222-stock-vector-male-silhouette-avatar-profile-picture.jpg?ver=6';
  String _phoneNumber = 'user phone number';
  String _background =
      "https://images.pexels.com/photos/255379/pexels-photo-255379.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500";
  String _bio = "user bio";
  FirebaseUser currentFBUser;
  User(String id, String email, String name,[ String imageURL, String phoneNumber,
      String background, String bio]){
      this._id=id;
      this._email=email;
      this._name=name;
      this._imageURL = imageURL==null||imageURL==''||imageURL=='noURL'
      ?'https://us.123rf.com/450wm/kritchanut/kritchanut1406/kritchanut140600112/29213222-stock-vector-male-silhouette-avatar-profile-picture.jpg?ver=6'
      :imageURL;
      this._phoneNumber = phoneNumber==null||phoneNumber==''
      ?'User phone number'
      :phoneNumber;
      this._background = background==null||background==''
      ?'https://images.pexels.com/photos/255379/pexels-photo-255379.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500'
      :background;
      this._bio = bio==null||bio==''
      ?'User bio'
      :bio;

      }

  User.empty();
  Future<bool> getUserData(FirebaseUser currentFBUser) async {
    this._id = currentFBUser.uid;

    bool fetchedDataSuccessfully = false;
    print('Fetching current user data..');
    this._email = currentFBUser.email;
    try {
      DocumentSnapshot document = await Firestore.instance
          .collection("users")
          .document(currentFBUser.uid)
          .get();
      if (document.exists) {
        this._name = document.data['name'];
        this._imageURL = document.data['imageURL'];
        this._phoneNumber = document.data['phoneNumber'];
        this._background = document.data['background'];
        this._bio = document.data['bio'];
        fetchedDataSuccessfully = true;
        Global.user = this;
        print('User data was fetched successfully');
      }
    } on PlatformException catch (e) {
      print('error occured while fetching user data');
      print(e);
    }

    return fetchedDataSuccessfully;
  }

  factory User.fromDocument(DocumentSnapshot document) {
    return User(
      document.documentID,
      document['email'],
      document['name'],
      document['imageURL'],
      document['phoneNumber'],
      document["background"],
      document['bio'],
    );
  }
  String get id {
    return _id;
  }

  String get name {
    return _name;
  }

  String get email {
    return _email;
  }

  String get imageURL {
    return _imageURL;
  }

  String get phoneNumber {
    return _phoneNumber;
  }

  String get background {
    return _background;
  }

  String get bio {
    return _bio;
  }

  String toString() {
    return "id=${this._id},email=${this._email},name=${this._name},imageURL=${this._imageURL},phone number=${this._phoneNumber},background=${this._background},bio=${this._bio}";
  }
}
