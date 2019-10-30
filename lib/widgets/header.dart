import 'package:flutter/material.dart';
import 'package:safe_journey/widgets/drawer.dart';
class Header extends StatelessWidget {
  final Widget body;
  Header({this.body});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
            drawer: MyDrawer(),
            appBar: new AppBar(
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.notifications),
                  onPressed: () {
                    Navigator.pushNamed(context, 'notifications');
                  },
                ),
                IconButton(
                  icon: Icon(Icons.person),
                  onPressed: () {},
                )
              ],
              title: _buildSearchTextField(),
            ),
            body:body
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