import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:safe_journey/models/global.dart';
import 'package:safe_journey/models/journyf.dart';
import 'package:safe_journey/widgets/drawer.dart';
import 'package:safe_journey/widgets/notification_icon.dart';
//import 'package:safe_journey/widgets/user_search_item.dart';

class Header extends StatefulWidget {
  final Widget body;
  final Widget floatingActionButton;

  Header({@required this.body,this.floatingActionButton});

  @override
  _HeaderState createState() => _HeaderState();
}

   var searchController = new TextEditingController();
class _HeaderState extends State<Header> {

  @override
  Widget build(BuildContext context) {

    

    return Scaffold(
        drawer: MyDrawer(),
        appBar: new AppBar(
          actions: <Widget>[
            NotificationIcon(),
            IconButton(
              icon: Icon(Icons.person),
              onPressed: () {},
            )
          ],
          title: _buildSearchTextField(),
        ),
        body:( searchController.text.isEmpty)
          ? widget.body:(userDocs == null )?
       Container(
         child: Center(child: Text("no result found"),),
       )
      
     : FutureBuilder<QuerySnapshot>(
              future: userDocs,
              builder: (context, snapshot) {
                
                if (snapshot.hasData) {
                  return buildSearchResults(snapshot.data.documents);
                } else {
                  return Container(
                      alignment: FractionalOffset.center,
                      child: CircularProgressIndicator());
                }
              }),
        floatingActionButton: this.widget.floatingActionButton==null?null:this.widget.floatingActionButton,
        );
  }

  ListView buildSearchResults(List<DocumentSnapshot> docs) {
    List<UserSearchItem1> userSearchItems = [];

    docs.forEach((DocumentSnapshot doc) {
      Journyf user = Journyf.fromDocument(doc);
      UserSearchItem1 searchItem = UserSearchItem1(user);
      
      userSearchItems.add(searchItem);
    });

    return ListView(
      children: userSearchItems,
    );
  }

  Widget buildNotificationsIcon(BuildContext context) {
    return Stack(
      children: <Widget>[
        new IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              Global.notificationsCount = 0;
              Navigator.pushNamed(context, 'notifications');
            }),
        Global.notificationsCount != 0
            ? new Positioned(
                right: 11,
                top: 11,
                child: new Container(
                  padding: EdgeInsets.all(2),
                  decoration: new BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  constraints: BoxConstraints(
                    minWidth: 14,
                    minHeight: 14,
                  ),
                  child: Text(
                    '${Global.notificationsCount}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            : new Container()
      ],
    );
  }

      Future<QuerySnapshot> userDocs;

 void submit(String searchValue) async {
    Future<QuerySnapshot> users = Firestore.instance
        .collection("journies")
       // .where('name', isGreaterThanOrEqualTo:  searchValue)
        .getDocuments();
        

    setState(() {
      userDocs = users;
    });
  }

  Widget _buildSearchTextField() {
    return Container(
      padding: EdgeInsets.all(5),
      child: TextField(
        controller: searchController,
        maxLines: null,
        textAlignVertical: TextAlignVertical.center,
        decoration: new InputDecoration(
        prefix: Icon(Icons.search),

          focusColor: Colors.purple,

          hintText: "Enter journey name/id",

          filled: true,
          // labelText: "Enter journey name/id",
          fillColor: Colors.white10.withOpacity(0.8),
          enabledBorder: new OutlineInputBorder(
            borderRadius: new BorderRadius.circular(8.0),
            borderSide: new BorderSide(color: Colors.white),
          ),
          //fillColor: Colors.green
        ),
        keyboardType: TextInputType.text,
        style: new TextStyle(
          //color: Colors.white,
          fontSize: 10,
          fontFamily: "Poppins",
        ),
        onChanged: submit,
        onSubmitted: submit,
      ),
    );
    
  }
}
class UserSearchItem1 extends StatelessWidget {
  final Journyf user;

  const UserSearchItem1(this.user);

  @override
  Widget build(BuildContext context) {
    TextStyle boldStyle = TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
    );
if(user.name.toLowerCase()==searchController.text.toLowerCase() || user.name.toLowerCase().contains(searchController.text.toLowerCase())
||  user.name.toLowerCase().startsWith(searchController.text.toLowerCase()) || user.id.toLowerCase().contains(searchController.text.toLowerCase())
)
   { return GestureDetector(
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(user.photoUrl),
            backgroundColor: Colors.grey,
          ),
          title: Text(user.name, style: boldStyle),
          subtitle: Text(user.id),
          trailing: RaisedButton(
                textColor: Colors.white,
                color: Colors.blue,
                child: Text("Add"),
                onPressed: () {},
                shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30.0),
                ),
              ),
        ),
        onTap: () {
         // openProfile(context, user.id);
        });} else return Container(height: 0.0,width: 0.0,);
  }
}
