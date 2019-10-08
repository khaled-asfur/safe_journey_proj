import 'package:flutter/material.dart';

class Notifications extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Notifications'),) ,
      body: ListView.builder(
        itemCount: 2,
        itemBuilder: (BuildContext context, int index) {
          return Card(
              child: Row(
            children: <Widget>[
              Expanded(flex: 1,
                child: Container(
                  padding: EdgeInsets.all(10),
                  height: 100,
                  alignment: Alignment.center,
                  child: Container(child:ClipRRect(
        borderRadius: new BorderRadius.circular(50.0),
        child: Image.network(
          'https://murtahil.com/wp-content/uploads/2018/07/IMG_43073.jpg',
          fit: BoxFit.fill,
          height: MediaQuery.of(context).size.height / 2.6,
        ),
      ),),
                ),
              ),//*************** */
              Expanded(flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                
                  children: <Widget>[
                    Text('title'),
                    Text('body'),
                    Row(children: <Widget>[RaisedButton(onPressed: (){},child: Text('ok'),),
                    RaisedButton(onPressed: (){},child: Text('No'),)],)
                  ]),
              )

            ],
          ));
        },
      ),
    );
  }
}
