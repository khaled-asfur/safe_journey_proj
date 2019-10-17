import 'package:flutter/material.dart';


  final myController = TextEditingController();

class ChatList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
   return new Scaffold(
      
      //////////////////////////////////////////////////////////////
      body: new Column(
        children: <Widget>[
          new Container(
            color: Colors.white,
            //\child: new Padding(
             padding: const EdgeInsets.all(20.0),
                

              child: new Card(
                shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(25.0),),
                child: new TextField(
                  controller: myController,
                  decoration: InputDecoration(
                    labelText: "Search",
                    hintText: "Search",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0))),
                    suffixIcon: new IconButton(
                      icon: new Icon(Icons.cancel),
                      onPressed: () {
                        myController.clear();
                        // onSearchTextChanged('');
                      },
                    ),
                  ),
                )
              ),
         //   ),
          ),

          /////////////////////////////////////////////
          new Expanded(
            child:
             ListView(
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
      ),
            ),
        ],
      ),
    );
  }   
  }

 