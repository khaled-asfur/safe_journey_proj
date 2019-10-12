import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class MyNotification {
   String senderId;
   String type;
   String time;
  String senderImageURL;
  String senderName ;
   String journeyName ;
    Firestore fsInstance = Firestore.instance;
  MyNotification(this.senderId, this.type, this.time, this.journeyName);
  Future<void> getSenderData()async{
    try{
   DocumentSnapshot doc= await fsInstance.collection('users').document(senderId).get();

   senderName = doc['name'];
   senderImageURL = doc['imageURL'];
    }on PlatformException catch (e){
      print(e);
    }
  }
}
