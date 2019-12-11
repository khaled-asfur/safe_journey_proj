import '../models/Enum.dart';

class MapUser{
  String id;
  String name;
  String role;
  List attendents;
  double distanceFromCurrentUser;
  Relation relation;// علاقة اليوزر باليوزر الحالي 

  //invoke the super class constructor.. necessary for inheritence
  MapUser(this.id,this.name,this.role,this.attendents, );
}