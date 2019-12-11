import 'package:flutter/material.dart';
import 'package:safe_journey/models/journey.dart';
import 'package:safe_journey/pages/realtime_screen.dart';
import '../widgets/header.dart';
import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nice_button/nice_button.dart';
//import 'admin_people.dart';
import 'home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

class AdminShowJourney extends StatefulWidget {
  final Journey _journey;
  AdminShowJourney(this._journey);
  @override
  State<StatefulWidget> createState() {
    return ShowJourneyState();
  }
}

class ShowJourneyState extends State<AdminShowJourney> {
  var firstColor = Colors.blueAccent, secondColor = Color(0xff36d1dc);
  String name, description, imageUrl;
  String places;
  DateTime startDate, endDate;
  TextEditingController _controllerName = TextEditingController();
  TextEditingController _controllerDes = TextEditingController();
  TextEditingController _controllerPlaces = TextEditingController();

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
  Widget build(BuildContext context) {
    return Header(
        body: new SingleChildScrollView(
      child: new Column(
        children: <Widget>[
          IconButton(
                    icon: Icon(Icons.add_location),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (BuildContext context) {
                          return RealTimeScreen(widget._journey);
                        }),
                      );
                    },
                  ),
          new Container(
            child: new Stack(
              children: <Widget>[
                // Background
                (backgroundImageFile == null)
                    ? new Image.network(
                        '${widget._journey.imageURL}',
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
              SizedBox(height: 15),
              new ListTile(
                title: new TextField(
                  decoration: new InputDecoration(
                      labelText: '${widget._journey.name}',
                      labelStyle: TextStyle(
                          fontFamily: "Caveat",
                          fontWeight: FontWeight.bold,
                          color: Colors.grey)),
                  controller: _controllerName,
                ),
              ),
              SizedBox(height: 15),
              new ListTile(
                title: new TextField(
                  decoration: new InputDecoration(
                      labelText: '${widget._journey.description}',
                      labelStyle: TextStyle(
                          fontFamily: "Caveat",
                          fontWeight: FontWeight.bold,
                          color: Colors.grey)),
                  controller: _controllerDes,
                ),
              ),
              new ListTile(
                title: new TextField(
                  decoration: new InputDecoration(
                      labelText: '${widget._journey.places}',
                      labelStyle: TextStyle(
                          fontFamily: "Caveat",
                          fontWeight: FontWeight.bold,
                          color: Colors.grey)),
                  controller: _controllerPlaces,
                ),
              ),
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
                  label: Text("Add participants to the journey"),
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
                text: "Edit Journy",
                icon: Icons.edit,
                gradientColors: [firstColor, firstColor],
                onPressed: () {
                  if (_controllerName.text != null) {
                    name = _controllerName.text;
                  } else {
                    name = widget._journey.name;
                  }
                  if (_controllerDes.text != null) {
                    description = _controllerName.text;
                  } else {
                    description = widget._journey.description;
                  }
                  if (_controllerPlaces.text != null) {
                    places = _controllerName.text;
                  } else {
                    places = widget._journey.places;
                  }

                  updateData({
                    'name': this.name,
                    'description': description,
                    'places': places
                  });
                },
                background: null,
              )
            ],
            crossAxisAlignment: CrossAxisAlignment.center,
          )
        ],
      ),
      padding: new EdgeInsets.only(bottom: 20.0),
    ));
  }

  updateData(newValues) {
    print(name);
    Firestore.instance
        .collection('journies')
        .document(widget._journey.id)
        .updateData(newValues)
        .catchError((e) {
      print(e);
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
              labelText: "Start Date",
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