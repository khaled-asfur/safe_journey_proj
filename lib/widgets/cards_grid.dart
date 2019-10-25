//import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class MyCardsGrid extends StatefulWidget {
  final List<Map<String,dynamic>> _journeyDetails;
  final String _pageRoutName;
  
  MyCardsGrid(this._journeyDetails,this._pageRoutName);


  @override
  _MyCardsGridState createState() => _MyCardsGridState();
}

class _MyCardsGridState extends State<MyCardsGrid> {
  @override
  Widget build(BuildContext context) {

    return Container(
            color: Colors.white30,
            child: GridView.count(
                physics: ScrollPhysics(),
                shrinkWrap: true,
                crossAxisCount: 2,
                childAspectRatio: 1.0,
                padding: const EdgeInsets.all(4.0),
                mainAxisSpacing: 4.0,
                crossAxisSpacing: 4.0,
                children: widget._journeyDetails.map((Map<String, dynamic> journey) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                          context, widget._pageRoutName+journey['id']);
                    },
                    child: Card(
                      semanticContainer: true,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Container(
                        alignment: Alignment.bottomCenter,
                        decoration: new BoxDecoration(
                          image: new DecorationImage(
                            image: new NetworkImage(journey['journeyImageURL']),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Container(
                          padding: EdgeInsets.all(5),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.blueGrey[900].withOpacity(0.5),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black38,
                                blurRadius:
                                    9.0, // has the effect of softening the shadow
                                spreadRadius:
                                    10.0, // has the effect of extending the shadow
                                offset: Offset(
                                  10.0, // horizontal, move right 10
                                  0.0, // vertical, move down 10
                                ),
                              )
                            ],
                          ),
                          child: Text(
                            journey['name'],
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      elevation: 5,
                      margin: EdgeInsets.all(10),
                    ),
                  );
                  
                }).toList()),
          );
  }
}