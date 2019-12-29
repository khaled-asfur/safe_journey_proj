import 'package:flutter/material.dart';
import 'package:safe_journey/models/global.dart';
import 'package:safe_journey/models/journey.dart';
import 'package:safe_journey/pages/realtime_screen.dart';
import 'add_attendents.dart';
import '../widgets/header.dart';
import 'package:intl/intl.dart';

class ShowJourney extends StatefulWidget {
  final Journey _journey;
  ShowJourney(this._journey);
  @override
  State<StatefulWidget> createState() {
    return ShowJourneyState();
  }
}

class ShowJourneyState extends State<ShowJourney> {
  @override
  Widget build(BuildContext context) {
    Global.currentPageContext = context;
    DateTime startTime = widget._journey.startTime;
    String formattedStartTime =
        DateFormat("yyyy-MM-dd 'at' h:mm a").format(startTime);
    DateTime endTime = widget._journey.endTime;
    String formattedEndTime = DateFormat("yyyy-MM-dd 'at' h:mm a").format(endTime);
    return Header(
        body: SingleChildScrollView(
            child: new Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
          new Container(
            child: /*new Stack(
              children: <Widget>[
                new*/ Image.network(
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
          new Column(children: <Widget>[
            new Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.description),
                    color: Colors.blueAccent,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (BuildContext context) {
                          return ShowJourney(widget._journey);
                        }),
                      );
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.group),
                    color: Colors.blueAccent,
                    onPressed: () {
                      //Navigator.pushNamed(context, 'people');
                      Navigator.push(
                          context,
                          MaterialPageRoute<bool>(
                              builder: (BuildContext context) =>
                                //People(widget._journey)
                                 AddAttendents(widget._journey)
                                  ));
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.add_location),
                    color: Colors.blueAccent,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (BuildContext context) {
                          return RealTimeScreen(widget._journey);
                        }),
                      );
                    },
                  )
                ]),
            SizedBox(height: 30.0),
         //   new ListTile(
            /*  title: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[*/
                    Container(
                      child: new DataTable(columns: [
                        DataColumn(label:  Text('Journey Name',style:TextStyle(
                        fontFamily: "Chilanka",
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF197278) ,))),
                        DataColumn(label: Text('${widget._journey.name}')),
                      ], rows: [
                        DataRow(cells: [
                          DataCell(Text('Journey Start Date',style:TextStyle(
                        fontFamily: "Chilanka",
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF197278) ,))),
                          DataCell(Text('$formattedStartTime')),
                        ]),
                        DataRow(cells: [
                          DataCell(Text('Journey End Date',style:TextStyle(
                        fontFamily: "Chilanka",
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF197278) ,))),
                          DataCell(Text('$formattedEndTime')),
                        ]),
                        DataRow(cells: [
                          DataCell(Text( 'Journey Description',style:TextStyle(
                        fontFamily: "Chilanka",
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF197278) ,))),
                          DataCell(Text('${widget._journey.description}')),
                        ]),
                        DataRow(cells: [
                          DataCell(Text('Journey Places',
                          style:TextStyle(
                        fontFamily: "Chilanka",
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF197278) ,))),
                          DataCell(Text('${widget._journey.places}')),
                        ]),
                      ]),
                      ),
                    /*
                  ]),
            ),*/
          ])
        ])));
  }
}
