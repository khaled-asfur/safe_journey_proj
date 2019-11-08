import 'package:flutter/material.dart';
import 'package:safe_journey/models/global.dart';

class NotificationIcon extends StatefulWidget {
  @override
  _NotificationIconState createState() => _NotificationIconState();
}

class _NotificationIconState extends State<NotificationIcon> {
  @override
  Widget build(BuildContext context) {
    Global.notificationObservable.listen((int) {
     if (this.mounted) {
        setState(() {});
      }
    });
    return Stack(
      children: <Widget>[
        new IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              Global.notificationsCount = 0;
              Navigator.pushNamed(context, 'notifications');
            }),
        Global.notificationsCount != 0
            ? new Positioned(
                right: 11,
                top: 11,
                child: new Container(
                  padding: EdgeInsets.all(2),
                  decoration: new BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  constraints: BoxConstraints(
                    minWidth: 14,
                    minHeight: 14,
                  ),
                  child: Text(
                    '${Global.notificationsCount}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            : new Container()
      ],
    );
  }
}
