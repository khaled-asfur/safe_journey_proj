import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:safe_journey/models/journey.dart';
import '../models/user.dart';


class show_partner extends StatelessWidget{
  final User _user;
  final Journey _journey;
 List<String> partnersIDS = [];

  show_partner(this._user,this._journey);
  
  @override
  Widget build(BuildContext context) {
   TextStyle boldStyle = TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
    );
   return GestureDetector(
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(_user.imageURL),
            backgroundColor: Colors.grey,
          ),
          title: Text(_user.name, style: boldStyle),
          subtitle: Text(_user.id),
          trailing: IconButton(
            icon: Icon(Icons.remove),
            disabledColor: Colors.grey[300],
            color: Colors.black, 
            onPressed: () async {
            FirebaseUser user = await FirebaseAuth.instance.currentUser();
    QuerySnapshot snap = await Firestore.instance
        .collection('journey_user')
        .where('journeyId', isEqualTo: _journey.id).where('userId',isEqualTo:user.uid)
        .getDocuments();
      
        String documentId=snap.documents.first.documentID;
        
        
        print(documentId);
        print("partner");
        print(_user.id);
        
             Firestore.instance.collection('journey_user').document(documentId)
          .updateData({
        
        'attendents': FieldValue.arrayRemove([_user.id]),
      });
     },
            
          
          ),
        )

   );
  }
}