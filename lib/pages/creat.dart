import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nice_button/nice_button.dart';

import 'home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

class Create extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new EditProfileScreen(),
    );
  }
}

class EditProfileScreen extends StatefulWidget {
  @override
  State createState() => new EditProfileScreenState();
}

class EditProfileScreenState extends State<EditProfileScreen> {
  var firstColor = Colors.blueAccent, secondColor = Color(0xff36d1dc);

  File avatarImageFile, backgroundImageFile;

  String sex;

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

  @override
  Widget build(BuildContext context) {
    timeDilation = 1.0;

    return new SingleChildScrollView(
      child: new Column(
        children: <Widget>[
          new Container(
            child: new Stack(
              children: <Widget>[
                // Background
                (backgroundImageFile == null)
                    ? new Image.asset(
                        'images/bg_uit.jpg',
                        width: double.infinity,
                        height: 200.0,
                        fit: BoxFit.cover,
                      )
                    : new Image.file(
                        backgroundImageFile,
                        width: double.infinity,
                        height: 200.0,
                        fit: BoxFit.cover,
                      ),

                // Button change background
                /* new Positioned(
                  child: new Material(
                    child: new IconButton(
                      color: Colors.grey[100],
                      icon: new Image.asset(
                        'camera.png',
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
                ),*/
///////////////////////////////////////////////////////////////////////////////////////////////////////
                // Avatar and button
                new Positioned(
                  child: new Stack(
                    children: <Widget>[
                      (avatarImageFile == null)
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
                                    image: FileImage(avatarImageFile),
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: BorderRadius.circular(80.0),
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 10.0,
                                  ),
                                ),
                              ),
                            )

                      /* new Material(
                              child: new  Image.file(
                                avatarImageFile,
                                width: 140.0,
                                height: 140.0,
                                //fit: BoxFit.cover,
                              ),
                              borderRadius: new BorderRadius.all(
                                  new Radius.circular(140.0)),
                                  
                                  
                            ),*/
                      ////////////////////////////////////////////////////////////////////
                      ,
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
            height: 200.0,
          ),
          new Column(
            children: <Widget>[
              new ListTile(
                //  leading: const Icon(Icons.person),
                title: new TextField(
                  decoration: new InputDecoration(
                      labelText: "Journy ID",
                      labelStyle: TextStyle(
                          fontFamily: "Chilanka",
                          fontWeight: FontWeight.bold,
                          color: Colors.grey)

                      // hintText: "Journy ID",
                      ),
                ),

                ///////////////////////////////////////////////////////////
              ),

              SizedBox(height: 15),
              new ListTile(
                //  leading: const Icon(Icons.phone),
                title: new TextField(
                  decoration: new InputDecoration(
                      labelText: "Journy Name",
                      labelStyle: TextStyle(
                          fontFamily: "Caveat",
                          fontWeight: FontWeight.bold,
                          color: Colors.grey)

                      // hintText: "Journy ID",
                      ),
                ),
              ),
              SizedBox(height: 15),

              new ListTile(
                //leading: const Icon(Icons.email),

                title: new TextField(
                  decoration: new InputDecoration(
                      labelText: "Journy Description",
                      labelStyle: TextStyle(
                          fontFamily: "Caveat",
                          fontWeight: FontWeight.bold,
                          color: Colors.grey)),
                ),
              ),
              /*  const Divider(
                height: 10.0,
              ),*/
              //
              SizedBox(height: 15),
              BasicDateTimeStartField(),
              SizedBox(height: 15),
              BasicDateTimeStartField(),
              SizedBox(height: 15),
              new FlatButton.icon(
                  icon: Icon(
                    Icons.add,
                    color: Colors.blueAccent,
                  ),
                  label: Text("Add participants to the trip"),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                    );
                  }),
              SizedBox(height: 15),

              NiceButton(
                radius: 20,
                padding: const EdgeInsets.all(15),
                text: "Creat Journy",
                icon: Icons.create,
                gradientColors: [firstColor, firstColor],
                onPressed: () {
                  addDataTofirebaseUnknown();
                },
                background: null,
              )
            ],
            crossAxisAlignment: CrossAxisAlignment.center,
          )
        ],
      ),
      padding: new EdgeInsets.only(bottom: 20.0),
    );
  }

  addDataTofirebaseUnknown() {
    final fireStoreInstance = Firestore.instance;
    fireStoreInstance.collection('students').add({
      'name': 'ahmad',
      'phoneNumber': 0564444555,
      'age': 15,
      'lol': 'loooool'
    });
  }
}

class BasicDateTimeStartField extends StatelessWidget {
  final format = DateFormat("yyyy-MM-dd HH:mm");
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        // Text('Start Date'),
        // new Icon(Icons.time_to_leave),

        DateTimeField(
          decoration: new InputDecoration(
              labelText: "ٍStart Date",
              icon: Icon(Icons.today),
              labelStyle: TextStyle(
                  fontFamily: "Caveat",
                  fontWeight: FontWeight.bold,
                  color: Colors.grey)),
          format: format,
          onShowPicker: (context, currentValue) async {
            final date = await showDatePicker(
                context: context,
                firstDate: DateTime(1900),
                initialDate: currentValue ?? DateTime.now(),
                lastDate: DateTime(2100));
            if (date != null) {
              final time = await showTimePicker(
                context: context,
                initialTime:
                    TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
              );
              return DateTimeField.combine(date, time);
            } else {
              return currentValue;
            }
          },
        ),
      ],
    );
  }
}

class BasicDateTimeEndField extends StatelessWidget {
  final format = DateFormat("yyyy-MM-dd HH:mm");

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        DateTimeField(
          decoration: new InputDecoration(
              labelText: "ٍEnd Date",
              icon: Icon(
                Icons.today,
              ),
              labelStyle: TextStyle(
                  fontFamily: "Caveat",
                  fontWeight: FontWeight.bold,
                  color: Colors.grey)),
          format: format,
          onShowPicker: (context, currentValue) async {
            final date = await showDatePicker(
                context: context,
                firstDate: DateTime(1900),
                initialDate: currentValue ?? DateTime.now(),
                lastDate: DateTime(2100));
            if (date != null) {
              final time = await showTimePicker(
                context: context,
                initialTime:
                    TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
              );
              return DateTimeField.combine(date, time);
            } else {
              return currentValue;
            }
          },
        ),
      ],
    );
  }
}
