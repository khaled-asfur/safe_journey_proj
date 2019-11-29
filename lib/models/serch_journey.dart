import 'package:cloud_firestore/cloud_firestore.dart';

class SearchJourny{
  
  
  final String photoUrl;
  final String name;
  final String description;
  final DateTime endDate;
  final DateTime startDate;
  final String id;

  const SearchJourny(
      {this.name,
      this.photoUrl,
      this.description,
      this.endDate,
      this.startDate,
      this.id
    
    });

  factory SearchJourny.fromDocument(DocumentSnapshot document) {
    return SearchJourny(
      
      name: document['name'],
      photoUrl: document['imageURL'],
      id: document.documentID,
      description: document['description'],
      startDate:new DateTime.fromMillisecondsSinceEpoch((document["startTime"].millisecondsSinceEpoch)) ,
      endDate:new DateTime.fromMillisecondsSinceEpoch(document["endTime"].millisecondsSinceEpoch),
 
    );
  }
}
