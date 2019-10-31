import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class MyNotification {
  String id;
   String senderId;
   String type;
   DateTime time;
  String senderImageURL;
  String senderName ;
   String journeyid ;
   String journeyName;
    Firestore _fsInstance = Firestore.instance;
  MyNotification(this.id,this.senderId, this.type, this.time, this.journeyid);
  
  Future<void> getSenderData()async{
    try{
   DocumentSnapshot doc= await _fsInstance.collection('users').document(senderId).get();

   senderName = doc['name'];
   senderImageURL = doc['imageURL'];
    }on PlatformException catch (e){
      print(e);
    }
  }
  Future<void>getJourneyName(String journeyID)async {
    try{
  DocumentSnapshot doc=await  Firestore.instance.collection('journies').document(journeyID).get();
   this.journeyName= doc.data['name'];
    }catch(error){
      print(error);
    }
    
  }

  Future<bool> deleteNotificationFromFireStore()async{
    bool result=false;
    try{
    await _fsInstance.collection('notifications').document(id).delete();
    result=true;
    }catch(error){
      print(error);
    }
    return result;
  }
}
