import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final List<String> students = ['ahmad','Saeed','Waleed','Amjad','Wael',];
  final List<String> ages = ['12','13','14','15','17',];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: buildDrawer(context),
        appBar: new AppBar(
          title: Text("Main page"),
        ),
        body: ListView.builder(
            itemBuilder: (context, index) {
              return Row(
                children: <Widget>[
                  Text("name=" + students[index]),
                  Text(" , and age =" + ages[index])
                ],
              );
            },
            itemCount: students.length,
          ),
        );
  }








  Widget buildDrawer(BuildContext context) {
    return Drawer(
        child: Column(
      children: <Widget>[
        AppBar(
          automaticallyImplyLeading:
              false, //بتحدد اذا بدك يخمن اول عنصر في الليست او لا ، وجودها بخرب الليست مشان هيك عملناها فولس
          title: Text("App sections"),
          actions: <Widget>[],
        ),
        ListTile(
          leading: Icon(Icons.create),
          title: Text("create journey"),
          onTap: () {
            Navigator.pushReplacementNamed(context, '/');
          },
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.inbox),
          title: Text("Not finished journeis"),
          onTap: () {
            Navigator.pushReplacementNamed(context, '/');
          },
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.add),
          title: Text("Add dangerous area"),
          onTap: () {
            Navigator.pushReplacementNamed(context, '/');
          },
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.settings),
          title: Text("Settings"),
          onTap: () {
            Navigator.pushReplacementNamed(context, '/');
          },
        ),
        Divider(),
      ],
    ));
  }
}
