import 'package:flutter/material.dart';
import 'package:safe_journey/models/global.dart';
import 'package:safe_journey/widgets/drawer.dart';
import 'package:safe_journey/widgets/notification_icon.dart';

class Header extends StatelessWidget {
  final Widget body;
  final Widget floatingActionButton;
  Header({@required this.body,this.floatingActionButton});
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
        body: body,
        floatingActionButton: this.floatingActionButton==null?null:this.floatingActionButton,
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

  Widget _buildSearchTextField() {
    return Container(
      padding: EdgeInsets.all(5),
      child: TextField(
        maxLines: null,
        textAlignVertical: TextAlignVertical.center,
        decoration: new InputDecoration(
          focusColor: Colors.white,
          hintText: "Enter journey name/id",
          filled: true,
          fillColor: Colors.white10.withOpacity(0.8),
          enabledBorder: new OutlineInputBorder(
            borderRadius: new BorderRadius.circular(8.0),
            borderSide: new BorderSide(color: Colors.white),
          ),
        ),
        keyboardType: TextInputType.text,
        style: new TextStyle(
          fontSize: 10,
          fontFamily: "Poppins",
        ),
      ),
    );
  }
}
