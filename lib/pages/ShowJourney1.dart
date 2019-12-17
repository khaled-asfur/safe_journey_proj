import 'package:flutter/material.dart';
import 'package:safe_journey/models/journey.dart';
import 'package:safe_journey/pages/add_attendents.dart';
import 'package:safe_journey/pages/realtime_screen.dart';
import 'people.dart';
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
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (BuildContext context) {
                          return AddAttendents(widget._journey);
                        }),
                      );
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.group),
                    onPressed: () {
                      //Navigator.pushNamed(context, 'people');
                      Navigator.push(
                          context,
                          MaterialPageRoute<bool>(
                              builder: (BuildContext context) =>
                                  People(widget._journey)));
                    },
                  ),
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
                        DataColumn(label: Text('${widget._journey.name}')),
                        DataColumn(label: Text('${widget._journey.id}')),
                      ], rows: [
                        DataRow(cells: [
                          DataCell(Text('Start Date')),
                          DataCell(Text('$formattedStartTime')),
                        ]),
                        DataRow(cells: [
                          DataCell(Text('End Date')),
                          DataCell(Text('$formattedEndTime')),
                        ]),
                        DataRow(cells: [
                          DataCell(Text('Description')),
                          DataCell(Text('${widget._journey.description}')),
                        ]),
                        DataRow(cells: [
                          DataCell(Text('Places')),
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
