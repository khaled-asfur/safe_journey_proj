import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:safe_journey/models/auth.dart';
import 'package:carousel_slider/carousel_slider.dart';

//import '../models/auth.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  final Map<String, dynamic> userData = {
    'name': 'fetching..',
    'email': 'fetching..',
    'imageURL': null
  };
  CarouselSlider carouselSlider;
  final databaseReference = Firestore.instance;
  int _current = 0;
  List imgList = [
    'https://images.unsplash.com/photo-1502117859338-fd9daa518a9a?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60',
    'https://images.unsplash.com/photo-1554321586-92083ba0a115?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60',
    'https://images.unsplash.com/photo-1536679545597-c2e5e1946495?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60',
    'https://images.unsplash.com/photo-1543922596-b3bbaba80649?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60',
    'https://images.unsplash.com/photo-1502943693086-33b5b1cfdf2f?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=668&q=80'
  ];
  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  @override
  void initState() {
    fillUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('in homepage build');
    //TODO:add slide show
    return Scaffold(
      drawer: buildDrawer(context),
      appBar: new AppBar(
        title: Text("Main page"),
      ),
      body: ListView(
        children: <Widget>[
          Container(
              decoration: BoxDecoration(color: Colors.grey[200]),
              child: _buildSlideShow()),
          Text('heeeey'),
        ],
      ),
    );
  }

  //*********************** for slide show start *******************/
  Widget _buildSlideShow() {
    double deviceHeight=MediaQuery.of(context).size.height;
    double deviceWidth=MediaQuery.of(context).size.height;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        color: Colors.grey[200],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          carouselSlider = CarouselSlider(
            height: deviceHeight / 1.8,
            initialPage: 0,
            enlargeCenterPage: true,
            autoPlay: false,
            reverse: false,
            enableInfiniteScroll: true,
            autoPlayInterval: Duration(seconds: 2),
            autoPlayAnimationDuration: Duration(milliseconds: 2000),
            pauseAutoPlayOnTouch: Duration(seconds: 10),
            scrollDirection: Axis.horizontal,
            onPageChanged: (index) {
              setState(() {
                _current = index;
              });
            },
            items: imgList.map((imgUrl) {
              return Builder(
                builder: (BuildContext context) {
                  return Card(borderOnForeground: true,
                  color: Colors.white,
                    child:Column(

                    /*mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,*/
                    children: <Widget>[
                      //photo oooooooooooooooooooooooooooooooooooooo
                      
                      Container(
                        width: MediaQuery.of(context).size.width/1.5,
                        margin: EdgeInsets.all( deviceHeight/70),
                        // padding: EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black38,
                              blurRadius:
                                  20.0, // has the effect of softening the shadow
                              spreadRadius:
                                  5.0, // has the effect of extending the shadow
                              offset: Offset(
                                10.0, // horizontal, move right 10
                                10.0, // vertical, move down 10
                              ),
                            )
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: new BorderRadius.circular(10.0),
                          child: Image.network(
                            imgUrl,
                            fit: BoxFit.fill,
                            height: MediaQuery.of(context).size.height / 2.6,
                          ),
                        ),
                      ),
                      Text('Palce description'),
                    ],
                  ),);
                },
              );
            }).toList(),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: map<Widget>(imgList, (index, url) {
              return Container(
                width: 10.0,
                height: 10.0,
                margin: EdgeInsets.symmetric(vertical:deviceHeight/60, horizontal: 2.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _current == index ? Colors.black45 : Colors.white,
                ),
              );
            }),
          ),
          /*SizedBox(
            height: 20.0,
          ),*/
          /*Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              OutlineButton(
                onPressed: goToPrevious,
                child: Text("<"),
              ),
              OutlineButton(
                onPressed: goToNext,
                child: Text(">"),
              ),
            ],
          ),*/
        ],
      ),
    );
  }

  goToPrevious() {
    carouselSlider.previousPage(
        duration: Duration(milliseconds: 300), curve: Curves.ease);
  }

  goToNext() {
    carouselSlider.nextPage(
        duration: Duration(milliseconds: 300), curve: Curves.decelerate);
  }

  //*********************** for slide show end *******************/

  Future<void> fillUserData() async {
    FirebaseUser user = await Auth().currentUser;
    databaseReference
        .collection("users")
        .document(user.email)
        .get()
        .then((DocumentSnapshot doc) {
      if (doc.exists) {
        print(doc.data);
        setState(() {
          userData['name'] = doc.data['name'];
          userData['email'] = user.email;
          userData['imageURL'] = doc.data['imageURL'];
        });
      }
    });
  }

  // Future<String> getUserDataUrl() async {
  //   FirebaseUser user = await Auth().currentUser;
  //   final ref = FirebaseStorage.instance.ref().child(user.email);
  //   var url = await ref.getDownloadURL();
  //   print(url);
  //   return(url);
  // }

  Widget buildDrawer(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    return Drawer(
        child: ListView(
      children: <Widget>[
        AppBar(
          centerTitle: true,
          automaticallyImplyLeading:
              false, //بتحدد اذا بدك يخمن اول عنصر في الليست او لا ، وجودها بخرب الليست مشان هيك عملناها فولس
          title: Text("App sections"),
          actions: <Widget>[],
        ),
        _buildProfile(deviceWidth, deviceHeight),
        Divider(),
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
        ListTile(
          leading: Icon(Icons.exit_to_app),
          title: Text("Logout"),
          onTap: () {
            Auth().logout(context);
            Navigator.pushReplacementNamed(context, '/');
          },
        ),
        Divider(),
      ],
    ));
  }

  _buildProfile(deviceWidth, deviceHeight) {
    bool havaAvalidUrl =
        (userData['imageURL'] != null && userData['imageURL'] != 'noURL');
    return Center(
        child: Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(vertical: deviceHeight * 0.01),
          child: CircleAvatar(
              radius: deviceWidth * 0.1,
              backgroundImage: havaAvalidUrl == false
                  ? AssetImage("images/profile.png")
                  : NetworkImage(userData['imageURL'])),
        ),
        Text(userData['name']),
        Text(userData['email'], style: TextStyle(color: Colors.grey))
      ],
    ));
  }
}
/*
Container(
                      // width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.all(5.0),
                      margin: EdgeInsets.symmetric(horizontal: 10.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(40)),
                      ),
                      child: ClipRRect(
                        borderRadius: new BorderRadius.circular(40.0),
                        child: Image.network(imgUrl),
                      ));
*/
/*Container(
                          width: MediaQuery.of(context).size.width /1.5,
                          margin: EdgeInsets.symmetric(horizontal: 20.0),
                          decoration: BoxDecoration(
                            borderRadius:
                                new BorderRadius.all(Radius.circular(40.5)),
                            color: Colors.green,
                            image: DecorationImage(
                              fit: BoxFit.fill,
                              image: NetworkImage(
                                imgUrl,
                              ),
                            ),
                          ),
                          child: Image.network(imgUrl,height: MediaQuery.of(context).size.height /1.5,
                            
                          fit: BoxFit.cover,),
                        ),*/
