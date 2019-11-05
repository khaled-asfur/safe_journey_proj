import '../models/user.dart';
import 'package:rxdart/subjects.dart' as rx ;

class Global {
  static User user;
  static bool visitedWaitingPage=false;
  static int notificationsCount=5;
  static rx.PublishSubject<int> notificationObservable;
}