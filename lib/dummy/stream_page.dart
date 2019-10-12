import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
 /* @override
  void initState() {
//    Firestore.instance.collection('mountains').document()
//        .setData({ 'title': 'Mount Baker', 'type': 'volcano' });

    super.initState();
  }*/

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Home"),
      ),
      body: new MountainList(),
      floatingActionButton: new FloatingActionButton(
        child: new Icon(Icons.add),
        onPressed: () {
          Firestore.instance.collection('locations').document().setData(
            {
              'attitude': '1457.2',
              'lattitude': '2365.4',
            },
          );
        },
      ),
    );
  }
}

class MountainList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new StreamBuilder(
      stream: Firestore.instance.collection('locations').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) return  Text('Loading...');
        return new ListView(
          children: snapshot.data.documents.map((document) {
            return Text("attitude=${document['attitude']} and lattitude = ${document['lattitude']}");
             /*MyNotification notificaton=MyNotification(document['senderId'],document['type'],'17/5/2019',document['journeyName']);
              return Text(document['senderId']);*/
          }).toList(),
        );
      },
    );
  }
}