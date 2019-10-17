import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class PeopleList extends StatelessWidget {
 final itemsList = List<String>.generate(10, (n) => "List item $n");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      body: generateItemsList(),
    );
  }

  ListView generateItemsList() {
    return ListView.builder(
        itemCount: itemsList.length,
        itemBuilder: (context, index) {
          return Slidable(
            actionPane: SlidableDrawerActionPane(),
            actionExtentRatio: 0.25,
            child: Container(
              color: Colors.white,
              child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                        'https://image.shutterstock.com/image-photo/bright-spring-view-cameo-island-260nw-1048185397.jpg'),
                  ),
                  title: Text("Name"),
                  subtitle: Text("Id"),
                  onTap: () {},
                ),
            ),
            actions: null,
            secondaryActions: <Widget>[
              IconSlideAction(
                caption: 'More',
                color: Colors.black45,
                icon: Icons.more_horiz,
                onTap: () => null, 
              ),
              IconSlideAction(
                caption: 'Delete',
                color: Colors.red,
                icon: Icons.delete,
                onTap: () => null, 
              ),
            ],
          );
        });
  }}




















/*
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
   body: ListView(
        padding: EdgeInsets.all(0),
        children: [
          ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(
                    'https://image.shutterstock.com/image-photo/bright-spring-view-cameo-island-260nw-1048185397.jpg'),
              ),
              title: Text("Name"),
              subtitle: Text("Id"),
              onTap: () {},
              trailing: RaisedButton(
                textColor: Colors.white,
                color: Colors.blue,
                child: Text("Add"),
                onPressed: () {},
                shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30.0),
                ),
              )),
          new Divider(
            height: 1.0,
            indent: 1.0,
          ),
          ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(
                    'https://image.shutterstock.com/image-photo/bright-spring-view-cameo-island-260nw-1048185397.jpg'),
              ),
              title: Text("Name"),
              subtitle: Text("Id"),
              onTap: () {},
              trailing: RaisedButton(
                textColor: Colors.white,
                color: Colors.blue,
                child: Text("Add"),
                onPressed: () {},
                shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30.0),
                ),
              )),
          new Divider(
            height: 1.0,
            indent: 1.0,
          ),
        ],
      ),);
  }
}*/
