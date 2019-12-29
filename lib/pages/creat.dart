import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:safe_journey/models/auth.dart';

//import 'add_people.dart';
//import 'package:safe_journey/pages/add_people.dart';

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:safe_journey/models/global.dart';
//import 'package:rflutter_alert/rflutter_alert.dart';

class Create extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Global.currentPageContext = context;
    return new Scaffold(
      appBar: new AppBar(
        title: Text("Create Journy"),
      ),
      body: new EditProfileScreen(),
    );
  }
}

class EditProfileScreen extends StatefulWidget {
  @override
  State createState() => new EditProfileScreenState();
}

bool isLoading = false;

final descriptionController = new TextEditingController();
final startController = new TextEditingController();
final distanceController = new TextEditingController();
final placeseController = new TextEditingController();
final endController = new TextEditingController();
final nameController = new TextEditingController();

TextEditingController idController;

//**************************************************** */
var initial = new Random().nextInt(10000000).toString();
StreamSubscription<DocumentSnapshot> subscription;
var d = "5";

final DocumentReference documentReference =
    Firestore.instance.document("journies/$d");

//************************* */

class EditProfileScreenState extends State<EditProfileScreen> {
  @override
  void initState() {
    super.initState();
    subscription = documentReference.snapshots().listen((datasnapshot) {
      //FINDING A SPECIFICDOCUMENT IS EXISTING INSIDE A COLLECTION

      if (datasnapshot.exists) {
        setState(() {
          initial = new Random().nextInt(100000).toString();
          initState();
        });
      } else {
        initial = initial;
      }
    });
    idController = new TextEditingController(text: initial);
  }

  var firstColor = Colors.blueAccent, secondColor = Color(0xff36d1dc);

  File _image, backgroundImageFile;
  //********************************* */

  //************************************************************ */

  String sex;

  Future getImage(bool isAvatar) async {
    var result = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (isAvatar) {
        _image = result;
      } else {
        backgroundImageFile = result;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    timeDilation = 1.0; //background code

    return new SingleChildScrollView(
      child: new Column(
        children: <Widget>[
          new Container(
            child: new Stack(
              children: <Widget>[
                // Background
                (backgroundImageFile == null)
                    ? new Image.asset(
                        '',
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

                new Positioned(
                  //الصورة الشخصية
                  child: new Stack(
                    children: <Widget>[
                      (_image == null)
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
                                    image: FileImage(_image),
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
                            color: Color(0xFF197278),
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
                  title: new Container(
                padding: EdgeInsets.only(left: 30.0),
                child: new TextFormField(
                  controller: idController,
                  enabled: false,
                  //initialValue: initial,

                  decoration: new InputDecoration(
                    labelText: "Journy ID",
                    labelStyle: TextStyle(
                        fontFamily: "Chilanka",
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF197278)),
                    // hintText: "Journy ID",
                  ),
                ),
              )
                  ///////////////////////////////////////////////////////////
                  ),
              SizedBox(height: 15),
              new ListTile(

                  //  leading: const Icon(Icons.phone),
                  title: new Container(
                padding: EdgeInsets.only(left: 30.0),
                child: new TextFormField(
                  controller: nameController,
                  decoration: new InputDecoration(
                      labelText: "Journy Name",
                      labelStyle: TextStyle(
                          fontFamily: "Caveat",
                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
                      suffixIcon: IconButton(
                          icon: Icon(Icons.cancel),
                          onPressed: () {
                            nameController.clear();
                          })
                      // hintText: "Journy ID",
                      ),
                ),
              )),
              SizedBox(height: 15),
              new ListTile(
                  title: new Container(
                padding: EdgeInsets.only(left: 30.0),
                child: new TextFormField(
                  controller: descriptionController,
                  decoration: new InputDecoration(
                      labelText: "Journy Description",
                      labelStyle: TextStyle(
                          fontFamily: "Caveat",
                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
                      suffixIcon: IconButton(
                          icon: Icon(Icons.cancel),
                          onPressed: () {
                            descriptionController.clear();
                          })),
                ),
              )),
              SizedBox(height: 15),
              new ListTile(
                  title: new Container(
                padding: EdgeInsets.only(left: 30.0),
                child: new TextFormField(
                  controller: placeseController,
                  decoration: new InputDecoration(
                      labelText: "Places",
                      labelStyle: TextStyle(
                          fontFamily: "Caveat",
                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
                      suffixIcon: IconButton(
                          icon: Icon(Icons.cancel),
                          onPressed: () {
                            distanceController.clear();
                          })),
                ),
              )),
              SizedBox(height: 15),
              new ListTile(
                  title: new Container(
                padding: EdgeInsets.only(left: 30.0),
                child: new TextFormField(
                  controller: distanceController,
                  decoration: new InputDecoration(
                      labelText: "Allowed Distance",
                      labelStyle: TextStyle(
                          fontFamily: "Caveat",
                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
                      suffixIcon: IconButton(
                          icon: Icon(Icons.cancel),
                          onPressed: () {
                            distanceController.clear();
                          })),
                ),
              )),
              SizedBox(height: 15),
              BasicDateTimeStartField(),
              SizedBox(height: 15),
              BasicDateTimeEndField(),
              SizedBox(height: 15),
            /*  new FlatButton.icon(
                  icon: Icon(
                    Icons.add,
                    color: Color(0xFF197278),
                  ),
                  label: Text("Add participants to the trip"),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddPeople()),
                    );
                  }),*/
              SizedBox(height: 15),
              SizedBox(
                width: 300.0,
                height: 50.0,
                child: RaisedButton.icon(
                    //radius: 20,
                    elevation: 20.0,
                    label: Text("Creat Journy",
                        style: TextStyle(
                          color: Colors.white,
                        )),
                    icon: Icon(
                      Icons.create,
                      color: Colors.white,
                    ),
                    splashColor: Colors.white,
                    color: Color(0xFF197278),
                    onPressed: () {
                      if (descriptionController.text.isEmpty ||
                          endController.text.isEmpty ||
                          nameController.text.isEmpty ||
                          startController.text.isEmpty ||
                          _image == null ||
                          distanceController.text.isEmpty ||
                          placeseController.text.isEmpty) {
                        _onAlertButtonPressed1(context);
                      } else {
                        saveData();
                      }
                    }),
              ),
              SizedBox(height: 12),
            
            ],
            crossAxisAlignment: CrossAxisAlignment.center,
          )
        ],
      ),
      padding: new EdgeInsets.only(bottom: 20.0),
    );
  }

//****************************************** */
  void saveData() {
    // print(idController.text);

    setState(() {
      isLoading = true;
    });

    Auth()
        .doit(
            idController.text,
            descriptionController.text,
            int.parse(distanceController.text),
            DateTime.parse(endController.text),
            nameController.text,
            DateTime.parse(startController.text),
            context,
            _image,
            placeseController.text)
        .then((bool result) {
      if (result == false) {
        setState(() {
          isLoading = false; //to stop the loading circle
        });
      }
    });
    _onAlertButtonPressed(context);
  }


  _onAlertButtonPressed(context) {
    Alert(
      context: context,
      type: AlertType.info,
      title: "Done",
      desc: "Your trip session was created correctly",
      buttons: [
        DialogButton(
          child: Text(
            "OK",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            nameController.clear();
            startController.clear();
            endController.clear();
            descriptionController.clear();
            distanceController.clear();
            placeseController.clear();

            setState(() {
              _image=null;
              initial = new Random().nextInt(10000000).toString();
            });

            idController.text = initial;
            Navigator.pop(context);
          },
          width: 120,
        )
      ],
    ).show();
  }

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
}

//**************************************** */ date and time widgaes
class BasicDateTimeStartField extends StatelessWidget {
  final format = DateFormat("yyyy-MM-dd HH:mm");
  final myController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Global.currentPageContext = context;
    return Column(
      children: <Widget>[
        // Text('Start Date'),
        // new Icon(Icons.time_to_leave),

        new Container(
            padding: EdgeInsets.only(right: 15.0),
            child: DateTimeField(
              controller: startController,
              decoration: new InputDecoration(
                  suffixIcon: IconButton(
                      icon: Icon(
                        Icons.cancel,
                        
                      ),
                      onPressed: () {
                        startController.clear();
                      }),
                  labelText: "ٍStart Date",
                  icon: Icon(
                    Icons.today,
                    color: Color(0xFF197278),
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
            )),
      ],
    );
  }
}

class BasicDateTimeEndField extends StatelessWidget {
  final format = DateFormat("yyyy-MM-dd HH:mm");

  @override
  Widget build(BuildContext context) {
    Global.currentPageContext = context;
    return Column(
      children: <Widget>[
        new Container(
            padding: EdgeInsets.only(right: 15.0),
            child: DateTimeField(
              controller: endController,
              decoration: new InputDecoration(
                  suffixIcon: IconButton(
                      icon: Icon(
                        Icons.cancel,
                      ),
                      onPressed: () {
                        endController.clear();
                      }),
                  labelText: "ٍEnd Date",
                  icon: Icon(
                    Icons.today,
                    color: Color(0xFF197278),
                  ),
                  labelStyle: TextStyle(
                      fontFamily: "Caveat",
                      fontWeight: FontWeight.bold,
                      color: Colors.grey
                      
                      
                      )),
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
            )),
      ],
    );
  }
}
