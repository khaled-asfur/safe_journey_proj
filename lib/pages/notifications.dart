import 'package:flutter/material.dart';
import '../widgets/my_raised_button.dart';
//TODO:show number of notifications in the main page
//TODO:send notification to the mobile while app isn't running

class Notifications extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: ListView.builder(
        itemCount: 2,
        itemBuilder: (BuildContext context, int index) {
          return Card(
              child: Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Container(
                  padding: EdgeInsets.all(10),
                  height: 100,
                  alignment: Alignment.center,
                  child: Container(
                    child: CircleAvatar(
                        radius: MediaQuery.of(context).size.width * 0.1,
                        backgroundImage: NetworkImage(
                            'https://murtahil.com/wp-content/uploads/2018/07/IMG_43073.jpg'))
                    ,
                  ),
                ),
              ), //*************** */
              Expanded(
                flex: 3,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                          'Ahmad Awwad added you to a journey do you want to join it?'),
                          Container(child:Text('17/10/2019 7:12:58',textAlign: TextAlign.left,style: TextStyle(fontSize: 10),),alignment: Alignment.centerLeft,),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          MyRaisedButton('Join',(){
                            //delete notification from notifications collection
                              //add data to users_journeis collection 
                              //remove from attendents array on journey collection
                          }),
                          RaisedButton(
                            onPressed: () {},
                            child: Text('Decline'),
                          )
                        ],
                      )
                    ]),
              )
            ],
          ));
        },
      ),
    );
  }
}
