//import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:safe_journey/models/global.dart';
import 'package:safe_journey/models/helpers.dart';
import 'package:safe_journey/models/journey.dart';
import 'package:safe_journey/models/user.dart';
import '../widgets/header.dart';
import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
//import 'package:nice_button/nice_button.dart';
//import 'home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

class EditJourney extends StatefulWidget {
  final Journey _journey;
  EditJourney(this._journey);
  @override
  State<StatefulWidget> createState() {
    return EditJourneyState();
  }
}
 String formattedStartTime;
  String formattedEndTime ;
    TextEditingController _controllerStartTime;
        TextEditingController _controllerEndTime;
  String journyid;


class EditJourneyState extends State<EditJourney> {
  var firstColor = Colors.blueAccent, secondColor = Color(0xff36d1dc);
  String name, description, imageUrl;
  String places;
  int distance;
  DateTime startDate, endDate;
  TextEditingController _controllerName; //= TextEditingController();
  TextEditingController _controllerDes; // = TextEditingController();
  TextEditingController _controllerPlaces; //= TextEditingController();
  TextEditingController _controllerDistance;


  File backgroundImageFile;
  Future getImage(bool isBackground) async {
    var result = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (isBackground) {
        backgroundImageFile = result;
      }
    });
  }
@override
  void initState() {
    fillUserData();
    super.initState();
  }
 
  Future<void> fillUserData() async {
   
        setState(() {
          journyid=widget._journey.id;
           name = widget._journey.name;
    description = widget._journey.description;
    places = widget._journey.places;
    distance = widget._journey.distance;
    imageUrl=widget._journey.imageURL;
    DateTime startTime = widget._journey.startTime;
    formattedStartTime =
        DateFormat('yyyy-MM-dd kk:mm').format(startTime);
    DateTime endTime = widget._journey.endTime;
     formattedEndTime = DateFormat('yyyy-MM-dd kk:mm').format(endTime);
        });
  
    _controllerName = TextEditingController(text: name);
    _controllerDes = TextEditingController(text: description);
    _controllerPlaces = TextEditingController(text: places);
    String distanceString = distance.toString();
    _controllerDistance = TextEditingController(text: distanceString);
    _controllerStartTime=TextEditingController(text: formattedStartTime);
          _controllerEndTime=TextEditingController(text: formattedEndTime);

    
  }
//*********************************************************************************** */
  @override
  Widget build(BuildContext context) {
    Global.currentPageContext = context;
  


    /*************************************************************************************************** */
    return Header(
        body: new SingleChildScrollView(
      child: new Column(
        children: <Widget>[
          new Container(
            child: new Stack(
              children: <Widget>[
                // Background
                (backgroundImageFile == null)
                    ? new Image.network(
                        imageUrl,
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
                  child: new Stack(
                    children: <Widget>[
                      new Material(
                        //icon image for profile
                        child: new IconButton(
                          icon: new Image.network(
                            // widget._journey.imageURL,
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
              SizedBox(height: 15),
              new ListTile(
                
                title: new TextField(
                  
                  decoration: new InputDecoration(
                    labelText: "Journy Name",
                   // hintText: _controllerName.text,
                    labelStyle: TextStyle(
                        fontFamily: "Chilanka",
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF197278)),
                  ),
                  controller: _controllerName,
                ),
              ),
              SizedBox(height: 15),
              new ListTile(
                title:new TextField(
                  decoration: new InputDecoration(
                    labelText: 'Journy Description',
                   // hintText: '${widget._journey.description}',
                    labelStyle: TextStyle(
                        fontFamily: "Chilanka",
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF197278)),
                  ),
                  controller: _controllerDes,
                ),
              ),
              new ListTile(
                title: new TextField(
                  decoration: new InputDecoration(
                    labelText: 'Places',
                  //  hintText: '${widget._journey.places}',
                    labelStyle: TextStyle(
                        fontFamily: "Chilanka",
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF197278)),
                  ),
                  controller: _controllerPlaces,
                ),
              ),
              SizedBox(height: 15),
              new ListTile(
                title: new TextField(
                  decoration: new InputDecoration(
                    labelText: 'Allowad Distance',
                   //  hintText:'${widget._journey.distance}' ,
                    labelStyle: TextStyle(
                        fontFamily: "Chilanka",
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF197278)),
                  ),
                  controller: _controllerDistance,
                ),
              ),
              SizedBox(height: 15),
              BasicDateTimeStartField(),
              SizedBox(height: 15),
              BasicDateTimeEndField(),
              SizedBox(height: 15),
              /*new FlatButton.icon(
                  icon: Icon(
                    Icons.add,
                    color: Colors.blueAccent,
                  ),
                  label: Text("Add participants to the journey"),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                    );
                  }),*/
              SizedBox(height: 15),
           RaisedButton.icon(
                    //radius: 20,
                    elevation: 20.0,
                    label: Text("Edit Journy",
                        style: TextStyle(
                          color: Colors.white,
                        )),
                    icon: Icon(
                      Icons.create,
                      color: Colors.white,
                    ),
                    splashColor: Colors.white,
                    color: Color(0xFF197278),
                onPressed: () async {
                  if (_controllerName.text != null) {
                    name = _controllerName.text;
                  } else if (_controllerName.text == null) {
                    name = widget._journey.name;
                  }
                  if (_controllerDes.text != null) {
                    description = _controllerDes.text;
                  } else if (_controllerDes.text == null) {
                    description = widget._journey.description;
                  }
                  if (_controllerPlaces.text != null) {
                    places = _controllerPlaces.text;
                  } else {
                    places = widget._journey.places;
                  }
                  if (_controllerDistance.text != null) {
                   // distanceString = _controllerDistance.text;
                    distance=int.parse(_controllerDistance.text);
                  } else {
                   // distanceString = widget._journey.distance.toString();
                    distance=widget._journey.distance;

                  }
                  //********************* */
                  String imageURL1;
      if (backgroundImageFile != null) {
        Map<String, dynamic> result = await uploadImage(backgroundImageFile, context);
        print('result from signup= $result');
        if (result['success']) imageURL1 = result['imageURL'];
      }
      else imageURL1=imageUrl;

                  Firestore.instance
                      .collection('journies')
                      .document(widget._journey.id)
                      .updateData({
                    'name': name,
                    'description': description,
                    'places': places,
                    'allowedDistance': distance,
                    "imageURL":imageURL1,
                   'startTime': DateTime.parse(_controllerStartTime.text),
                   'endTime':  DateTime.parse(_controllerEndTime.text),


                  }).catchError((e) {
                    print(e);
                  });
                  //  updateData();
                    _onAlertButtonPressed1(context);
                },
              //  background: null,
              )
            ],
            crossAxisAlignment: CrossAxisAlignment.center,
          )
        ],
      ),
      padding: new EdgeInsets.only(bottom: 20.0),
    ));
  }
 _onAlertButtonPressed1(context) {
    Alert(
      context: context,
      type: AlertType.success,
      title: "Done",
      desc: "Update Done",
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
  /* updateData() {
    //final fireStoreInstance = Firestore.instance;

    print(name);
    Firestore.instance
        .collection('journies')
        .document(widget._journey.id)
        .updateData({
                    'name':name,
                    'description': description,
                    //'places': places
                  })
        .catchError((e) {
      print(e);
    });
  }*/
}
 Future<Map<String, dynamic>> uploadImage(File image, BuildContext context,
      {String imageTitle}) async {
   Map<String, dynamic> result = {'success': false, 'uploadURL': null};
    try {
      User user = Global.user;
      String email = user.email + journyid;
      final StorageReference storageRef =
          FirebaseStorage.instance.ref().child(email);
      final StorageUploadTask task = storageRef.putFile(image);
      result['success'] = true;
      result['imageURL'] = await (await task.onComplete).ref.getDownloadURL();
      // print('complete upload');
      // print(task);
    } catch (e) {
      Helpers.showErrorDialog(context, e.message);
    }
    // print('result= $result');
    return result;
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
          controller: _controllerStartTime,
          decoration: new InputDecoration(
              labelText: "Start Date",
              hintText: formattedStartTime,
              icon: Icon(Icons.today,color: Color(0xFF197278),),
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
          controller:_controllerEndTime,
          decoration: new InputDecoration(
              labelText: "ٍEnd Date",
              hintText: formattedEndTime,
              icon: Icon(
                Icons.today,
                color: Color(0xFF197278),
              ),
              labelStyle: TextStyle(
                  fontFamily: "Caveat",
                  fontWeight: FontWeight.bold,
                  color: Colors.grey)),
          onChanged: (dt) {
            // setState(()=>startDate=dt);
          },
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
