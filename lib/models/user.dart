import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/global.dart';

class User {
  String _id;
  String _name;
  String _email;
  String _imageURL;
  String _phoneNumber;
  String _background;
  String _bio;
  FirebaseUser currentFBUser;
  // User(this.id,this.email,this.name,this.imageURL,this.phoneNumber,this.background,this.bio);
  User(FirebaseUser currentFBUser) {
    getUserData(currentFBUser);
  }

  Future<bool> getUserData(FirebaseUser currentFBUser) async {
    bool fetchedDataSuccessfully = false;
    print('in get user data');
    this._email = currentFBUser.email;
   DocumentSnapshot document= await Firestore.instance
        .collection("users")
        .document(currentFBUser.uid)
        .get();
      if (document.exists) {
        print('document exist');
        this._name = document.data['name'];
        this._imageURL = document.data['imageURL'];
        this._phoneNumber = document.data['phoneNumber'];
        this._background = document.data['background'];
        this._bio = document.data['bio'];
        fetchedDataSuccessfully = true;
        Global.user = this;
      }
      
    return fetchedDataSuccessfully;
  }

  String get id {
    return id;
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
}
