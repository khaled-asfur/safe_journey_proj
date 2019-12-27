import 'package:flutter/material.dart';
import 'package:safe_journey/models/journey.dart';
import 'package:safe_journey/pages/realtime_screen.dart';
import '../widgets/header.dart';
import 'dart:async';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
//import 'admin_people.dart';
import 'add_people.dart';
import 'edit_journey.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

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
  // TextEditingController _controllerName = TextEditingController();
  // TextEditingController _controllerDes = TextEditingController();
  // TextEditingController _controllerPlaces = TextEditingController();

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
    DateTime startTime = widget._journey.startTime;
    String formattedStartTime =
        DateFormat('yyyy-MM-dd kk:mm').format(startTime);
    DateTime endTime = widget._journey.endTime;
    String formattedEndTime = DateFormat('yyyy-MM-dd kk:mm').format(endTime);
    return Header(
      body: SingleChildScrollView(
        child: new Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              new Container(
                child:
                    /*new Stack(
              children: <Widget>[
                new*/
                    Image.network(
                  widget._journey.imageURL,
                  width: double.infinity,
                  height: 600.0,
                  fit: BoxFit.cover,
                ),
                /* ],
            ),*/
                width: double.infinity,
                height: 300.0,
              ),
              Container(
                child: new DataTable(columns: [
                  DataColumn(
                      label: Text('Journey Name',
                          style: TextStyle(
                            fontFamily: "Chilanka",
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF197278),
                          ))),
                  DataColumn(label: Text('${widget._journey.name}',style: TextStyle(color:Colors.grey[700]))),
                ], rows: [
                  DataRow(cells: [
                    DataCell(Text('Journey Description',
                        style: TextStyle(
                          fontFamily: "Chilanka",
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF197278),
                        ))),
                    DataCell(Text('${widget._journey.description}',style: TextStyle(color:Colors.grey[700]))),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('Journey Start Date',
                        style: TextStyle(
                          fontFamily: "Chilanka",
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF197278),
                        ))),
                    DataCell(Text('$formattedStartTime',style: TextStyle(color:Colors.grey[700]))),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('Journey End Date',
                        style: TextStyle(
                          fontFamily: "Chilanka",
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF197278),
                        ))),
                    DataCell(Text('$formattedEndTime',style: TextStyle(color:Colors.grey[700]))),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('Journey Places',
                        style: TextStyle(
                          fontFamily: "Chilanka",
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF197278),
                        ))),
                    DataCell(Text('${widget._journey.places}',style: TextStyle(color:Colors.grey[700]))),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('Allowed Distance',
                        style: TextStyle(
                          fontFamily: "Chilanka",
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF197278),
                        ))),
                    DataCell(Text('${widget._journey.distance}',style: TextStyle(color:Colors.grey[700]))),
                  ]),
                ]),
              ),
              Container(
                child: DataTable(columns: [
                  DataColumn(
                    label: new FlatButton.icon(
                        icon: Icon(
                          Icons.add_location,
                          color: Color(0xFF197278),
                        ),
                        label: Text("Show User Location",style: TextStyle(color: Color(0xFF197278))),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (BuildContext context) {
                              return RealTimeScreen(widget._journey);
                            }),
                          );
                        }),
                  )
                ], rows: [
                  DataRow(cells: [
                    DataCell(
                      new FlatButton.icon(
                          icon: Icon(
                            Icons.add,
                            color: Color(0xFF197278),
                          ),
                          label: Text("Add participants to the journey",style: TextStyle(color: Color(0xFF197278))),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) {
                                return AddPeople(widget._journey);
                              }),
                            );
                          }),
                    ),
                  ]),
                  DataRow(cells: [
                    DataCell(
                      new FlatButton.icon(
                          icon: Icon(
                            Icons.edit,
                            color: Color(0xFF197278),
                          ),
                          label: Text("Edit Journey",style: TextStyle(color: Color(0xFF197278))),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) {
                                return EditJourney(widget._journey);
                              }),
                            );
                          }),
                    )
                  ]),
                  DataRow(cells: [
                    DataCell(
                      new FlatButton.icon(
                          icon: Icon(
                            Icons.av_timer,
                            color: Color(0xFF197278),
                          ),
                          label: Text("Start Journey",style: TextStyle(color: Color(0xFF197278))),
                          onPressed: () {
                            Journey.startJourney(widget._journey.id,context);
                          }),
                    )
                  ]),
                  DataRow(cells: [
                    DataCell(
                      new FlatButton.icon(
                          icon: Icon(
                            Icons.access_time,
                            color: Color(0xFF197278),
                          ),
                          label: Text("End Journey",style: TextStyle(color: Color(0xFF197278))),
                          onPressed: () {
                            Journey.endJourney(widget._journey.id,context);
                          }),
                    )
                  ]),
                ]),
/*FlatButton(
                onPressed: () => {
                  Navigator.push(
                        context,
                        MaterialPageRoute(builder: (BuildContext context) {
                          return RealTimeScreen(widget._journey);
                        }),
                      )
                    },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Icon(Icons.add, 
                    color: Colors.blueAccent,),
                    Text("Add Participants To The Journey")
                  ],
                ),
              ),
FlatButton(
                onPressed: () => {
                  Navigator.push(
                        context,
                        MaterialPageRoute(builder: (BuildContext context) {
                          return RealTimeScreen(widget._journey);
                        }),
                      )
                    },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Icon(Icons.edit, 
                    color: Colors.blueAccent,),
                    Text("Edit Journey")
                  ],
                ),
              ),
              FlatButton(
                onPressed: () => {
                  Navigator.push(
                        context,
                        MaterialPageRoute(builder: (BuildContext context) {
                          return RealTimeScreen(widget._journey);
                        }),
                      )
                    },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Icon(Icons.av_timer, 
                    color: Colors.blueAccent,),
                    Text("Start Journey")
                  ],
                ),
              ),
              FlatButton(
                onPressed: () => {
                  Navigator.push(
                        context,
                        MaterialPageRoute(builder: (BuildContext context) {
                          return RealTimeScreen(widget._journey);
                        }),
                      )
                    },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Icon(Icons.access_time, 
                    color: Colors.blueAccent,),
                    Text("End Journey")
                  ],
                ),
              ),
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
                  }),*/
              ),
            ]),
      ),
    );
  }
  
}
