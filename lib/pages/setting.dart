import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:safe_journey/models/auth.dart';
//import 'package:safe_journey/models/auth.dart';
//import 'package:safe_journey/models/auth.dart';
//import 'package:nice_button/nice_button.dart';
import 'package:safe_journey/models/global.dart';
import 'package:safe_journey/models/user.dart';
import 'package:safe_journey/pages/changepass.dart';
//import 'package:safe_journey/pages/showProfile.dart';
//import 'package:safe_journey/widgets/drawer.dart';

class EditProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Setting",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        //0x .. FF: for full obacity .. 197278: hexadecimal number for the color
        primaryColor: Color(0xFF197278),
        accentColor: Color(0xffAB1717),
      ),
      home: EditProfileScreen(),
    );
  }
}

class EditProfileScreen extends StatefulWidget {
  @override
  State createState() => new EditProfileScreenState();
}

class EditProfileScreenState extends State<EditProfileScreen> {
  var firstColor = Colors.blueAccent, secondColor = Color(0xff36d1dc);
  var nameController = new TextEditingController();
  var emailController = new TextEditingController();
  var phoneController = new TextEditingController();
  var pioController = new TextEditingController();

  File avatarImageFile, backgroundImageFile;

  String sex;
  //******************************************************************* */
  Future<void> fillUserData() async {
    User user = Global.user;
    // print(doc.data['name']);
    // print(user);
    databaseReference
        .collection("users")
        .document(user.id)
        .get()
        .then((DocumentSnapshot doc) {
      if (doc.exists) {
        // print(doc.data);
        setState(() {
          userData['name'] = doc.data['name'];
          userData['email'] = user.email;
          userData['imageURL'] = doc.data['imageURL'];
          userData['background'] = doc.data['background'];

          userData['phoneNumber'] = doc.data['phoneNumber'];
          userData['bio'] = doc.data['bio'];
          userData["uid"] = user.id;
        });
        nameController = new TextEditingController(text: userData["name"]);
        phoneController =
            new TextEditingController(text: userData["phoneNumber"]);
        emailController = new TextEditingController(text: userData["email"]);
        pioController = new TextEditingController(text: userData["bio"]);
      }
    });
  }

//********************************************************************** **********/
  Future getImage(bool isAvatar) async {
    var result = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (isAvatar) {
        avatarImageFile = result;
      } else {
        backgroundImageFile = result;
      }
    });
  }

  //******************************************************************************** */
  final Map<String, dynamic> userData = {
    'name': 'fetching..',
    'email': 'fetching..',
    'phoneNumber': "fetching",
    'bio': "fetching",
    'imageURL': null,
    'background': null,
    "uid": "",
  };
//******************************************************************************** */
  final databaseReference = Firestore.instance;

  @override
  void initState() {
    fillUserData();
    super.initState();
  }

  //*********************************************************************************** */
  @override
  Widget build(BuildContext context) {
    timeDilation = 1.0;
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
        
        appBar: new AppBar(
         title: Text("update Information Profile"),
        ),
        //********************************************************************* */

        //********************************************************** */
        body: SingleChildScrollView(
          child: new Column(
            children: <Widget>[
              new Container(
                child: new Stack(
                  children: <Widget>[
                    //***************************************************************** */ Background
                    (backgroundImageFile == null &&
                            userData['background'] == null)
                        ? new Image.asset(
                            'images/bg_uit.jpg',
                            width: double.infinity,
                            height: screenSize.height / 4,
                            fit: BoxFit.cover,
                          )
                        : (backgroundImageFile != null)
                            ? Image.file(backgroundImageFile,
                                height: screenSize.height / 4,
                                width: double.infinity,
                                            fit: BoxFit.cover,

                                )
                            : Image.network(
                                userData['background'],
                                width: double.infinity,
                                height: screenSize.height / 4,
                                fit: BoxFit.cover,
                              ),

                    //****************************************************************************** */
                    // Button change background
                    new Positioned(
                      child: new Material(
                        child: new IconButton(
                          color: Colors.grey[100],
                          icon: new Image.network(
                            'https://cdn1.iconfinder.com/data/icons/iconmart-web-icons-2/64/camera-512.png',
                            width: 30.0,
                            height: 30.0,
                            fit: BoxFit.cover,
                          ),
                          onPressed: () => getImage(false),
                          padding: new EdgeInsets.all(0.0),
                          highlightColor: Colors.grey,
                          iconSize: 30.0,
                        ),
                        borderRadius:
                            new BorderRadius.all(new Radius.circular(30.0)),
                        color: Colors.grey.withOpacity(0.5),
                      ),
                      right: 5.0,
                      top: 20.0,
                    ),
///////////////////////////////////////////////////////////////////////////////////////////////////////
                    // Avatar and button
                    new Positioned(
                      child: new Stack(
                        children: <Widget>[
                          (avatarImageFile == null && userData['imageURL'] == null)
                              ? new Image.network(
                                  'https://img.pngio.com/deafult-profile-icon-png-image-free-download-searchpngcom-profile-icon-png-673_673.png',
                                  width: 140.0,
                                  height: 140.0,
                                )
                              : new Center(
                                  child: Container(
                                    width: 140.0,
                                    height: 140.0,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: (avatarImageFile!=null)?
                                        FileImage(avatarImageFile):
                                        NetworkImage(userData['imageURL'] )
                                        ,
                                        fit: BoxFit.cover,
                                      ),
                                      borderRadius: BorderRadius.circular(80.0),
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 10.0,
                                      ),
                                    ),
                                  ),
                                ),

                                /************************************************ */
                          new Material(
                            //icon image for profile
                            child: new IconButton(
                              icon: new Image.network(
                                'https://cdn1.iconfinder.com/data/icons/iconmart-web-icons-2/64/camera-512.png',
                                width: 30.0,
                                height: 30.0,
                                fit: BoxFit.cover,
                              ),
                              onPressed: () => getImage(true),
                              padding: new EdgeInsets.all(0.0),
                              highlightColor: Colors.black,
                              iconSize: 40.0,
                            ),
                            borderRadius:
                                new BorderRadius.all(new Radius.circular(40.0)),
                            color: Colors.grey.withOpacity(0.5),
                          ),
                        ],
                      ),
                      top: 70.0,
                      left: MediaQuery.of(context).size.width / 2 - 115 / 2,
                    )
                  ],
                ),
                width: double.infinity,
                //height: 300.0,
              ),
              //***************************************************************** */texrfiled
              new Column(
                children: <Widget>[
                  SizedBox(height: 15.0),
                  //******************************************************* */
                  new ListTile(
                    title: new TextField(
                      controller: nameController,
                      decoration: new InputDecoration(
                          hintText: userData["uid"],
                          labelText: "User Name",
                          labelStyle: TextStyle(
                              fontFamily: "Caveat",
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                          suffixIcon: IconButton(
                              icon: Icon(Icons.cancel),
                              onPressed: () {
                                nameController.clear();
                              })),
                    ),
                  ),
                  //****************************************************************** */
                  SizedBox(height: 15),
                  new ListTile(
                    title: new TextField(
                      controller: pioController,
                      decoration: new InputDecoration(
                          labelText: "Bio",
                          labelStyle: TextStyle(
                              fontFamily: "Caveat",
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                          suffixIcon: IconButton(
                              icon: Icon(Icons.cancel),
                              onPressed: () {
                                pioController.clear();
                              })),
                    ),
                  ),
                  //******************************************************* */
                  SizedBox(height: 15),
                  new ListTile(
                    title: new TextField(
                      controller: phoneController,
                      decoration: new InputDecoration(
                          labelText: "Mobile number",
                          labelStyle: TextStyle(
                              fontFamily: "Caveat",
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                          suffixIcon: IconButton(
                              icon: Icon(Icons.cancel),
                              onPressed: () {
                                phoneController.clear();
                              })),
                    ),
                  ),
                  //*********************************************** */
                  SizedBox(height: 15),
                  new ListTile(
                    
                    title: new TextField(
                                        enabled: false,

                      controller: emailController,
                      decoration: new InputDecoration(
                          labelText: "email adress",
                          labelStyle: TextStyle(
                              fontFamily: "Caveat",
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                          suffixIcon: IconButton(
                              icon: Icon(Icons.cancel),
                              onPressed: () {
                                emailController.clear();
                              })),
                            
                    ),
                  ),
                  //********************************************** */
               
                  //************************************************************** */
                  new FlatButton.icon(
                      icon: Icon(
                        Icons.settings,
                        color: Colors.blueAccent,
                      ),
                      label: Text("setting "),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ChangePass()),
                        );
                      }),
                  SizedBox(height: 15),
                  //*************************************************************** */
                  SizedBox(
                      width: 300.0,
                      height: 50.0,
                      child: RaisedButton.icon(
                          //radius: 20,
                          elevation: 20.0,
                          label: Text("Update Information",
                              style: TextStyle(
                                color: Colors.white,
                              )),
                          icon: Icon(
                            Icons.create,
                            color: Colors.white,
                          ),
                          splashColor: Colors.white,
                          color: Color(0xffAB1717),
                          onPressed: () async {
                            if (nameController.text.isEmpty ||
                                pioController.text.isEmpty ||
                                phoneController.text.isEmpty ||
                                emailController.text.isEmpty) {
                              _onAlertButtonPressed1(context);
                            } else {
                              updateData();
                            }
                          })),
                ],
                crossAxisAlignment: CrossAxisAlignment.center,
              )
            ],
          ),
          padding: new EdgeInsets.only(bottom: 20.0),
        ));
  }

  //*********************************************************************************************** */
  /*Widget _buildProfileImage() {
    bool havaAvalidUrl =
        (userData['imageURL'] != null && userData['imageURL'] != 'noURL');
    return Center(
      child: Container(
        
        width: 140.0,
        height: 140.0,
        //color: Color(0xffAB1717),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: havaAvalidUrl == false
                  ? AssetImage("images/profile.png")
                  : NetworkImage(userData['imageURL']),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(80.0),
          border: Border.all(
            color: Colors.white,
            width: 10.0,
          ),
        ),
      ),
    );
  }*/
  void updateData() {
    
    Auth().update(nameController.text, pioController.text, phoneController.text,
        emailController.text, context,avatarImageFile,backgroundImageFile);

    print(nameController.text);
    //_onAlertButtonPressed(context);
  }

  //******************* */
  /* _onAlertButtonPressed(context) {
    Alert(
      context: context,
      type: AlertType.info,
      title: "Done",
      desc: "Your Information is successfully Update",
      buttons: [
        DialogButton(
          child: Text(
            "OK",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: (){
            Navigator.pop(context);
           },
          width: 120,
        )
      ],
    ).show();
  }*/
  //********************************* */
 _onAlertButtonPressed1(context) {
    Alert(
      context: context,
      type: AlertType.error,
      title: "Error",
      desc: "Some fields are required please full them",
      buttons: [
        DialogButton(
          child: Text(
            "OK",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          width: 120,
        )
      ],
    ).show();
  }

  //*************************** */

//*********************************************************************** */ searchbutton
 
}
